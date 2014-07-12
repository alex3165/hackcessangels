package service

import (
	"bufio"
	"crypto/tls"
	"encoding/json"
	"flag"
	"log"
	"net"
	"time"

	"hackcessangels/backend/model"
)

var (
	certFile *string = flag.String(
		"certificate", "/etc/nginx/ssl/aidegare.full.crt",
		"Path to the certificate used to secure incoming connections.")
	keyFile *string = flag.String("key", "/etc/nginx/ssl/aidegare.key",
		"Path to the key used to secure incoming connections.")
)

type AgentService struct {
	AgentStationManager

	server net.Listener
	model  *model.Model
}

func NewAgentService(m *model.Model) (*AgentService, error) {
	service := &AgentService{
		model: m,
	}
	service.stations = make(map[StationId]map[AgentLogin]bool)
	service.agents = make(map[AgentLogin]*ConnectedAgent)

	config := tls.Config{}
	cert, err := tls.LoadX509KeyPair(*certFile, *keyFile)
	if err != nil {
		return nil, err
	}
	config.Certificates = []tls.Certificate{cert}

	service.server, err = tls.Listen("tcp", ":5001", &config)
	if err != nil {
		return nil, err
	}

	go service.Listen()

	return service, nil
}

func (s *AgentService) Listen() {
	defer s.server.Close()

	for {
		// Listen for an incoming connection.
		conn, err := s.server.Accept()
		if err != nil {
			log.Println("Error accepting: ", err.Error())
			continue
		}
		// Handle connections in a new goroutine.
		go s.handleRequest(conn)
	}
}

type ServerMessage struct {
	UpdateRequestsNow bool
	KeepAlive         bool
	StationName       *string `json:"StationName,omitempty"`
}

type ClientMessage struct {
	Latitude  *float64
	Longitude *float64
	Precision *float64

	Login     *string
	AuthToken *string
}

func (s *AgentService) handleRequest(conn net.Conn) {
	log.Println("New connection")
	readWriter := bufio.NewReadWriter(bufio.NewReader(conn), bufio.NewWriter(conn))

	conn.SetDeadline(time.Now().Add(20 * time.Second))
	message, err := readFromClient(readWriter.Reader)
	if err != nil {
		log.Println("Error while reading initial data: ", err)
		return
	}
	conn.SetDeadline(time.Time{})

	if message.Login == nil {
		log.Print("Agent connected without login")
		return
	}
	user, err := s.model.GetUserByEmail(*message.Login)
	if err != nil {
		log.Print(*message.Login, "isn't a known user")
		return
	}
	if !user.IsAgent {
		log.Print(*message.Login, "isn't an agent")
		return
	}
	log.Print("Agent ", user.Email, " connected")

	connectedAgent := ConnectedAgent{
		login:      AgentLogin(user.Email),
		connection: conn,
		readWriter: readWriter,
		service:    s,
	}

	s.AddAgent(&connectedAgent)
	go connectedAgent.handleConnection()

}

func readFromClient(reader *bufio.Reader) (c ClientMessage, err error) {
	data, err := reader.ReadSlice('\n')
	if err != nil {
		return c, err
	}

	err = json.Unmarshal(data, &c)
	return c, err
}

func (s *AgentService) NotifyHelpRequestChanged(hr *model.HelpRequest) {
	stationId := hr.RequestStation
	if stationId == nil {
		return
	}
	connectedAgents := s.GetAgentsInStation(StationId(*stationId))
	for _, agent := range connectedAgents {
		agent.UpdateHelpRequests()
	}
}
