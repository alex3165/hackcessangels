package server

import (
	"encoding/json"
	"html/template"
	"log"
	"net/http"

	"hackcessangels/backend/model"
)

var (
	debugTmpl = template.Must(template.New("debug").Parse(`<html>
<body>
Users (base de données):
<ul>
{{range .Users}}
    <li>{{.| printf "%+v"}}</li>
{{end}}
</ul>
<br/>
Users (API):
<ul>
{{range .APIUsers}}
    <li>{{.}}</li>
{{end}}
</ul>
<br/>
Requetes (base de données):
<ul>
{{range .HelpRequests}}
    <li>{{.|printf "%+v"}}</li>
{{end}}
</ul>
</body>
</html>
`))
)

func (s *Server) handleDebug(w http.ResponseWriter, r *http.Request) {
	users, err := s.model.GetAllUsers()
	if err != nil {
		returnError(500, err.Error(), w)
	}

	helpRequests, err := s.model.GetAllRequests()
	if err != nil {
		returnError(500, err.Error(), w)
	}

	apiUsers := make([]string, len(users), len(users))
	for i, user := range users {
		b, err := json.Marshal(user)
		if err == nil {
			apiUsers[i] = string(b)
		} else {
			log.Printf("index %v, user %+v, error %v", i, user, err)
			apiUsers[i] = err.Error()
		}
	}

	type TmplData struct {
		Users    []*model.User
		APIUsers []string

		HelpRequests []*model.HelpRequest
	}

	err = debugTmpl.Execute(w, TmplData{Users: users, APIUsers: apiUsers, HelpRequests: helpRequests})
	if err != nil {
		log.Print(err)
	}
}
