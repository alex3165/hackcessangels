package model

import (
	"labix.org/v2/mgo"
)

// Model for the hackcessangels app. Holds the connection to the MongoDB database.
type Model struct {
    // Connection to the database
	session *mgo.Session
	db      *mgo.Database

    // We have 3 "tables" (aka. Collections in MongoDB lingo).
	users        *mgo.Collection
	helpRequests *mgo.Collection
	stations     *mgo.Collection

    // List of objects that need to be warned when a help request changed.
	helpRequestObservers []HelpRequestObserver
}

// Interface to be implemented by objects that want to be notified when a help request changed.
type HelpRequestObserver interface {
	NotifyHelpRequestChanged(hr *HelpRequest)
}

// Delete the current database backing this model.
func (m *Model) Delete() {
	m.db.DropDatabase()
}

// Close the session. The model won't work after this method is called.
func (m *Model) Close() {
	m.session.Close()
}

// Add an object that wants to be notified when help requests changes.
func (m *Model) RegisterHelpRequestObserver(observer HelpRequestObserver) {
	m.helpRequestObservers = append(m.helpRequestObservers, observer)
}

// Creates a new model.
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
