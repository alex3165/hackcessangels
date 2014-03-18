package model

import (
	"encoding/csv"
	"flag"
	"os"
	"strconv"
	"strings"

	"labix.org/v2/mgo/bson"
)

var (
	stationCoordinates *string = flag.String(
		"station-csv-path",
		"../data/sncf-gares-et-arrets-transilien-ile-de-france.csv",
		"Path to the SNCF station CSV file from SNCF Open Data site.")
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

	reader, err := os.Open(*stationCoordinates)
	if err != nil {
		return err
	}
	r := csv.NewReader(reader)
	r.Comma = ';'
	r.LazyQuotes = true
	r.TrimLeadingSpace = true

	header, err := r.Read()
	if err != nil {
		return err
	}
	headerIndex := make(map[string]int)
	for i, k := range header {
		headerIndex[k] = i
	}

	for line, err := r.Read(); err == nil; line, err = r.Read() {
		station := &Station{
			Id:   bson.NewObjectId(),
			Name: line[headerIndex["nom_gare"]],
			m:    m,
		}
		coordinates := strings.Split(line[headerIndex["coord_gps_wgs84"]], ", ")
		lat, err := strconv.ParseFloat(coordinates[0], 64)
		if err != nil {
			return err
		}
		lng, err := strconv.ParseFloat(coordinates[1], 64)
		if err != nil {
			return err
		}
		station.Center = NewPoint(lng, lat)
		err = m.stations.Insert(station)
		if err != nil {
			return err
		}
	}
	return err
}
