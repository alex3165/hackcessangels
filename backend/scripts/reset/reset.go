package main

import (
	"flag"
	"log"

	"hackcessangels/backend/model"
)

var (
	account  = flag.String("account", "", "login of the account")
	password = flag.String("password", "", "password to set on the account")
)

func main() {
	flag.Parse()

	if len(*password) == 0 {
		log.Fatal("password must not be empty")
	}

	m, err := model.NewModel("localhost", "hackcessangels")
	if err != nil {
		log.Fatal("Unable to create model: ", err)
	}

	user, err := m.GetUserByEmail(*account)
	if err != nil {
		log.Fatal("Unable to get user: ", err)
	}

	if err = user.SetPassword(*password); err != nil {
		log.Fatal("Unable to set password: ", err)
	}

	if err = user.Save(); err != nil {
		log.Fatal("Unable to save modified user: ", err)
	}
}
