package model

import (
	"errors"
	"time"

	"labix.org/v2/mgo/bson"
)

// PointGeometry is a point on a 2D sphere (Earth) in GeoJSON.
type PointGeometry struct {
	Type        string    `bson:"type"`
	Coordinates []float64 `bson:"coordinates"`
}

// NewPoint creates a new GeoJSON point.
func NewPoint(longitude, latitude float64) *PointGeometry {
	p := &PointGeometry{
		Type:        "Point",
		Coordinates: []float64{longitude, latitude},
	}
	return p
}

// HelpRequestState represent the state of a request
type HelpRequestState int

const (
	// This is a new, unprocessed request
	NEW HelpRequestState = 0
	// Agents has been contacted
	AGENTS_CONTACTED = 1
	// No agents are available at this location
	NO_AGENTS = 2
	// Request has been retried by the user
	RETRY = 3
	// Request has been cancelled by the user (before any agent answered)
	CANCELLED = 4
	// Request has been abandoned by the user (no retry)
	ABANDONED = 5
	// An agent has answered this request
	AGENT_ANSWERED = 6
	// This request has been completed
	COMPLETED = 7
	// Request finished and report filled
	REPORT_FILLED = 8
)

type HelpRequestStatus struct {
	// State of the request
	State HelpRequestState
	// Time this request entered the above state
	Time time.Time
}

type HelpRequestReportType int

const (
	UNKNOWN     HelpRequestReportType = 0
	ASSISTANCE                        = 1
	WHEELCHAIR                        = 2
	ORIENTATION                       = 3
	REASSURING                        = 4
	INFORMATION                       = 5
	OTHER                             = 6
)

type HelpRequest struct {
	Id                  bson.ObjectId `bson:"_id,omitempty"`
	RequestCreationTime time.Time

	RequesterEmail        string
	RequesterPosition     *PointGeometry
	RequesterPosPrecision float64
	RequesterLastUpdate   time.Time
	CurrentState          HelpRequestState

	// Status of the request, in chronological order. The last object is the
	// current state. The rest is kept for auditing.
	Status []HelpRequestStatus

	ResponderEmail      string
	ResponderLastUpdate time.Time

	ReportType    HelpRequestReportType
	ReportComment string

	m *Model `bson:"-"`
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

func (hr *HelpRequest) ChangeStatus(newState HelpRequestState, time time.Time) error {
	hr.CurrentState = newState
	status := HelpRequestStatus{
		State: newState,
		Time:  time,
	}
	hr.Status = append(hr.Status, status)
	return hr.Save()
}

// Return the agent responding to the request, or nil of no-one answered.
func (hr *HelpRequest) GetAgent() (*User, error) {
	if len(hr.ResponderEmail) == 0 {
		return nil, errors.New("No agent answered.")
	}

	agent, err := hr.m.GetUserByEmail(hr.ResponderEmail)
	if err != nil {
		return nil, errors.New("Invalid agent email")
	} else if !agent.IsAgent {
		return nil, errors.New("Responder is not an agent")
	} else {
		return agent, nil
	}
}

// Return the user asking for help, or nil of no-one answered.
func (hr *HelpRequest) GetUser() (*User, error) {
	if len(hr.RequesterEmail) == 0 {
		return nil, errors.New("No-one asked for help!")
	}

	user, err := hr.m.GetUserByEmail(hr.RequesterEmail)
	if err != nil {
		return nil, errors.New("Invalid agent email")
	} else if user.IsAgent {
		return nil, errors.New("Requester is an agent")
	} else {
		return user, nil
	}
}

func (m *Model) GetActiveRequestsByStation(s *Station) ([]*HelpRequest, error) {
	helpRequests := make([]*HelpRequest, 0)
	err := m.helpRequests.Find(bson.M{
		"currentstate": bson.M{"$in": []HelpRequestState{NEW,
			AGENTS_CONTACTED, RETRY, AGENT_ANSWERED}},
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
		"currentstate": bson.M{"$in": []HelpRequestState{NEW,
			AGENTS_CONTACTED, RETRY, AGENT_ANSWERED}},
	}).One(&hr)
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
		m:                   m}
	hr.ChangeStatus(NEW, hr.RequestCreationTime)
	return hr, nil
}
