from fastapi import FastAPI

from app.service import add

app = FastAPI(title="DevOps CI/CD Demo")


@app.get("/")
def root():
    return {"message": "DevOps CI/CD Demo"}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/add")
def add_endpoint(a: float, b: float):
    return {"result": add(a, b)}
@app.get("/version")
def get_version():
    return {
        "version": "1.0.0",
        "environment": "demo"
    }