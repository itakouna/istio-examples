from data.access import root_dir, nice_json
from flask import Flask
import json
from werkzeug.exceptions import NotFound


app = Flask(__name__)

service_version = "bookings-v1"

with open("{}/bookings.json".format(root_dir()), "r") as f:
    bookings = json.load(f)


@app.route("/health", methods=['GET'])
def health():
    return "I'm alive"


@app.route("/", methods=['GET'])
def hello():
    response = {
        "service": service_version,
        "data": {
            "uri": "/",
            "subresource_uris": {
                "bookings": "/bookings",
                "booking": "/bookings/<username>"
            }
        }
    }
    return nice_json(response)


@app.route("/bookings", methods=['GET'])
def booking_list():
    response = {
        "service": service_version,
        "data": bookings
    }
    return nice_json(response)


@app.route("/bookings/<username>", methods=['GET'])
def booking_record(username):
    if username not in bookings:
        raise NotFound
    response = {
        "service": service_version,
        "data": bookings[username]
    }
    return nice_json(response)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)
