package main

import (
	"flag"
	"github.com/gorilla/mux"
	"io"
	"labix.org/v2/mgo"
	"log"
	"net/http"
	"net/http/fcgi"
	"runtime"
)

var local = flag.String("local", "", "serve as webserver, example: 0.0.0.0:8000")

func init() {
	runtime.GOMAXPROCS(runtime.NumCPU())
}

type FastCGIServer struct {
	session *mgo.Session
}

func NewFastCGIServer() (*FastCGIServer, error) {
	var s FastCGIServer
	var err error
	s.session, err = mgo.Dial("localhost")
	if err != nil {
		return nil, err
	}
	// Optional. Switch the session to a monotonic behavior
	s.session.SetMode(mgo.Monotonic, true)
	return &s, nil
}

func (s *FastCGIServer) returnError(w http.ResponseWriter, err error) {
	w.WriteHeader(http.StatusInternalServerError)
	io.WriteString(w, err.Error())
}

func (s *FastCGIServer) homeView(w http.ResponseWriter, req *http.Request) {
	io.WriteString(w, "Home")
    // TODO(etienne): add template for home page + login
}

func (s *FastCGIServer) addUser(w http.ResponseWriter, req *http.Request) {
    if req.Method != "POST" {
        // TODO(etienne): add template to create user
    }
	newUser := User{
		Email:   req.PostFormValue("email"),
		Name:    req.PostFormValue("name"),
		Message: req.PostFormValue("message"),
		Agent:   false,
	}
	c := s.session.DB("hackcessangels").C("users")
	_, err := c.Upsert(User{Email: newUser.Email}, newUser)
	if err != nil {
		s.returnError(w, err)
	}
	io.WriteString(w, "OK")
}

func (s *FastCGIServer) addAgent(w http.ResponseWriter, req *http.Request) {
    if req.Method != "POST" {
        // TODO(etienne): add template to create agent
    }
	newUser := User{
		Email:   req.PostFormValue("email"),
		Name:    req.PostFormValue("name"),
		Message: req.PostFormValue("message"),
		Agent:   true,
	}
	c := s.session.DB("hackcessangels").C("users")
	_, err := c.Upsert(User{Email: newUser.Email}, newUser)
	if err != nil {
		s.returnError(w, err)
	}
	io.WriteString(w, "OK")
}

func main() {
	r := mux.NewRouter()
	b, err := NewFastCGIServer()
	if err != nil {
		panic(err)
	}

	r.HandleFunc("/", b.homeView)
	r.HandleFunc("/api/addUser", b.addUser)
	r.HandleFunc("/api/addAgent", b.addAgent)

	flag.Parse()

	if *local != "" { // Run as a local web server
		err = http.ListenAndServe(*local, r)
	} else { // Run as FCGI via standard I/O
		err = fcgi.Serve(nil, r)
	}
	if err != nil {
		log.Fatal(err)
	}
}
