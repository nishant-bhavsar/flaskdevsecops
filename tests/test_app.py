"""Unit tests for the Flask application."""

import json

import pytest

from app import app


@pytest.fixture
def client():
    """Create a test client for the Flask app."""
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_hello_endpoint(client):
    """GET / should return 200 and 'Hello, World!'."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.data.decode() == "Hello, World!"


def test_health_endpoint(client):
    """GET /health should return 200 and JSON status healthy."""
    response = client.get("/health")
    assert response.status_code == 200
    data = json.loads(response.data)
    assert data["status"] == "healthy"
