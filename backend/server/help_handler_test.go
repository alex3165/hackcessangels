package server

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"hackcessangels/backend/model"
)

func TestCreateHelpRequest(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	// Create a user
	data := new(bytes.Buffer)
	json.NewEncoder(data).Encode(map[string]string{
		"email":    "user@domain.tld",
		"password": "motdepasse"})

	request, _ := http.NewRequest("POST", "http://server/api/user", data)
	response := httptest.NewRecorder()
	server.handleUser(response, request)

	if response.Code != 200 {
		t.Errorf("Wrong status: %+v", response)
	}
	user := new(model.User)
	err := json.NewDecoder(response.Body).Decode(&user)
	if err != nil {
		t.Errorf("User not returned: %s", err)
	}
	if user.Email != "user@domain.tld" {
		t.Errorf("User not filled: %+v", user)
	}
	cookie := strings.Split(response.Header().Get("Set-Cookie"), ";")[0]

	// Call for help
	data = new(bytes.Buffer)
    json.NewEncoder(data).Encode(map[string]interface{}{"latitude": 48.0, "longitude": 2.0})
	request, _ = http.NewRequest("PUT", "http://server/api/request", data)
	request.Header.Add("Cookie", cookie)
	response = httptest.NewRecorder()
	server.handleUser(response, request)
	if response.Code != 200 {
		t.Errorf("Error while processing: %+v, %s", response, response.Body)
	}

    hr := new(model.HelpRequest)
	err = json.NewDecoder(response.Body).Decode(&hr)
	if err != nil {
		t.Errorf("Request not returned: %s", err)
	}
	if hr.IsActive != true {
		t.Errorf("Request not filled after PUT: %+v", response)
	}
}
