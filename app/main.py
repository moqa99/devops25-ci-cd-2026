
from fastapi import FastAPI

from app.service import add, multiply

app = FastAPI(title="NEXUS CI/CD API")


@app.get("/")
def root():
    return {"message": "NEXUS CI/CD API"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/add")
def add_endpoint(a: float, b: float):
    return {"result": add(a, b)}


@app.get("/multiply")
def multiply_endpoint(a: float, b: float):
    return {"result": multiply(a, b)}


@app.get("/version")
def get_version():
    return {
        "version": "1.1.0",
        "environment": "demo",
    }
