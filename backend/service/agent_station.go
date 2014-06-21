package service

import (
	"sync"
)

type AgentStationManager struct {
	sync.RWMutex

	stations map[StationId]map[AgentLogin]bool
	agents   map[AgentLogin]*ConnectedAgent
}

func (manager *AgentStationManager) RemoveAgent(login AgentLogin) {
	manager.RemoveAgentFromStation(login)
	manager.Lock()
	defer manager.Unlock()
	delete(manager.agents, login)
}

func (manager *AgentStationManager) RemoveAgentFromStation(login AgentLogin) {
	manager.Lock()
	defer manager.Unlock()
	for station, agents := range manager.stations {
		if agents[login] {
			delete(manager.stations[station], login)
			break
		}
	}
}

func (manager *AgentStationManager) GetAgent(login AgentLogin) *ConnectedAgent {
	manager.RLock()
	defer manager.RUnlock()
	agent := manager.agents[login]
	return agent
}

func (manager *AgentStationManager) GetAllAgents() []*ConnectedAgent {
	manager.RLock()
	defer manager.RUnlock()
	agents := make([]*ConnectedAgent, 0, 0)
	for _, agent := range manager.agents {
		agents = append(agents, agent)
	}
	return agents
}

func (manager *AgentStationManager) GetAgentsInStation(station StationId) []*ConnectedAgent {
	connectedAgents := make([]*ConnectedAgent, 0, 0)
	manager.RLock()
	defer manager.RUnlock()
	if _, ok := manager.stations[station]; !ok {
		return connectedAgents
	}
	for agent := range manager.stations[station] {
		connectedAgents = append(connectedAgents, manager.agents[agent])
	}
	return connectedAgents
}

func (manager *AgentStationManager) SetAgentStation(login AgentLogin, station StationId) {
	manager.RLock()
	agent := manager.agents[login]
	manager.RUnlock()
	if agent.station == station {
		return
	}
	manager.RemoveAgentFromStation(login)
	manager.Lock()
	stationMap, ok := manager.stations[station]
	if !ok {
		stationMap = make(map[AgentLogin]bool)
		manager.stations[station] = stationMap
	}
	stationMap[login] = true
	manager.Unlock()
}

func (manager *AgentStationManager) AddAgent(agent *ConnectedAgent) {
	manager.Lock()
	defer manager.Unlock()
	manager.agents[agent.login] = agent
}
