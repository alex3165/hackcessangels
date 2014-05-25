package server

import (
	"bytes"
	"encoding/json"
	"log"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

func deleteTestDatabase(s *Server) {
	s.model.Delete()
	s.model.Close()
}

func TestUserLoginOK(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	server.model.CreateUser("user@domain.tld", "password")

	data := new(bytes.Buffer)
	if err := json.NewEncoder(data).Encode(map[string]string{
		"email":    "user@domain.tld",
		"password": "password"}); err != nil {
		t.Error(err)
	}
	request, _ := http.NewRequest("POST", "http://server/api/user/login", data)
	response := httptest.NewRecorder()
	server.handleUserLogin(response, request)

	if response.Code != 200 {
		t.Errorf("Wrong status: %+v", response)
	}
}

func TestUserLoginInvalidEmail(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	server.model.CreateUser("user@domain.tld", "password")

	data := new(bytes.Buffer)
	if err := json.NewEncoder(data).Encode(map[string]string{
		"email":    "user@domain.invalid",
		"password": "password"}); err != nil {
		t.Error(err)
	}
	request, _ := http.NewRequest("POST", "http://server/api/user/login", data)
	response := httptest.NewRecorder()
	server.handleUserLogin(response, request)

	if response.Code != 403 {
		t.Errorf("Wrong status: %+v", response)
	}
}

func TestUserLoginInvalidPassword(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	server.model.CreateUser("user@domain.tld", "password")

	data := new(bytes.Buffer)
	if err := json.NewEncoder(data).Encode(map[string]string{
		"email":    "user@domain.tld",
		"password": "invalid"}); err != nil {
		t.Error(err)
	}
	request, _ := http.NewRequest("POST", "http://server/api/user/login", data)
	response := httptest.NewRecorder()
	server.handleUserLogin(response, request)

	if response.Code != 403 {
		t.Errorf("Wrong status: %+v", response)
	}
}

func TestUserCreateUser(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	data := new(bytes.Buffer)
	if err := json.NewEncoder(data).Encode(map[string]string{
		"email":    "user@domain.tld",
		"password": "motdepasse"}); err != nil {
		t.Error(err)
	}
	request, _ := http.NewRequest("POST", "http://server/api/user", data)
	response := httptest.NewRecorder()
	server.handleUser(response, request)

	if response.Code != 200 {
		t.Errorf("Wrong status: %+v", response)
	}
	if c := response.Header().Get("Set-Cookie"); len(c) == 0 {
		t.Errorf("No cookies in response")
	}

	_, err := server.model.GetUserByEmail("user@domain.tld")
	if err != nil {
		t.Errorf("User not created properly: %s", err)
	}
}

func TestUserCreatePutGetDelete(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	// POST request
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
	user := new(ApiUser)
	log.Printf("Response: %s", response.Body)
	err := json.NewDecoder(response.Body).Decode(&user)
	if err != nil {
		t.Errorf("User not returned: %s", err)
	}
	if user.Email == nil || *user.Email != "user@domain.tld" {
		t.Errorf("Created user not filled: %+v", user)
	}
	cookie := strings.Split(response.Header().Get("Set-Cookie"), ";")[0]

	// PUT request
	user.Name = ptrTo("Joe Doe")
	data = new(bytes.Buffer)
	json.NewEncoder(data).Encode(map[string]interface{}{"data": user})
	request, _ = http.NewRequest("PUT", "http://server/api/user", data)
	request.Header.Add("Cookie", cookie)
	response = httptest.NewRecorder()
	server.handleUser(response, request)
	if response.Code != 200 {
		t.Errorf("Error while processing: %+v, %s", response, response.Body)
	}

	user = new(ApiUser)
	err = json.NewDecoder(response.Body).Decode(&user)
	if err != nil {
		t.Errorf("User not returned: %s", err)
	}
	if *user.Name != "Joe Doe" {
		t.Errorf("User not filled after PUT: %+v", response)
	}

	// GET request
	request, _ = http.NewRequest("GET", "http://server/api/user?email=user@domain.tld", nil)
	request.Header.Add("Cookie", cookie)
	response = httptest.NewRecorder()
	server.handleUser(response, request)
	if response.Code != 200 {
		t.Errorf("Error while processing: %+v, %s", response, response.Body)
	}

	user = new(ApiUser)
	err = json.NewDecoder(response.Body).Decode(&user)
	if err != nil {
		t.Errorf("User not returned: %s", err)
	}
	if *user.Name != "Joe Doe" || *user.Email != "user@domain.tld" {
		t.Errorf("User not filled after GET: %+v", user)
	}

	// DELETE request
	request, _ = http.NewRequest("DELETE", "http://server/api/user?email=user@domain.tld", nil)
	request.Header.Add("Cookie", cookie)
	response = httptest.NewRecorder()
	server.handleUser(response, request)
	if response.Code != 200 {
		t.Errorf("Error while processing: %+v, %s", response, response.Body)
	}
}

// Test a password change.
func TestUserChangePassword(t *testing.T) {
	server := NewServer()
	server.Database = "hackcessangels_server_test"
	server.init()
	defer deleteTestDatabase(server)

	// POST request
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
	user := new(ApiUser)
	log.Printf("Response: %s", response.Body)
	err := json.NewDecoder(response.Body).Decode(&user)
	if err != nil {
		t.Errorf("User not returned: %s", err)
	}
	if user.Email == nil || *user.Email != "user@domain.tld" {
		t.Errorf("Created user not filled: %+v", user)
	}
	cookie := strings.Split(response.Header().Get("Set-Cookie"), ";")[0]

	// PUT request
	user.Password = ptrTo("newPassword!")
	data = new(bytes.Buffer)
	json.NewEncoder(data).Encode(map[string]interface{}{"data": user})
	request, _ = http.NewRequest("PUT", "http://server/api/user", data)
	request.Header.Add("Cookie", cookie)
	response = httptest.NewRecorder()
	server.handleUser(response, request)
	if response.Code != 200 {
		t.Errorf("Error while processing: %+v, %s", response, response.Body)
	}

	loginData := new(bytes.Buffer)
	if err := json.NewEncoder(loginData).Encode(map[string]string{
		"email":    "user@domain.tld",
		"password": "newPassword!"}); err != nil {
		t.Error(err)
	}
	request, _ = http.NewRequest("POST", "http://server/api/user/login", loginData)
	response = httptest.NewRecorder()
	server.handleUserLogin(response, request)

	if response.Code != 200 {
		t.Errorf("Wrong status: %+v", response)
	}
}
