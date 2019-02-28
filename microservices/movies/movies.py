from data.access import root_dir, nice_json
from flask import Flask
from werkzeug.exceptions import NotFound
import json


app = Flask(__name__)

with open("{}/movies.json".format(root_dir()), "r") as f:
    movies = json.load(f)


@app.route("/health", methods=['GET'])
def health():
    return "I'm alive"


@app.route("/", methods=['GET'])
def hello():
    return nice_json({
        "uri": "/",
        "subresource_uris": {
            "movies": "/movies",
            "movie": "/movies/<id>"
        }
    })


@app.route("/movies/<movieid>", methods=['GET'])
def movie_info(movieid):
    if movieid not in movies:
        raise NotFound

    result = movies[movieid]
    result["uri"] = "/movies/{}".format(movieid)

    return nice_json(result)


@app.route("/movies", methods=['GET'])
def movie_record():
    return nice_json(movies)


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
