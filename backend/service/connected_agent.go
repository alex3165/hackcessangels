package service

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net"
	"time"

	"labix.org/v2/mgo/bson"
)

const (
	keepAliveTimeout = time.Minute * 5
)

type AgentLogin string
type StationId bson.ObjectId

// ConnectedAgent represents a single agent that is currently connected
// to the HackcessAngels network.
type ConnectedAgent struct {
	login   AgentLogin
	station *StationId

	connection     net.Conn
	readWriter     *bufio.ReadWriter
	keepAliveTimer *time.Ticker
	service        *AgentService
	stopChannel    chan bool
}

func (ca *ConnectedAgent) String() string {
	if ca.station != nil {
		return fmt.Sprintf("Agent %s in station %s", ca.login, *ca.station)
	} else {
		return fmt.Sprintf("Agent %s outside a station", ca.login)
	}
}

func (ca *ConnectedAgent) handleConnection() {
	ca.keepAliveTimer = time.NewTicker(keepAliveTimeout)
	go ca.handleKeepAlive()

	// Ensure that cleanup will happen
	ca.stopChannel = make(chan bool, 1)
	defer ca.service.RemoveAgent(ca.login)
	defer ca.connection.Close()
	defer func() { ca.stopChannel <- true }()
	defer ca.keepAliveTimer.Stop()

	for {
		message, err := readFromClient(ca.readWriter.Reader)
		if err == io.EOF {
			log.Print("Connection interrupted")
			return
		} else if err != nil {
			log.Print("Error while reading from socket: ", err)
			return
		}
		if message.Latitude != nil && message.Longitude != nil && message.Precision != nil {
			station, err := ca.service.model.FindStationByLocation(
				*message.Longitude,
				*message.Latitude,
				*message.Precision)
			log.Printf("Longitude %f, latitude %f, precision %f, station %+v, err %v",
				*message.Longitude, *message.Latitude, *message.Precision,
				station, err)
			if err != nil {
				log.Println("Error getting location:", err)
				continue
			}
			user, err := ca.service.model.GetUserByEmail(string(ca.login))
			if err != nil {
				log.Print(err)
				continue
			}
			arrivedInStation := false
			if station == nil {
				ca.service.RemoveAgentFromStation(ca.login)
				user.CurrentStation = nil
				ca.station = nil
			} else {
				arrivedInStation = ca.service.SetAgentStation(
					ca.login, StationId(station.Id))
				stationId := StationId(station.Id)
				ca.station = &stationId
				user.CurrentStation = &station.Id
			}
			user.LastStationUpdate = time.Now()
			user.Save()
			if arrivedInStation {
				go ca.UpdateHelpRequests()
			}
		}
	}
}

func (ca *ConnectedAgent) handleKeepAlive() {
	ca.sendKeepAlive()
	for {
		select {
		case _ = <-ca.keepAliveTimer.C:
			ca.sendKeepAlive()
			break
		case _ = <-ca.stopChannel:
			return
		}
	}
}

func (ca *ConnectedAgent) sendKeepAlive() {
	message := ServerMessage{KeepAlive: true}
	j, err := json.Marshal(message)
	if err != nil {
		log.Fatal(err)
	}
	_, err = ca.readWriter.Write(j)
	if err != nil {
		log.Print("Failed to send keep alive for agent", ca.login, ":", err)
	}
	_, err = ca.readWriter.Write([]byte("\n"))
	if err != nil {
		log.Print("Failed to send keep alive for agent", ca.login, ":", err)
	}
	err = ca.readWriter.Flush()
	if err != nil {
		log.Print("Failed to flush keep alive for agent", ca.login, ":", err)
	}
}

func (ca *ConnectedAgent) UpdateHelpRequests() {
	message := ServerMessage{UpdateRequestsNow: true}
	j, err := json.Marshal(message)
	if err != nil {
		log.Fatal(err)
	}
	_, err = ca.readWriter.Write(j)
	if err != nil {
		log.Print("Failed to update requests for agent", ca.login, ":", err)
	}
	_, err = ca.readWriter.Write([]byte("\n"))
	if err != nil {
		log.Print("Failed to update requests for agent", ca.login, ":", err)
	}
	err = ca.readWriter.Flush()
	if err != nil {
		log.Print("Failed to flush update requests for agent", ca.login, ":", err)
	}
}
