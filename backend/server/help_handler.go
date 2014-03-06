package server

import (
	"encoding/json"
	"log"
	"net/http"
)

func (s *Server) handleHelp(w http.ResponseWriter, r *http.Request) {
    w.Header().Add("Content-Type", "application/json")
	data, err := getJSONRequest(r)
    log.Printf("New request: %+v\nData: %+v\nErr: %+v", r, data, err)
	if err != nil {
		returnError(400, "Invalid request", w)
		return
	}

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
		returnError(404, "Error while getting user data", w)
		return
	}

	switch r.Method {
	case "POST":
		helpRequest, err := s.model.GetActiveRequestByRequester(user)
		if err != nil {
			log.Printf("Error while getting active request: %+v", err)
			returnError(500, "Couldn't create request", w)
		}
		longitude, ok := data["longitude"].(float64)
		if !ok {
			returnError(400, "Invalid request: longitude missing", w)
			return
		}
		latitude, ok := data["latitude"].(float64)
		if !ok {
			returnError(400, "Invalid request: latitude missing", w)
			return
		}
		helpRequest.SetRequesterPosition(longitude, latitude)
		if precision, ok := data["precision"].(float64); ok {
			helpRequest.RequesterPosPrecision = precision
		}
		err = helpRequest.Save()
		if err != nil {
			log.Printf("Error while saving help request: %+v", err)
			returnError(500, "Couldn't save request", w)
			return
		}
		json.NewEncoder(w).Encode(user)
		return
	default:
		returnError(405, "Not implemented", w)
		return
	}
}
