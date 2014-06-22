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

    helpRequestObservers []HelpRequestObserver
}

type HelpRequestObserver interface {
    NotifyHelpRequestChanged(hr *HelpRequest)
}

func (m *Model) Delete() {
	m.db.DropDatabase()
}

func (m *Model) Close() {
	m.session.Close()
}

func (m *Model) RegisterHelpRequestObserver(observer HelpRequestObserver) {
    m.helpRequestObservers = append(m.helpRequestObservers, observer)
}

func NewModel(server string, databaseName string) (*Model, error) {
	m := &Model{}

    m.helpRequestObservers = make([]HelpRequestObserver, 0, 0)

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
	err = m.helpRequests.EnsureIndex(mgo.Index{
		Key:  []string{"$2dsphere:requesterposition"},
		Bits: 26,
	})
	if err != nil {
		return nil, err
	}
	m.stations = m.db.C("stations")
	err = m.stations.EnsureIndex(mgo.Index{
		Key:  []string{"$2dsphere:center"},
		Bits: 26,
	})
	if err != nil {
		return nil, err
	}
	return m, nil
}
