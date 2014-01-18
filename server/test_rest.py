from flask import Flask, request
import random
import json

app = Flask(__name__)

from optparse import OptionParser

USERS = {}
@app.route('/user',methods=['GET', 'POST', 'PUT'])
def user():
    if request.method == "POST":
        # Creates a new user
        user = {
            "id": random.randint(0, 100000)
        }
        USERS[user["id"]] = user
        return json.dumps(user)
    elif request.method == "GET":
        print request.form
        if not "id" in request.args:
            return "", 400
        if not int(request.args["id"]) in USERS:
            return "", 404
        return json.dumps(USERS[int(request.args["id"])])
    elif request.method == "PUT":
        if not "id" in request.form:
            return "", 400
        if not "data" in request.form:
            return "", 400
        user = json.loads(request.form["data"])
        if not int(user["id"]) in USERS:
            return "", 403
        USERS[int(user["id"])] = user
        return json.dumps(user)
    return "", 405

@app.route('/user/all')
def dumpall():
    return json.dumps(USERS)

@app.route('/user/reset')
def reset():
    USERS = {}
    return json.dumps(USERS)

if __name__ == '__main__':
    parser = OptionParser()
    parser.add_option("-l", "--listen", dest="listen", default="localhost",
                      help="address to listen to")
    parser.add_option("-d", "--debug", action="store_true",
                      dest="debug", default=False,
                      help="Enable debug mode")

    (options, args) = parser.parse_args()

    app.run(host=options.listen,debug=options.debug)
