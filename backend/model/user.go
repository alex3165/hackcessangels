package model

import (
	"labix.org/v2/mgo/bson"
)

type DisabilityType int

const (
	Unknown DisabilityType = iota
	Physical
	Vision
	Hearing
	Mental
	Other
)

type User struct {
	Email         string `json:"email"`
	LoggedAccount `json:"-"`

	Name           string         `json:"name"`
	Description    string         `json:"description"`
	Disability     string         `json:"disability"`
	DisabilityType DisabilityType `json:"disabilityType"`

	m *Model `bson:"-"`
}

func (u *User) Save() error {
	_, err := u.m.users.Upsert(bson.M{"email": u.Email}, u)
	return err
}

func (u *User) Delete() error {
	err := u.m.users.Remove(bson.M{"email": u.Email})
	return err
}

func (m *Model) CreateUser(email, password string) (*User, error) {
	u := &User{
		Email: email,
		m:     m,
	}
	err := u.SetPassword(password)
	if err != nil {
		return nil, err
	}
	err = u.Save()
	return u, err
}

func (m *Model) GetUserByEmail(email string) (*User, error) {
	u := &User{}
	if err := m.users.Find(bson.M{"email": email}).One(&u); err != nil {
		return nil, err
	}
	u.m = m
	return u, nil
}
