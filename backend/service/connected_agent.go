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
	keepAliveTimeout = time.Second * 10
)

type AgentLogin string
type StationId bson.ObjectId

// ConnectedAgent represents a single agent that is currently connected
// to the HackcessAngels network.
type ConnectedAgent struct {
	login   AgentLogin
	station StationId

	connection     net.Conn
	readWriter     *bufio.ReadWriter
	keepAliveTimer *time.Ticker
	service        *AgentService
}

func (ca *ConnectedAgent) String() string {
	return fmt.Sprintf("Agent %s in station %s", ca.login, ca.station)
}

func (ca *ConnectedAgent) handleConnection() {
	ca.keepAliveTimer = time.NewTicker(keepAliveTimeout)
	go ca.handleKeepAlive()

	// Ensure that cleanup will happen
	defer ca.service.RemoveAgent(ca.login)
	defer ca.connection.Close()
	defer ca.keepAliveTimer.Stop()

	for {
		message, err := readFromClient(ca.readWriter.Reader)
		if err == io.EOF {
			log.Print("Connection interrupted")
			return
		} else if err != nil {
			log.Print("Error while reading from socket: ", err)
			return
			continue
		}
		if message.Latitude != nil && message.Longitude != nil && message.Precision != nil {
			station, err := ca.service.model.FindStationByLocation(
				*message.Longitude,
				*message.Latitude,
				*message.Precision)
			if err != nil {
				log.Println("Error getting location:", err)
				continue
			}
			if station == nil {
				ca.service.RemoveAgentFromStation(ca.login)
			} else {
				ca.service.SetAgentStation(ca.login, StationId(station.Id))
			}
            user, err := ca.service.model.GetUserByEmail(string(ca.login))
            if err != nil {
                log.Print(err)
            }
            user.CurrentStation = &station.Id
            user.LastStationUpdate = time.Now()
            user.Save()
		}
	}
}

func (ca *ConnectedAgent) handleKeepAlive() {
	for _ = range ca.keepAliveTimer.C {
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
