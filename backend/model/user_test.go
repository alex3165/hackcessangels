package model

import (
	"testing"
)

func deleteTestDatabase(m *Model) {
	err := m.db.DropDatabase()
	if err != nil {
		panic(err)
	}
	m.session.Close()
}

// Verify that we can set a password and verify it and not another one.
func TestUserSetAndVerifyPassword(t *testing.T) {
	u := &User{}

	u.SetPassword("bla bla")
	if !u.VerifyPassword("bla bla") {
		t.Errorf("Passord not recognized")
	}
	if u.VerifyPassword("another password") {
		t.Errorf("Password incorrectly verified")
	}
}

func TestUserLifcycle(t *testing.T) {
	m, err := getTestModel()
	if err != nil {
		t.Error(err)
	}
	defer deleteTestDatabase(m)

	u, err := m.CreateUser("username@domain.tld", "some_password")
	if err != nil {
		t.Error(err)
	}
	if u.Email != "username@domain.tld" {
		t.Errorf("Wrong email for user: %s", u.Email)
	}
	if !u.VerifyPassword("some_password") {
		t.Errorf("Password not verified")
	}
	if len(u.Name) != 0 {
		t.Errorf("Name not empty: %s", u.Name)
	}
	u.Name = "Joe Doe"
	err = u.Save()
	if err != nil {
		t.Errorf("Unable to save: %s", err)
	}

	u, err = m.GetUserByEmail("username@domain.tld")
	if u.Name != "Joe Doe" {
		t.Errorf("Name not saved: %+v", u)
	}

	err = u.Delete()
	if err != nil {
		t.Errorf("Unable to delete")
	}

	u, err = m.GetUserByEmail("username@domain.tld")
	if u != nil {
		t.Errorf("User not actually deleted: %+v, %s", u, err)
	}
}
