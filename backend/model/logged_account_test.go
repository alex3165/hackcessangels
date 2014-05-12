package model

import (
	"testing"
)

// Verify the salt is random changes at each call.
func TestLASetPasswordSalt(t *testing.T) {
	la := &LoggedAccount{}

	la.SetPassword("bla bla")
	salt1 := la.Salt
	pass1 := la.Password

	// Same password, another salt
	la.SetPassword("bla bla")
	if salt1 == la.Salt {
		t.Errorf("Salts %v and %v identical", salt1, la.Salt)
	}
	if pass1 == la.Password {
		t.Errorf("Stored passwords %v and %v identical", pass1, la.Password)
	}
}

// Verify that we can set a password and verify it and not another one.
func TestLASetAndVerifyPassword(t *testing.T) {
	la := &LoggedAccount{}

	la.SetPassword("bla bla")
	if !la.VerifyPassword("bla bla") {
		t.Errorf("Passord not recognized")
	}
	if la.VerifyPassword("another password") {
		t.Errorf("Password incorrectly verified")
	}
}
