from server import app

@app.route("/request/new")
def create_request():
    """Creates a new request in the database.
    """
    # TODO(etienne): Create a new request
    return ""

@app.route("/request/<int:id>")
def get_request():
    """Get data about the specified request from the database.
    """
    # TODO(etienne): Get the request
    return ""

@app.route("/request/<int:id>/update_location")
def update_request_location():
    """Updates the request location.
    """
    # TODO(etienne): Updates the request location
    return ""

@app.route("/request/<int:id>/answer")
def answer_request():
    """Announces that an agent answers the request
    """
    # TODO(etienne): Update the request and send notification
    return ""

