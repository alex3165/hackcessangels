package main

import (
	"labix.org/v2/mgo/bson"
	"time"
)

type Position struct {
    Latitude float64
    Longitude float64
    Uncertainty float64
    DateUpdated time.Time
}

type Request struct {
    Position Position
	DateRequested time.Time
	RequestedBy   bson.ObjectId
	DateAnswered  time.Time
	AnsweredBy    bson.ObjectId
}

type User struct {
	AndroidId string
	AppleId   string
	Email     string
	Name      string
	Message   string
	Agent     bool
    Position Position
}

type Station struct {
    Latitude float64
    Longitude float64
    Name string
}
