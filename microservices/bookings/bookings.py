from data.access import root_dir, nice_json
from flask import Flask
import json
from werkzeug.exceptions import NotFound


app = Flask(__name__)

with open("{}/bookings.json".format(root_dir()), "r") as f:
    bookings = json.load(f)

@app.route("/health", methods=['GET'])
def health():
    return "I'm alive"

@app.route("/", methods=['GET'])
def hello():
    return nice_json({
        "uri": "/",
        "subresource_uris": {
            "bookings": "/bookings",
            "booking": "/bookings/<username>"
        }
    })

@app.route("/bookings", methods=['GET'])
def booking_list():
    return nice_json(bookings)


@app.route("/bookings/<username>", methods=['GET'])
def booking_record(username):
    if username not in bookings:
        raise NotFound

    return nice_json(bookings[username])

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003, debug=True)

