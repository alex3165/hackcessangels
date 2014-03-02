package server

import (
	"encoding/json"
	"log"
	"net/http"
)

func getJSONRequest(r *http.Request) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	decoder := json.NewDecoder(r.Body)
	err := decoder.Decode(&data)
	return data, err
}

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
