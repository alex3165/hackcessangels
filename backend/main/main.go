package main

import (
	"log"
    "flag"

	"hackcessangels/backend/server"
)

func main() {
    flag.Parse()
	server := server.NewServer()
	log.Fatal(server.Run())

}
