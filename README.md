# 🚀 Hello World Flask – DevSecOps Pipeline

A minimal Python Flask application with a **production-grade DevSecOps pipeline** powered by GitHub Actions.

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    GitHub Actions Pipeline                   │
│                                                             │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌───────────┐              │
│  │ Lint │  │ SAST │  │ Test │  │ Dep Scan  │   (parallel)  │
│  └──┬───┘  └──┬───┘  └──┬───┘  └─────┬─────┘              │
│     └─────────┴─────────┴─────────────┘                     │
│                         │                                   │
│              ┌──────────▼──────────┐                        │
│              │  Docker Build +     │                        │
│              │  Trivy Image Scan   │                        │
│              └──────────┬──────────┘                        │
│                         │                                   │
│              ┌──────────▼──────────┐                        │
│              │  Push to GHCR       │  (main branch only)    │
│              └─────────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

## Pipeline Stages

| # | Stage | Tool | Purpose |
|---|-------|------|---------|
| 1 | **Lint** | flake8 | PEP-8 style enforcement |
| 2 | **SAST** | Bandit | Static security analysis |
| 3 | **Test** | pytest + coverage | Unit tests with coverage |
| 4 | **Dep Scan** | pip-audit | CVE check on dependencies |
| 5 | **Build & Scan** | Docker + Trivy | Container build + vulnerability scan |
| 6 | **Push** | GHCR | Publish image (main only) |

## Quick Start

### Run locally

```bash
pip install -r requirements.txt
python app.py
# → http://localhost:5000
```

### Run with Docker

```bash
docker build -t flask-hello .
docker run -p 5000:5000 flask-hello
```

### Run tests

```bash
pip install -r requirements-dev.txt
pytest tests/ -v
```

## Project Structure

```
.
├── app.py                          # Flask application
├── requirements.txt                # Production dependencies
├── requirements-dev.txt            # Dev / CI dependencies
├── Dockerfile                      # Multi-stage Docker build
├── .dockerignore
├── .gitignore
├── tests/
│   ├── __init__.py
│   └── test_app.py                 # Pytest unit tests
└── .github/
    └── workflows/
        └── devsecops.yml           # DevSecOps CI/CD pipeline
```

## GitHub Setup

1. Push this repo to GitHub.
2. The pipeline runs automatically on push/PR to `main`.
3. Container images are published to `ghcr.io/<owner>/<repo>`.

> **Note:** GHCR push uses the built-in `GITHUB_TOKEN` — no extra secrets needed.
