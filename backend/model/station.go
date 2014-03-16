package model

import (
    "os"
    "encoding/csv"

	"labix.org/v2/mgo/bson"
)

const (
    stationCoordinates = "data/stations.csv"
)

type PolygonGeometry struct {
	Type        string        `bson:"type"`
	Coordinates [][][]float64 `bson:"coordinates"`
}

func NewPolygonGeometry(points [][]float64) *PolygonGeometry {
	p := &PolygonGeometry{
		Type:        "polygon",
		Coordinates: [][][]float64{points},
	}
	return p
}

type Station struct {
	Id   bson.ObjectId `bson:"_id,omitempty"`
	Name string

	Center  *PointGeometry
	Outline *PolygonGeometry

	m *Model `bson:"-"`
}

func (m *Model) ResetAndLoadStationsFromFile() error {
    m.stations.RemoveAll(bson.M{})
    
    r := csv.NewReader(os.Open(stationCoordinates))
    r.Comma = ';'
    r.LazyQuotes = true
    r.TrimLeadingSpace = true

    header, err := r.Read()
    if err != nil {
        return err
    }
    for  {
    }

}
