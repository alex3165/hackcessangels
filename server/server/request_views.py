# coding=utf-8

from server import app
from server import utils
from server.database import get_db
from server.models import Point
import server.error_messages

from flask import Response
from flask import redirect
from flask import render_template
from flask import request
from flask import session

import datetime

# POST: Creates a new user. Needed parameters: email, password
# GET: Get an existing user. Needed parameters: email
# PUT: Updates an existing user. Needed parameters: email, password, user
# DELETE: Delets an existing user. Needed parameters: email, password
@app.route("/api/request",methods=['GET', 'POST', 'DELETE'])
@utils.json_response
@utils.user_login_required
def request_api():
    requests = get_db().request
    users = get_db().user

    # Create a new request
    if request.method == "POST":
        if "lat" not in request.form and "lng" not in request.form:
            return server.error_messages.MALFORMED_REQUEST, 400

        user = users.find_one({"email": session["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)

        help_request = requests.Request()
        help_request["user"] = user["_id"]
        help_request["location"]["user_location"] = Point(
                request.form["lat"], request.form["lng"])
        help_request["location"]["last_update"] = datetime.datetime.today()
        help_request["date_requested"] = datetime.datetime.today()
        help_request["active"] = True
        help_request.save()

        return help_request.to_json()

    # Get the current user
    elif request.method == "GET":
        user = collection.find_one({"email": session["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)
        user_requests = requests.find({"user": user["_id"], "active": True})
        return map(users.User, user)

    elif request.method == "DELETE":
        user = users.find_one({"email": session["email"]})
        if user == None:
            return server.error_messages.UNKNOWN_USER, 404
        user = users.User(user)
        user_requests = requests.find({"user": user["_id"], "active": True})
        for help_request in user_requests:
            help_request = requests.Request(help_request)
            help_request["active"] = False
            help_request.save()
        return [], 200

    return [], 405

