from server import app

@app.route("/agent/new")
def create_agent():
    """Creates a new agent in the database.
    """
    # TODO(etienne): Create a new agent
    return ""

@app.route("/agent/<int:id>")
def get_agent():
    """Get data about the specified agent from the database.
    """
    # TODO(etienne): Get the agent
    return ""

@app.route("/agent/<int:id>/update")
def update_agent():
    """Updates the agent.
    """
    # TODO(etienne): Updates the agent
    return ""

