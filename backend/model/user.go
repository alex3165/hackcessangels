package model

import (
    "time"

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

const (
    kStationTimeout time.Duration = 60 * time.Minute
)

type User struct {
	Email string
	LoggedAccount

	Name        string
	Description string
	Image       []byte
	Phone       string

	Disability     string
	DisabilityType DisabilityType

	PushToken string

	IsAgent        bool
	CurrentStation *bson.ObjectId
    LastStationUpdate time.Time

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

func (u *User) GetStation() (*Station, error) {
	if !u.IsAgent || u.CurrentStation == nil {
		return nil, nil
	}
    if time.Now().Sub(u.LastStationUpdate) > kStationTimeout {
        u.CurrentStation = nil
        return nil, u.Save()
    }
	var station *Station
	err := u.m.stations.FindId(*u.CurrentStation).One(station)
	return station, err
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
