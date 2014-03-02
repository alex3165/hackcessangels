package main

import (
	"log"

	"hackcessangels/backend/server"
)

func main() {
	server := server.NewServer()
	log.Fatal(server.Run())

}
