package model

import (
	"time"

	"labix.org/v2/mgo/bson"
)

type PointGeometry struct {
	Type        string    `bson:"type"`
	Coordinates []float64 `bson:"coordinates"`
}

func NewPoint(longitude, latitude float64) *PointGeometry {
	p := &PointGeometry{
		Type:        "Point",
		Coordinates: []float64{longitude, latitude},
	}
	return p
}

type HelpRequest struct {
	Id                  bson.ObjectId `bson:"_id,omitempty"`
	RequestCreationTime time.Time

	RequesterEmail        string
	RequesterPosition     *PointGeometry
	RequesterPosPrecision float64
	RequesterLastUpdate   time.Time
	IsActive              bool

	ResponderEmail        string
	ResponderPosition     *PointGeometry
	ResponderPosPrecision float64
	ResponderLastUpdate   time.Time
	m                     *Model `bson:"-"`
}

func (hr *HelpRequest) BroadcastStatus() {
	// Do nothing, yet
}

func (hr *HelpRequest) SetRequesterPosition(longitude, latitude float64) {
	hr.RequesterPosition = NewPoint(longitude, latitude)
	hr.RequesterLastUpdate = time.Now()
}

func (hr *HelpRequest) Save() error {
	_, err := hr.m.helpRequests.UpsertId(hr.Id, hr)
	return err
}

func (hr *HelpRequest) Deactivate() error {
	hr.IsActive = false
	return hr.Save()
}

func (m *Model) GetActiveRequestsByStation(s *Station) ([]*HelpRequest, error) {
	helpRequests := make([]*HelpRequest, 0)
	err := m.helpRequests.Find(bson.M{
		"isactive": true,
		"requesterposition": bson.M{
			"$near": bson.M{
				"$geometry": bson.M{
					"type":        "Point",
					"coordinates": []float64{s.Center.Coordinates[0], s.Center.Coordinates[1]},
				},
				"$maxDistance": 500,
			},
		},
	}).All(&helpRequests)
	return helpRequests, err
}

func (m *Model) GetRequestById(id string) (*HelpRequest, error) {
    hr := new(HelpRequest)
    err := m.helpRequests.FindId(id).One(&hr)
    hr.m = m
    return hr, err
}

func (m *Model) GetActiveRequestByRequester(user *User) (*HelpRequest, error) {
	hr := new(HelpRequest)
	err := m.helpRequests.Find(bson.M{"requesteremail": user.Email,
		"isactive": true}).One(&hr)
	hr.m = m
	return hr, err
}

func (m *Model) GetOrCreateActiveRequestByRequester(user *User) (*HelpRequest, error) {
	hr, err := m.GetActiveRequestByRequester(user)
	if err == nil {
		return hr, nil
	}
	hr = &HelpRequest{
		Id:                  bson.NewObjectId(),
		RequestCreationTime: time.Now(),
		RequesterEmail:      user.Email,
		IsActive:            true,
		m:                   m}
	return hr, nil
}
