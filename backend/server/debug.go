package server

import (
	"bytes"
	"encoding/json"
	"html/template"
	"image/jpeg"
	"log"
	"net/http"

	"github.com/nfnt/resize"

	"hackcessangels/backend/model"
)

var (
	debugTmpl = template.Must(template.New("debug").Parse(`<html>
<body>
Users (base de données):
Users (API):
<ul>
{{range .APIUsers}}
    <li>{{.}}</li>
{{end}}
</ul>
<br/>
Agents connectés:
<ul>
{{range .ConnectedAgents}}
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
		// Try to decode image
		if user.Image != nil && len(user.Image) != 0 {
			reader := bytes.NewReader(user.Image)
			image, err := jpeg.Decode(reader)
			if err != nil {
				log.Println(user.Email)
				log.Println(err.Error())
				log.Println(image)
				panic(err)
			}
			_ = resize.Thumbnail(128, 128, image, resize.Bicubic)
		}

		apiUser := NewApiUser(user, true)
		if apiUser.Image != nil {
			*apiUser.Image = []byte("Image present")
		}
		b, err := json.Marshal(apiUser)
		if err == nil {
			apiUsers[i] = string(b)
		} else {
			log.Printf("index %v, user %+v, error %v", i, user, err)
			apiUsers[i] = err.Error()
		}
	}

	type TmplData struct {
		APIUsers        []string
		ConnectedAgents []string

		HelpRequests []*model.HelpRequest
	}
	data := TmplData{
		APIUsers:        apiUsers,
		ConnectedAgents: make([]string, 0, 0),
		HelpRequests:    helpRequests,
	}

	agents := s.service.GetAllAgents()
	for _, agent := range agents {
		data.ConnectedAgents = append(data.ConnectedAgents, agent.String())
	}

	err = debugTmpl.Execute(w, data)
	if err != nil {
		log.Print(err)
	}
}
