#!/usr/bin/env python3
"""Main entry point for the HackcessAngel server.
"""

from flask import Flask
APP = Flask(__name__)

@APP.route("/agent/new")
def create_agent():
    """Creates a new agent in the database.
    """
    # TODO(etienne): Create a new agent
    return ""

@APP.route("/agent/<int:id>")
def get_agent():
    """Get data about the specified agent from the database.
    """
    # TODO(etienne): Get the agent
    return ""

@APP.route("/agent/<int:id>/update")
def update_agent():
    """Updates the agent.
    """
    # TODO(etienne): Updates the agent
    return ""

@APP.route("/user/new")
def create_user():
    """Creates a new user in the database.
    """
    # TODO(etienne): Create a new user
    return ""

@APP.route("/user/<int:id>")
def get_user():
    """Get data about the specified user from the database.
    """
    # TODO(etienne): Get the user
    return ""

@APP.route("/user/<int:id>/update")
def update_user():
    """Updates the user.
    """
    # TODO(etienne): Updates the user
    return ""


@APP.route("/request/new")
def create_request():
    """Creates a new request in the database.
    """
    # TODO(etienne): Create a new request
    return ""

@APP.route("/request/<int:id>")
def get_request():
    """Get data about the specified request from the database.
    """
    # TODO(etienne): Get the request
    return ""

@APP.route("/request/<int:id>/update_location")
def update_request_location():
    """Updates the request location.
    """
    # TODO(etienne): Updates the request location
    return ""

@APP.route("/request/<int:id>/answer")
def answer_request():
    """Announces that an agent answers the request
    """
    # TODO(etienne): Update the request and send notification
    return ""

@APP.route("/")
def home():
    """Page d'accueil de l'application. Devrait être une page statique."""
    return "Hello World!"

if __name__ == "__main__":
    APP.run()
