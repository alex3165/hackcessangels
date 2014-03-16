package server

import (
	"encoding/json"
	"log"
	"net/http"

	"github.com/gorilla/schema"
)

func getJSONRequest(r *http.Request, data interface{}) error {
	var err error
	if r.Method == "GET" || r.Method == "DELETE" {
		decoder := schema.NewDecoder()
		log.Printf("URL Query: %+v", r.URL.Query())
		err = decoder.Decode(data, r.URL.Query())
	} else {
		decoder := json.NewDecoder(r.Body)
		err = decoder.Decode(&data)
	}
	return err
}

// Set errorCode as the status code of the provided HTTP Response, with errorString
// as a JSON error status string.
func returnError(errorCode int, errorString string, w http.ResponseWriter) {
	w.WriteHeader(errorCode)
	jsonError := map[string]string{"error": errorString}
	encoder := json.NewEncoder(w)
	err := encoder.Encode(jsonError)
	// Error while processing the error: we can only ignore and log.
	if err != nil {
		log.Printf("Error while processing error %d: %s: %s", errorCode, errorString, err)
	}
}

// Return a pointer to the provided string
func ptrTo(s string) *string {
	return &s
}
