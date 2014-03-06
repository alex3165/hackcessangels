package model

import (
	"testing"
    "time"
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

    req, err := m.CreateActiveRequestByRequester(u)
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

