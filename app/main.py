from fastapi import FastAPI
from prometheus_client import Counter, generate_latest
from starlette.responses import Response

app = FastAPI(
    title="ObbyGate",
    version="0.2.0",
    description="Cloud, supply chain, and AI workload security lab",
)

REQUEST_COUNT = Counter(
    "obbygate_http_requests_total",
    "Total HTTP requests handled by ObbyGate",
    ["endpoint"],
)

AI_REQUEST_COUNT = Counter(
    "obbygate_ai_requests_total",
    "Total simulated AI workload requests",
)


@app.get("/health")
def health():
    REQUEST_COUNT.labels(endpoint="/health").inc()
    return {"status": "healthy"}


@app.get("/api/info")
def info():
    REQUEST_COUNT.labels(endpoint="/api/info").inc()
    return {
        "name": "ObbyGate",
        "version": "0.2.0",
        "environment": "development",
        "focus": [
            "cloud-security",
            "software-supply-chain",
            "ai-workload-security",
        ],
    }


@app.post("/api/ai/inference")
def ai_inference(prompt: str):
    REQUEST_COUNT.labels(endpoint="/api/ai/inference").inc()
    AI_REQUEST_COUNT.inc()

    return {
        "workload": "obbygate-ai",
        "status": "processed",
        "input_length": len(prompt),
        "security": {
            "non_root": True,
            "read_only_filesystem": True,
            "privilege_escalation": False,
        },
        "result": "simulated-secure-inference",
    }


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain")