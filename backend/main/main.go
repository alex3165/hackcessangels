package main

import (
	"flag"
	"log"

	"hackcessangels/backend/server"
)

func main() {
	flag.Parse()
	server := server.NewServer()
	log.Fatal(server.Run())

}
