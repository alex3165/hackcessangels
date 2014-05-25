package server

import (
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/gorilla/securecookie"
	"github.com/gorilla/sessions"

	"hackcessangels/backend/model"
)

type Server struct {
	DatabaseServer string
	Database       string
	HTTPServer     *http.Server

	model *model.Model
	store *sessions.CookieStore
}

func NewServer() *Server {
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
		store: sessions.NewCookieStore(
			securecookie.GenerateRandomKey(64),
			securecookie.GenerateRandomKey(32)),
	}

	r.HandleFunc("/api/agent", s.handleAgentPosition)
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
	return nil
}

func (s *Server) Run() error {
	if err := s.init(); err != nil {
		return err
	}
	return s.HTTPServer.ListenAndServe()
}
