package model

import (
	"testing"
	"time"

	"labix.org/v2/mgo/bson"
)

func TestRequestLifcycle(t *testing.T) {
	m, err := getTestModel()
	if err != nil {
		t.Error(err)
	}
	defer deleteTestDatabase(m)

	u, err := m.CreateUser("username@domain.tld", "some_password")
	if err != nil {
		t.Error(err)
	}

	req, err := m.GetOrCreateActiveRequestByRequester(u)
	if err != nil {
		t.Error(err)
	}

	if req.RequesterEmail != u.Email || time.Now().Sub(req.RequestCreationTime) > time.Minute || req.IsActive != true {
		t.Errorf("Request not filled: %+v", req)
	}

	req.SetRequesterPosition(2.10, 48.90)
	err = req.Save()
	if err != nil {
		t.Error(err)
	}

	req, err = m.GetActiveRequestByRequester(u)
	if err != nil {
		t.Error(err)
	}

	if req.RequesterPosition.Coordinates[0] != 2.10 {
		t.Errorf("Request not saved: %+v", req)
	}

	req.Deactivate()

	if req.IsActive != false {
		t.Errorf("Request still active: %+v", req)
	}
}

func TestFindActiveRequests(t *testing.T) {
	m, err := getTestModel()
	if err != nil {
		t.Error(err)
	}
	defer deleteTestDatabase(m)

	err = m.ResetAndLoadStationsFromFile()
	if err != nil {
		t.Error(err)
	}

	u, err := m.CreateUser("username@domain.tld", "some_password")
	if err != nil {
		t.Error(err)
	}

	req, err := m.GetOrCreateActiveRequestByRequester(u)
	if err != nil {
		t.Error(err)
	}

	if req.RequesterEmail != u.Email || time.Now().Sub(req.RequestCreationTime) > time.Minute || req.IsActive != true {
		t.Errorf("Request not filled: %+v", req)
	}

	var station Station
	m.stations.Find(bson.M{}).One(&station)

	req.SetRequesterPosition(station.Center.Coordinates[0], station.Center.Coordinates[1])
	err = req.Save()
	if err != nil {
		t.Error(err)
	}

	requests, err := m.GetActiveRequestsByStation(&station)
	if err != nil {
		t.Error(err)
	}

	if len(requests) != 1 {
		t.Errorf("%+v", requests)
	}
}
