package model

import (
	"labix.org/v2/mgo"
)

type Model struct {
	session *mgo.Session
	db      *mgo.Database

	users        *mgo.Collection
	helpRequests *mgo.Collection
	stations     *mgo.Collection
}

func (m *Model) Delete() {
	m.db.DropDatabase()
}

func (m *Model) Close() {
	m.session.Close()
}

func NewModel(server string, databaseName string) (*Model, error) {
	m := &Model{}

	var err error

	m.session, err = mgo.Dial(server)
	if err != nil {
		return nil, err
	}

	// Monotonic consistency
	m.session.SetMode(mgo.Monotonic, true)

	m.db = m.session.DB(databaseName)
	m.users = m.db.C("users")
	m.helpRequests = m.db.C("helpRequests")
	m.helpRequests.EnsureIndex(mgo.Index{
		Key:  []string{"$2dsphere:requesterposition"},
		Bits: 26,
        Sparse: true,
	})
	m.stations = m.db.C("stations")
	return m, nil
}
