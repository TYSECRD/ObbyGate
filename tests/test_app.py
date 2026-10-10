from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_info():
    response = client.get("/api/info")
    assert response.status_code == 200

    data = response.json()
    assert data["name"] == "ObbyGate"
    assert data["version"] == "0.2.0"
    assert "ai-workload-security" in data["focus"]


def test_ai_inference():
    response = client.post(
        "/api/ai/inference",
        params={"prompt": "Secure this AI workload"},
    )

    assert response.status_code == 200

    data = response.json()
    assert data["status"] == "processed"
    assert data["input_length"] == len("Secure this AI workload")
    assert data["result"] == "simulated-secure-inference"


def test_metrics():
    response = client.get("/metrics")

    assert response.status_code == 200
    assert "obbygate_http_requests_total" in response.text
    assert "obbygate_ai_requests_total" in response.text
