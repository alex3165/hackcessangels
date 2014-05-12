package model

func (m *Model) GetAllUsers() ([]*User, error) {
	users := make([]*User, 0)
	err := m.users.Find(nil).All(&users)
	return users, err
}

func (m *Model) GetAllRequests() ([]*HelpRequest, error) {
	requests := make([]*HelpRequest, 0)
	err := m.helpRequests.Find(nil).All(&requests)
	return requests, err
}
