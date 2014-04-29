package server

import (
	"encoding/json"
	"log"
	"net/http"

	"hackcessangels/backend/model"
)

// ApiUser represents a user as exposed in the public API. This is done so we can
// decouple the internal representation from the external one.
type ApiUser struct {
	Email          *string               `json:"email,omitempty"`
	Password       *string               `json:"password,omitempty"`
	Name           *string               `json:"name,omitempty"`
	Description    *string               `json:"description,omitempty"`
	Image          *[]byte               `json:"image,omitempty"`
	Phone          *string               `json:"phone,omitempty"`
	Disability     *string               `json:"disability,omitempty"`
	DisabilityType *model.DisabilityType `json:"disabilityType,omitempty"`
	PushToken      *string               `json:"pushToken,omitempty"`
	IsAgent        *bool                 `json:"is_agent,omitempty"`
}

// Returns a new ApiUser suitable for external transmission from the internal
// user representation.
func NewApiUser(u *model.User, private bool) *ApiUser {
	au := new(ApiUser)
	au.Email = &u.Email
	au.Name = &u.Name
	au.Description = &u.Description
	au.Disability = &u.Disability
	au.DisabilityType = &u.DisabilityType
	au.Phone = &u.Phone
	au.Image = &u.Image
	au.IsAgent = &u.IsAgent
	if private {
		au.PushToken = &u.PushToken
	}
	return au
}

// Fills the content of an internal (storage) User from the external representation.
// All security and authorization checks must have been done before calling this
// method.
func (au *ApiUser) fillStorageUser(u *model.User) (err error) {
	if au.Email != nil {
		u.Email = *au.Email
	}
	if au.Password != nil {
		err = u.SetPassword(*au.Password)
	}
	if au.Name != nil {
		u.Name = *au.Name
	}
	if au.Description != nil {
		u.Description = *au.Description
	}
	if au.Disability != nil {
		u.Disability = *au.Disability
	}
	if au.DisabilityType != nil {
		u.DisabilityType = *au.DisabilityType
	}
	if au.Phone != nil {
		u.Phone = *au.Phone
	}
	if au.Image != nil {
		u.Image = *au.Image
	}
	if au.PushToken != nil {
		u.PushToken = *au.PushToken
	}
	if au.IsAgent != nil {
		u.IsAgent = *au.IsAgent
	}
	return err
}

func (s *Server) handleUserLogin(w http.ResponseWriter, r *http.Request) {
	// Data holds the input JSON structure; modify it to add new parameters
	var data struct {
		Email    *string `json:"email,omitempty" schema:"email"`
		Password *string `json:"password,omitempty" schema:"password"`
	}
	w.Header().Add("Content-Type", "application/json")
	err := getJSONRequest(r, &data)
	if err != nil {
		log.Print(err)
		returnError(400, "Invalid request", w)
		return
	}

	switch r.Method {
	case "POST":
		if data.Email == nil {
			returnError(400, "Invalid request: email missing", w)
			return
		}
		if data.Password == nil {
			returnError(400, "Invalid request: password missing", w)
			return
		}
		user, err := s.model.GetUserByEmail(*data.Email)
		if err != nil {
			returnError(403, "Unknown user", w)
			return
		}
		if !user.VerifyPassword(*data.Password) {
			returnError(403, "Unknown user", w)
			return
		}
		session, _ := s.store.Get(r, "user")
		session.Values["email"] = user.Email
		session.Save(r, w)
		json.NewEncoder(w).Encode(NewApiUser(user, true))
	default:
		returnError(405, "Not implemented", w)
	}
}

func (s *Server) handleUser(w http.ResponseWriter, r *http.Request) {
	// Data holds the input JSON structure; modify it to add new parameters
	var data struct {
		Email    *string  `json:"email,omitempty" schema:"email"`
		Password *string  `json:"password,omitempty" schema:"password"`
		Data     *ApiUser `json:"data,omitempty"`
	}

	// We always return JSON
	w.Header().Add("Content-Type", "application/json")
	err := getJSONRequest(r, &data)
	if err != nil {
		log.Print(err)
		returnError(400, "Invalid request", w)
		return
	}

	switch r.Method {
	case "GET":
		// GET returns the current logged in user
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
		if data.Email == nil {
			returnError(400, "Invalid email in request", w)
			return
		}
		if loggedEmail != *data.Email {
			returnError(403, "Unauthorized", w)
			return
		}
		user, err := s.model.GetUserByEmail(loggedEmail)
		if err != nil {
			returnError(404, "Error while getting user data", w)
			return
		}
		au := NewApiUser(user, true)
		json.NewEncoder(w).Encode(au)
		return
	case "POST":
		// POST creates a new user
		if data.Email == nil {
			returnError(400, "Invalid request: email missing", w)
			return
		}
		if data.Password == nil {
			returnError(400, "Invalid request: password missing", w)
			return
		}
		user, err := s.model.GetUserByEmail(*data.Email)
		if err == nil {
			returnError(403, "User already exists", w)
			return
		}
		user, err = s.model.CreateUser(*data.Email, *data.Password)
		if err != nil {
			returnError(500, "Unable to create user", w)
			return
		}

		// Log the user right away
		session, _ := s.store.Get(r, "user")
		session.Values["email"] = user.Email
		session.Save(r, w)
		json.NewEncoder(w).Encode(NewApiUser(user, true))
		return
	case "PUT":
		// PUT modifies the current logged in user
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

		if data.Data == nil {
			log.Printf("Invalid request: %s", data)
			returnError(400, "Invalid request", w)
			return
		}
		if data.Data.Email == nil || loggedEmail != *data.Data.Email {
			returnError(403, "You can only modify your own profile!", w)
			return
		}

		user, err := s.model.GetUserByEmail(loggedEmail)
		if err != nil {
			returnError(404, "User not found", w)
			return
		}

		data.Data.fillStorageUser(user)

		err = user.Save()
		if err != nil {
			returnError(500, "Unable to save modifications", w)
			return
		}
		json.NewEncoder(w).Encode(NewApiUser(user, true))
		return
	case "DELETE":
		// DELETE deletes the current user
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
