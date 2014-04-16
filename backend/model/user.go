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
	Email string
	LoggedAccount

	Name           string
	Description    string
    Image          []byte
    Phone          string

	Disability     string
	DisabilityType DisabilityType

	IsAgent        bool
	CurrentStation *bson.ObjectId

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
		Email:   email,
		IsAgent: false,
		m:       m,
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
