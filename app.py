"""Hello World Flask Application."""

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def hello():
    """Return a friendly Hello World greeting."""
    return "Hello, World!"


@app.route("/health")
def health():
    """Health check endpoint for container orchestration."""
    return jsonify({"status": "healthy"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
