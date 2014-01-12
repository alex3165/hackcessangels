#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""Main entry point for the HackcessAngel server.
"""

# configuration
MONGODB_HOST = 'localhost'
MONGODB_PORT = 27017

from flask import Flask
app = Flask(__name__)
app.config.from_object(__name__)

import server.agent_views
import server.user_views
import server.request_views

@app.route("/")
def home():
    """Page d'accueil de l'application. Devrait être une page statique."""
    return "Hello World!"

if __name__ == "__main__":
    app.run()
