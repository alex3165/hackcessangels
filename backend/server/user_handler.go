package server

import (
	"encoding/json"
	"log"
	"net/http"

	"hackcessangels/backend/model"
)

func (s *Server) handleUserLogin(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("Content-Type", "application/json")
	data, err := getJSONRequest(r)
    log.Printf("New request: %+v\nData: %+v\nErr: %+v", r, data, err)
	if err != nil {
		log.Print(err)
		returnError(400, "Invalid request", w)
		return
	}

	switch r.Method {
	case "POST":
		var email, password string
		email, ok := data["email"].(string)
		if !ok {
			returnError(400, "Invalid request: email missing", w)
			return
		}
		password, ok = data["password"].(string)
		if !ok {
			returnError(400, "Invalid request: password missing", w)
			return
		}
		user, err := s.model.GetUserByEmail(email)
		if err != nil {
			returnError(403, "Unknown user", w)
			return
		}
		if !user.VerifyPassword(password) {
			returnError(403, "Unknown user", w)
			return
		}
		session, _ := s.store.Get(r, "user")
		session.Values["email"] = user.Email
		session.Save(r, w)
	default:
		returnError(405, "Not implemented", w)
	}
}

func (s *Server) handleUser(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("Content-Type", "application/json")
	data, err := getJSONRequest(r)
    log.Printf("New request: %+v\nData: %+v\nErr: %+v", r, data, err)
	if err != nil {
		returnError(400, "Invalid request", w)
		return
	}

	switch r.Method {
	case "GET":
		session, err := s.store.Get(r, "user")
		if err != nil {
			returnError(401, "Please log in", w)
			return
		}

		loggedEmail, ok := session.Values["email"].(string)
		if !ok {
			returnError(401, "Please log in", w)
			return
		}
		requestEmail, ok := data["email"].(string)
		if !ok {
			returnError(400, "Invalid email in request", w)
			return
		}
		if loggedEmail != requestEmail {
			returnError(403, "Unauthorized", w)
			return
		}
		user, err := s.model.GetUserByEmail(loggedEmail)
		if err != nil {
			returnError(404, "Error while getting user data", w)
			return
		}
		json.NewEncoder(w).Encode(user)
		return
	case "POST":
		var email, password string
		email, ok := data["email"].(string)
		if !ok {
			returnError(400, "Invalid request: email missing", w)
			return
		}
		password, ok = data["password"].(string)
		if !ok {
			returnError(400, "Invalid request: password missing", w)
			return
		}
		user, err := s.model.GetUserByEmail(email)
		if err == nil {
			returnError(403, "User already exists", w)
			return
		}
		user, err = s.model.CreateUser(email, password)
		if err != nil {
			returnError(500, "Unable to create user", w)
			return
		}

		// Log the user right away
		session, _ := s.store.Get(r, "user")
		session.Values["email"] = user.Email
		session.Save(r, w)
		json.NewEncoder(w).Encode(user)
		return
	case "PUT":
		session, err := s.store.Get(r, "user")
		if err != nil {
			returnError(401, "Please log in", w)
			return
		}
		loggedEmail, ok := session.Values["email"].(string)
		if !ok {
			returnError(401, "Please log in", w)
			return
		}

		requestedUser, ok := data["data"].(map[string]interface{})
		if !ok {
			log.Printf("Invalid request: %s", data)
			returnError(400, "Invalid request", w)
			return
		}
		requestedEmail, ok := requestedUser["email"]
		if !ok || loggedEmail != requestedEmail {
			returnError(403, "You can only modify your own profile!", w)
			return
		}

		user, err := s.model.GetUserByEmail(loggedEmail)
		if err != nil {
			returnError(404, "User not found", w)
			return
		}

		user.Name, ok = requestedUser["name"].(string)
		if !ok {
			returnError(400, "Invalid user data name", w)
			return
		}
		user.Description, ok = requestedUser["description"].(string)
		if !ok {
			returnError(400, "Invalid user data description", w)
			return
		}
		user.Disability, ok = requestedUser["disability"].(string)
		if !ok {
			returnError(400, "Invalid user data disability", w)
			return
		}
		dType, ok := requestedUser["disabilityType"].(float64)
		if !ok {
			returnError(400, "Invalid user data disabilityType", w)
			return
		}
		user.DisabilityType = model.DisabilityType(int(dType))
		err = user.Save()
		if err != nil {
			returnError(500, "Unable to save modifications", w)
			return
		}
		json.NewEncoder(w).Encode(user)
		return
	case "DELETE":
		session, err := s.store.Get(r, "user")
		if err != nil {
			returnError(401, "Please log in", w)
			return
		}
		loggedEmail, ok := session.Values["email"].(string)
		if !ok {
			returnError(401, "Please log in", w)
			return
		}
		user, err := s.model.GetUserByEmail(loggedEmail)
		if err != nil {
			returnError(404, "User not found", w)
			return
		}
		err = user.Delete()
		if err != nil {
			returnError(500, "Unable to delete user", w)
			return
		}
		json.NewEncoder(w).Encode("Deleted")
		return
	default:
	}
}
