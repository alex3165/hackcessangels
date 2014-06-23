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
	// Request has been abandoned by the user
	ABANDONED = 5
	// An agent has answered this request
	AGENT_ANSWERED = 6
	// This request has been completed
	COMPLETED = 7
	// Request finished and report filled
	REPORT_FILLED = 8
	// Not in a station
	NOT_IN_STATION = 9
	// Timeout when contacting agents; retry or abort
	TIMEOUT = 10
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

const (
	REQUEST_TIMEOUT      time.Duration = 10 * time.Minute
	RETRY_TIMEOUT        time.Duration = 10 * time.Minute
	INTERVENTION_TIMEOUT time.Duration = 10 * time.Minute
)

type HelpRequest struct {
	Id                  bson.ObjectId `bson:"_id,omitempty"`
	RequestCreationTime time.Time

    RequestStation        *bson.ObjectId
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
    for _, observer := range hr.m.helpRequestObservers {
        observer.NotifyHelpRequestChanged(hr)
    }
}

func (hr *HelpRequest) SetRequesterPosition(longitude, latitude float64) {
	hr.RequesterPosition = NewPoint(longitude, latitude)
	hr.RequesterLastUpdate = time.Now()
}

func (hr *HelpRequest) Save(broadcast bool) error {
	_, err := hr.m.helpRequests.UpsertId(hr.Id, hr)
    if broadcast {
        go hr.BroadcastStatus()
    }
	return err
}

// CheckStatus verifies that the status of a request should not be changed.
// For instance, if a request is running for more than N minutes, it is automatically abandonned or completed.
func (hr *HelpRequest) CheckStatus() error {
    if hr.RequestStation == nil {
        station, _ := hr.GetStation()
        if station != nil {
            hr.RequestStation = &station.Id
        }
    }
	switch hr.CurrentState {
	case NEW, AGENTS_CONTACTED:
		// Maximum 10 minutes
		if time.Now().Sub(hr.RequestCreationTime) > REQUEST_TIMEOUT {
			return hr.ChangeStatus(TIMEOUT, time.Now())
		}
		if station, _ := hr.GetStation(); station == nil {
			return hr.ChangeStatus(NOT_IN_STATION, time.Now())
		}
		break
	case AGENT_ANSWERED:
		if time.Now().Sub(hr.Status[len(hr.Status)-1].Time) > INTERVENTION_TIMEOUT {
			return hr.ChangeStatus(COMPLETED, time.Now())
		}
		if station, _ := hr.GetStation(); station == nil {
			return hr.ChangeStatus(COMPLETED, time.Now())
		}
	case TIMEOUT:
		if time.Now().Sub(hr.Status[len(hr.Status)-1].Time) > RETRY_TIMEOUT {
			return hr.ChangeStatus(ABANDONED, time.Now())
		}
		if station, _ := hr.GetStation(); station == nil {
			return hr.ChangeStatus(CANCELLED, time.Now())
		}
	case RETRY:
		if time.Now().Sub(hr.Status[len(hr.Status)-1].Time) > REQUEST_TIMEOUT {
			return hr.ChangeStatus(ABANDONED, time.Now())
		}
		if station, _ := hr.GetStation(); station == nil {
			return hr.ChangeStatus(CANCELLED, time.Now())
		}
	}
	return nil
}

func (hr *HelpRequest) ChangeStatus(newState HelpRequestState, time time.Time) error {
	hr.CurrentState = newState
	status := HelpRequestStatus{
		State: newState,
		Time:  time,
	}
	hr.Status = append(hr.Status, status)
	return hr.Save(true)
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

// Return the station where this help request is located
func (hr *HelpRequest) GetStation() (*Station, error) {
    return hr.m.FindStationByLocation(hr.RequesterPosition.Coordinates[0],
        hr.RequesterPosition.Coordinates[1],
        hr.RequesterPosPrecision)
}

// Return the station where this help request is located
func (hr *HelpRequest) GetInitialStation() (*Station, error) {
    return hr.m.FindStationByLocation(hr.RequesterPosition.Coordinates[0],
        hr.RequesterPosition.Coordinates[1],
        hr.RequesterPosPrecision)
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

	// Add the pointer to the model object to all help requests: it is not in the database.
	for _, hr := range helpRequests {
		hr.m = m
	}
	return helpRequests, err
}

func (m *Model) GetRequestById(id string) (*HelpRequest, error) {
	if !bson.IsObjectIdHex(id) {
		return nil, errors.New(id + " not an object ID")
	}
	hr := new(HelpRequest)
	err := m.helpRequests.FindId(bson.ObjectIdHex(id)).One(&hr)
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
