import logging
import json
from flask import Flask, render_template


logging.basicConfig(
    level=logging.INFO, format="%(asctime)s %(name)-12s %(levelname)-8s %(message)s"
)
logger = logging.getLogger(__name__)
logging.getLogger("googleapiclient.discovery").setLevel(logging.WARNING)
logging.getLogger("googleapiclient.discovery_cache").setLevel(logging.ERROR)

app = Flask(__name__)


@app.route("/red")
def red():
    return render_template("main.html.j2", color="red")


@app.route("/")
def root():
    return render_template("main.html.j2", color="red")


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=8000)
