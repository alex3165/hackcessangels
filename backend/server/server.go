package server

import (
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/gorilla/securecookie"
	"github.com/gorilla/sessions"

	"hackcessangels/backend/model"
	"hackcessangels/backend/service"
)

type Server struct {
	DatabaseServer string
	Database       string
	HTTPServer     *http.Server

	model   *model.Model
	store   *sessions.CookieStore
	service *service.AgentService
}

func NewServer() *Server {
	return NewServerWithCookieStore(securecookie.GenerateRandomKey(64),
		securecookie.GenerateRandomKey(32))
}

func NewServerWithCookieStore(hashKey []byte, blockKey []byte) *Server {
	r := mux.NewRouter()
	s := &Server{
		DatabaseServer: "localhost",
		Database:       "hackcessangels",
		HTTPServer: &http.Server{
			Addr:           ":5000",
			Handler:        r,
			ReadTimeout:    30 * time.Second,
			WriteTimeout:   30 * time.Second,
			MaxHeaderBytes: 1 << 20,
		},
		store: sessions.NewCookieStore(hashKey, blockKey),
	}

	r.HandleFunc("/api/agent/requests", s.handleAgentRequests)
	r.HandleFunc("/api/agent/position", s.handleAgentPosition)
	r.HandleFunc("/api/help", s.handleHelp)
	r.HandleFunc("/api/user", s.handleUser)
	r.HandleFunc("/api/user/login", s.handleUserLogin)
	r.HandleFunc("/debug", s.handleDebug)

	return s
}

func (s *Server) init() error {
	var err error
	s.model, err = model.NewModel(s.DatabaseServer, s.Database)
	if err != nil {
		return err
	}
	err = s.model.ResetAndLoadStationsFromFile()
	if err != nil {
		return err
	}
	s.service, err = service.NewAgentService(s.model)
	if err != nil {
		return err
	}
    s.model.RegisterHelpRequestObserver(s.service)

	return nil
}

func (s *Server) Run() error {
	if err := s.init(); err != nil {
		return err
	}
	return s.HTTPServer.ListenAndServe()
}
