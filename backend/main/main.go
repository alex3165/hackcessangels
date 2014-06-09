package main

import (
	"flag"
	"log"

	"hackcessangels/backend/server"
)

func main() {
	flag.Parse()
	server := server.NewServerWithCookieStore(
        []byte(";X,\"ky_nRYY>R~pl{:/<w_Xw$h92YwxmC*#^bZJEttI#*J1LuJtvAGkLDJyCJkr5"),
        []byte("LS<5WvNp>s+}Fr<L:Ja=E(&Q1\"SixzIl"))
	log.Fatal(server.Run())

}
