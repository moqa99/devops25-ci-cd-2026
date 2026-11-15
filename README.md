
# NEXUS CI/CD

### Automated Testing, Container Delivery & Recovery

NEXUS CI/CD is a DevOps project developed as part of
the CI/CD course at Nackademin.

The project demonstrates an automated software delivery
pipeline using Python, FastAPI, GitHub Actions and Docker.

## Project Objectives

- Automate code testing and quality checks.
- Prevent faulty changes from reaching deployment.
- Build Docker images after successful CI validation.
- Simulate automated application delivery.
- Verify deployed application health and version.
- Demonstrate controlled rollback to a stable version.
- Maintain traceability through Git commits and CI logs.

## Technology Stack

- Python 3.12
- FastAPI
- Pytest
- Ruff
- Docker
- Git and GitHub
- GitHub Actions
- Bash

## CI/CD Architecture

Code Change
    |
    v
GitHub Push / Pull Request
    |
    v
Test and Lint
    |-- Pytest
    |-- Ruff
    |-- JUnit XML Artifact
    |
    v
Docker Build
    |
    v
Simulated Deployment (push only)
    |-- Start Container
    |-- Health Check
    |-- Version Verification
    |-- API Verification
    |-- Container Cleanup

Each downstream job depends on successful completion
of its required previous job.

## Application Versions

### Version 1.0.0

Initial working application with:

- Health endpoint
- Addition endpoint
- Version endpoint

### Version 1.1.0

Introduces multiplication support while preserving
the existing API functionality.

Endpoints:

- GET /health
- GET /version
- GET /add?a=2&b=3
- GET /multiply?a=4&b=5

## Automated Testing

The application currently includes nine automated tests.

Tests cover:

- Application health
- Addition logic
- Division logic
- Division-by-zero handling
- API addition
- API input validation
- Version information
- Multiplication logic
- Multiplication API

Run tests locally:

    python -m pytest -v

Run code quality checks:

    python -m ruff check app tests

GitHub Actions also publishes a JUnit XML test report
as an artifact named pytest-results.

## Docker

Build version 1.1.0:

    docker build -t nexus-cicd-api:1.1.0 .

Start the application:

    docker run -d --rm \
      --name nexus-cicd-demo \
      -p 127.0.0.1:8001:8000 \
      nexus-cicd-api:1.1.0

Verify the API:

    curl http://localhost:8001/health
    curl http://localhost:8001/version

## Quality Gate Demonstration

A controlled regression was introduced in the
addition function.

The function was intentionally changed from addition
to subtraction.

Results:

- Two automated tests failed.
- The CI workflow failed.
- Downstream delivery jobs were blocked.
- The defect was corrected.
- The subsequent pipeline completed successfully.

Relevant commits:

- 8990de5 - Introduce regression
- e4a59ad - Restore correct functionality

This demonstrates automated regression detection.

## Rollback Demonstration

Two Docker versions were created:

- nexus-cicd-api:1.0.0
- nexus-cicd-api:1.1.0

A manual rollback from 1.1.0 to 1.0.0 was verified.

An automated local rollback script was also created:

    scripts/deploy_with_rollback.sh

Successful deployment test:

    bash scripts/deploy_with_rollback.sh \
      nexus-cicd-api:1.1.0 1.1.0

Controlled rollback test:

    bash scripts/deploy_with_rollback.sh \
      nexus-cicd-api:1.1.0 9.9.9

The second command deliberately requests an incorrect
expected version to trigger rollback.

After rollback:

- Version 1.0.0 was restored.
- Health verification passed.
- The container was running successfully.

The script returns exit code 2 when rollback succeeds
after a failed deployment verification.

## Technical Decisions

### Why GitHub Actions?

GitHub Actions provides automated execution of tests,
quality checks and deployment verification directly
from repository events.

### Why Docker?

Docker provides consistent application packaging
and versioned images that can be restarted or restored.

### Why Quality Gates?

Automated tests prevent known regressions from
continuing into the delivery process.

### Why Rollback?

Rollback reduces recovery time by allowing a previously
working application version to be restored.

## Current Limitations

- Deployment is simulated, not a permanent production
  deployment.
- Local rollback requires the Docker images to exist.
- Rollback is not yet integrated into GitHub Actions.
- Docker images are rebuilt in separate CI/CD jobs.
- Versions are currently validated using fixed values
  in the workflow.
- No external container registry is configured.

## Potential Improvements

- Reuse the same immutable image across CI/CD jobs.
- Add image publishing and commit-based version tags.
- Integrate automated rollback testing into CI.
- Replace fixed version checks with dynamic metadata.
- Introduce stronger container security controls.
- Add environment-specific deployment configuration.

## Project Status

Implemented and verified:

- Automated CI
- Nine automated tests
- Code quality checks
- Docker image builds
- Test report artifacts
- Simulated CD
- Regression detection
- Quality gate demonstration
- Manual rollback
- Automated local rollback demonstration

## Author

moqa99

DevOps Student - Nackademin
