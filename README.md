
# NEXUS CI/CD
### Automated Testing, Container Delivery & Recovery

NEXUS CI/CD is a DevOps engineering project developed as part of the CI/CD course at Nackademin, Sweden.

The project demonstrates the design, implementation and verification of an automated software delivery pipeline using Python, FastAPI, Docker, GitHub Actions and Bash.

Its primary objective is to show how automated testing, quality gates, containerization, deployment verification and rollback can work together to create a reliable and traceable delivery process.

The project includes successful deployment scenarios, controlled regression testing and automated recovery verification.

---

## 1. Project Objectives

The project was designed to:

- Automate application testing and code quality validation.
- Detect software regressions before deployment.
- Prevent failed builds from progressing through the pipeline.
- Package applications into reproducible Docker images.
- Associate Docker images with specific Git commits.
- Reuse validated Docker images across pipeline jobs.
- Verify artifact integrity using SHA-256 checksums.
- Simulate automated application deployment.
- Validate application health, functionality and version.
- Demonstrate manual and automated rollback.
- Verify rollback behavior through GitHub Actions.
- Maintain traceability using Git history, workflow logs and artifacts.

The resulting system demonstrates key Continuous Integration and Continuous Delivery principles.

---

## 2. Technology Stack

| Technology | Purpose |
|------------|---------|
| Python 3.12 | Application development |
| FastAPI | REST API framework |
| Pytest | Automated unit and API testing |
| Ruff | Static analysis and code quality |
| Docker | Application containerization |
| Git | Source code version control |
| GitHub | Repository hosting and collaboration |
| GitHub Actions | CI/CD workflow automation |
| Bash | Deployment and rollback scripting |
| JUnit XML | Automated test reporting |
| SHA-256 | Docker artifact integrity verification |

### Development Environment

The project was developed locally on Windows using:

- Visual Studio Code
- Git Bash
- Python virtual environments
- Docker Desktop
- Docker Engine with WSL 2

CI/CD workflows execute on GitHub-hosted Ubuntu runners.

---

## 3. CI/CD Architecture

The automated pipeline contains four main jobs:

1. Test and Lint
2. Build Docker Image
3. Simulated Deployment
4. Automated Rollback Test

### Pipeline Overview

```text
Developer
    |
    v
Code Change
    |
    v
Git Commit & Push
    |
    v
GitHub Repository
    |
    v
+----------------------------------+
| 1. TEST AND LINT                 |
|----------------------------------|
| Python 3.12                      |
| Pytest - 9 automated tests       |
| Ruff - Code quality checks       |
| JUnit XML test report            |
+----------------------------------+
    |
    | Tests passed
    v
+----------------------------------+
| 2. BUILD DOCKER IMAGE            |
|----------------------------------|
| Build Docker image               |
| Tag image using Git commit SHA   |
| Verify Docker image              |
| Export image as TAR archive      |
| Generate SHA-256 checksum        |
| Upload Docker artifact           |
+----------------------------------+
    |
    | Build successful
    v
+----------------------------------+
| 3. SIMULATED DEPLOYMENT          |
|----------------------------------|
| Download Docker artifact         |
| Verify SHA-256 checksum          |
| Load existing Docker image       |
| Start application container      |
| Verify application health        |
| Verify application version       |
| Verify addition API              |
| Verify multiplication API        |
| Clean up container               |
+----------------------------------+
    |
    | Deployment verified
    v
+----------------------------------+
| 4. AUTOMATED ROLLBACK TEST       |
|----------------------------------|
| Prepare stable version 1.0.0     |
| Load current application image   |
| Verify successful deployment     |
| Simulate version mismatch        |
| Trigger rollback script          |
| Restore version 1.0.0            |
| Verify health and image          |
| Clean up test environment        |
+----------------------------------+
    |
    v
Pipeline Complete
```

### Pipeline Dependencies

GitHub Actions uses job dependencies to control execution order.

The Docker build depends on successful completion of the testing job.

The simulated deployment depends on the Docker build.

The automated rollback test depends on both the Docker build and simulated deployment.

This prevents known test failures from progressing through the delivery process.

Deployment and rollback jobs execute for push events, while pull requests targeting main run the CI validation jobs.

---

## 4. Repository Structure

```text
devops25-ci-cd-2026/
|
+-- .github/
|   +-- workflows/
|       +-- ci.yml
|
+-- app/
|   +-- __init__.py
|   +-- main.py
|   +-- service.py
|
+-- tests/
|   +-- test_api.py
|   +-- test_service.py
|
+-- scripts/
|   +-- deploy_with_rollback.sh
|
+-- .dockerignore
+-- .gitignore
+-- Dockerfile
+-- requirements.txt
+-- README.md
```

### Main Components

**app/main.py**

Defines the FastAPI application and its REST endpoints.

**app/service.py**

Contains the application's business logic, including addition, division and multiplication.

**tests/**

Contains automated unit tests and API integration tests.

**Dockerfile**

Defines the container image using Python 3.12.

**.github/workflows/ci.yml**

Implements the complete four-job GitHub Actions pipeline.

**scripts/deploy_with_rollback.sh**

Implements local deployment verification and automated rollback to a stable Docker version.

---

## 5. Application Versions

The project uses two application versions to demonstrate release management and recovery.

### Version 1.0.0 - Initial Release

The initial working version includes:

- Health endpoint
- Addition endpoint
- Version endpoint
- Basic application functionality

Example:

```http
GET /version
```

Response:

```json
{
  "version": "1.0.0",
  "environment": "demo"
}
```

### Version 1.1.0 - Feature Release

Version 1.1.0 introduces multiplication functionality while preserving existing API behavior.

New functionality:

```http
GET /multiply?a=4&b=5
```

Response:

```json
{
  "result": 20.0
}
```

The version endpoint returns:

```json
{
  "version": "1.1.0",
  "environment": "demo"
}
```

### API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | / | Application information |
| GET | /health | Health verification |
| GET | /version | Application version |
| GET | /add?a=2&b=3 | Addition |
| GET | /multiply?a=4&b=5 | Multiplication (v1.1.0) |
| GET | /docs | Interactive API documentation |

The division function is currently part of the service layer rather than a public API endpoint.

---

## 6. Automated Testing

The project includes nine automated tests covering application functionality and API behavior.

### Unit Tests

- Addition functionality
- Division functionality
- Division-by-zero exception handling
- Multiplication functionality

### API Tests

- Application health
- Addition endpoint
- Version endpoint
- Invalid input validation
- Multiplication endpoint

### Run Tests Locally

Install dependencies:

```bash
python -m pip install -r requirements.txt
```

Run the test suite:

```bash
python -m pytest -v
```

Expected result:

```text
9 passed
```

### Code Quality

Run Ruff:

```bash
python -m ruff check app tests
```

Expected result:

```text
All checks passed!
```

### Automated Test Reports

GitHub Actions generates a JUnit XML test report.

The report is uploaded as an artifact named:

```text
pytest-results
```

This artifact provides downloadable evidence of automated test execution.

Test artifacts are configured with a retention period of 14 days.

---

## 7. Docker Containerization

The application is packaged using Docker and the Python 3.12 slim base image.

Docker provides consistent application dependencies and an isolated runtime environment.

### Build Version 1.1.0

```bash
docker build -t nexus-cicd-api:1.1.0 .
```

### Start Container

```bash
docker run -d --rm \
  --name nexus-cicd-demo \
  -p 127.0.0.1:8001:8000 \
  nexus-cicd-api:1.1.0
```

### Verify Application

```bash
curl http://localhost:8001/health
curl http://localhost:8001/version
curl "http://localhost:8001/add?a=2&b=3"
curl "http://localhost:8001/multiply?a=4&b=5"
```

### View Container Logs

```bash
docker logs nexus-cicd-demo
```

### Stop Container

```bash
docker stop nexus-cicd-demo
```

---

## 8. Quality Gate Demonstration

A controlled regression was introduced to verify that the CI pipeline correctly detects faulty application code.

### Regression Scenario

The addition function was intentionally changed from:

```python
return a + b
```

To:

```python
return a - b
```

This caused the application to calculate:

```text
2 + 3 = -1
```

Instead of:

```text
2 + 3 = 5
```

### Test Results

Two automated tests detected the regression:

- test_add
- test_add_endpoint

Results:

```text
2 failed
5 passed
```

GitHub Actions marked the workflow as failed.

Because the Docker build and deployment jobs depend on successful testing, the delivery process was blocked.

### Recovery

The faulty addition logic was corrected.

All seven tests in the original test suite passed again.

The subsequent GitHub Actions pipeline completed successfully.

### Git History

Regression commit:

```text
8990de5
```

Recovery commit:

```text
e4a59ad
```

### Demonstrated Principle

Automated quality gates prevent known regressions from progressing into deployment.

The failed workflow was retained as evidence of the pipeline's protection mechanism.

---

## 9. Docker Image Versioning

The pipeline uses the Git commit SHA to tag application images.

Example:

```text
nexus-cicd-api:<git-commit-sha>
```

This connects the generated Docker image to the exact source revision used during its build.

### Image Reuse

The Docker image is built once in the build job.

It is then exported using:

```bash
docker save
```

The exported image is uploaded to GitHub Actions as an artifact.

The deployment job downloads and loads that same image using:

```bash
docker load
```

This prevents the deployment job from rebuilding the application from source.

### Artifact Integrity

The pipeline generates a SHA-256 checksum for the Docker archive.

After downloading the artifact, the deployment job verifies the archive checksum before loading the image.

This detects unexpected changes to the archive during transfer or storage.

The checksum is an integrity check, not a cryptographic signature or proof of trusted origin.

### Docker Artifact

Artifact name:

```text
nexus-docker-image
```

Contents:

```text
nexus-cicd-api.tar
nexus-cicd-api.tar.sha256
```

The Docker artifact has a retention period of three days.

---

## 10. Simulated Continuous Delivery

After successful testing and Docker image creation, GitHub Actions starts the simulated deployment job.

The process:

1. Downloads the previously built Docker artifact.
2. Verifies its SHA-256 checksum.
3. Loads the Docker image.
4. Starts the container.
5. Executes application health checks.
6. Verifies version 1.1.0.
7. Verifies addition functionality.
8. Verifies multiplication functionality.
9. Cleans up the temporary container.

### Deployment Verification

Expected API results:

```text
/health       -> status: ok
/version      -> version: 1.1.0
/add          -> result: 5.0
/multiply     -> result: 20.0
```

The simulated deployment runs on a temporary GitHub-hosted runner.

It does not deploy the application to a permanent production server.

---

## 11. Manual Rollback Demonstration

A manual rollback was performed between two working Docker versions.

Initial state:

```text
Running: nexus-cicd-api:1.1.0
```

The newer container was stopped and replaced with the previously verified Docker image.

Restored state:

```text
Running: nexus-cicd-api:1.0.0
```

### Verification Results

| Verification | Before | After Rollback |
|-------------|--------|----------------|
| Version | 1.1.0 | 1.0.0 |
| Health | OK | OK |
| Addition | Working | Working |
| Multiplication endpoint | Available | Not available |

The rollback was completed without modifying or rebuilding the application's source code.

This demonstrates restoration using versioned Docker images.

---

## 12. Automated Rollback Script

The project includes a Bash deployment and rollback script:

```text
scripts/deploy_with_rollback.sh
```

The script:

- Starts a specified Docker image.
- Verifies application health.
- Checks the expected application version.
- Detects failed verification.
- Stops the failed deployment container.
- Restores the stable fallback version.
- Verifies the restored application.

### Successful Deployment Test

```bash
bash scripts/deploy_with_rollback.sh \
  nexus-cicd-api:1.1.0 1.1.0
```

Expected output:

```text
Verification passed: 1.1.0
SUCCESS: Deployment verified
```

### Controlled Rollback Test

```bash
bash scripts/deploy_with_rollback.sh \
  nexus-cicd-api:1.1.0 9.9.9
```

The expected version is deliberately incorrect.

This simulates a failed deployment verification.

Expected output:

```text
FAILED: Deployment verification failed
Starting rollback to nexus-cicd-api:1.0.0
Verification passed: 1.0.0
ROLLBACK SUCCESSFUL: Version 1.0.0 restored
```

The script uses the following exit codes:

| Exit Code | Meaning |
|-----------|---------|
| 0 | Deployment verified successfully |
| 2 | Deployment failed, rollback succeeded |
| 1 | Rollback or recovery process failed |

The local script requires both the target and fallback Docker images to exist.

The demonstration replaces a named container and is not designed for zero-downtime production operation.

---

## 13. Automated Rollback Verification in GitHub Actions

Rollback testing has also been integrated into the GitHub Actions pipeline.

The fourth pipeline job is:

```text
Automated Rollback Test
```

### Workflow

The job:

1. Downloads the current application Docker artifact.
2. Verifies the archive checksum.
3. Loads the current application image.
4. Builds stable version 1.0.0 from a historical Git commit.
5. Runs successful deployment verification for version 1.1.0.
6. Simulates a version mismatch.
7. Executes the rollback script.
8. Verifies that version 1.0.0 is restored.
9. Checks the restored application's health.
10. Cleans up the test container.

### Stable Version Reference

The fallback version is obtained from the historical Git commit:

```text
4fe91999341ddf62440cb8ae6ea73e38ad2d9c7c
```

The test explicitly expects the rollback script to return exit code 2 after a successful recovery.

A successful rollback is then verified independently through API requests and Docker inspection.

### Important Distinction

This is an automated rollback test running in an isolated CI environment.

It does not automatically roll back a real production deployment.

---

## 14. Technical Design Decisions

### Why GitHub Actions?

GitHub Actions integrates automation directly with the repository and provides traceable workflow execution associated with Git commits.

It allows developers to automate testing, builds, delivery verification and recovery testing.

### Why Docker?

Docker packages application code and dependencies into reusable images.

This provides consistent execution environments and supports version-based recovery.

### Why Pytest?

Pytest enables automated verification of application behavior.

Unit tests and API tests together provide protection against regressions at different levels.

### Why Ruff?

Ruff provides fast static analysis and helps maintain consistent Python code quality.

### Why Quality Gates?

Quality gates prevent known application failures from progressing to downstream delivery stages.

This reduces the risk of delivering defective software.

### Why Commit-Based Image Tags?

A Git SHA identifies a specific source revision.

Using it as an image tag improves traceability between source code and build output.

### Why Reuse Docker Artifacts?

Reusing the validated Docker image avoids unnecessary rebuilds between pipeline jobs.

The deployment process uses the same image produced by the build stage.

### Why Automated Rollback Testing?

Rollback mechanisms should be tested before they are needed.

Automated rollback verification demonstrates that the system can detect a deployment verification failure and restore a previously working version.

---

## 15. Challenges and Lessons Learned

### Environment Configuration

The development environment required Python, Git, Docker Desktop and WSL 2 to work together correctly.

### Docker Build Context

Dockerfiles must be placed correctly relative to the build context.

An early build failed because the Dockerfile was not located in the expected project directory.

### Git Configuration

Git commit author settings were configured to correctly associate source changes with the GitHub account.

### CI/CD Debugging

GitHub Actions logs were used to investigate pipeline behavior and validate each new development stage.

### Quality Gate Validation

A controlled application regression demonstrated why successful automated testing must be required before deployment.

### Artifact Management

The pipeline was improved from rebuilding Docker images in separate jobs to reusing a single exported image.

### Rollback Verification

Manual rollback was extended into script-based recovery and automated CI verification.

These challenges provided practical experience with debugging, automation, version control and delivery reliability.

---

## 16. Current Limitations

The system is a functional educational CI/CD demonstration rather than a production-ready delivery platform.

Current limitations include:

- No permanent production deployment environment.
- No external Docker container registry.
- No production traffic switching.
- No zero-downtime deployment.
- Application version verification uses fixed expected values.
- Rollback uses a predefined fallback version.
- Local rollback requires available Docker images.
- No automated production rollback.
- No production monitoring or alerting.
- Docker archive checksums do not replace artifact signing.
- No complete software supply-chain security implementation.

These limitations represent opportunities for future development.

---

## 17. Future Improvements

Potential future development includes:

- Publishing Docker images to a container registry.
- Implementing dynamic version verification.
- Adding automated releases and semantic version tags.
- Introducing staging and production environments.
- Adding manual approvals for production deployment.
- Implementing blue-green or rolling deployment strategies.
- Adding monitoring and alerting.
- Implementing dependency and container vulnerability scanning.
- Introducing signed build artifacts and provenance verification.
- Improving rollback configuration and recovery reliability.

---

## 18. Verified Project Results

The following capabilities have been implemented and demonstrated:

| Component | Status |
|-----------|--------|
| Python REST API | Completed |
| Automated unit tests | Completed |
| API integration tests | Completed |
| Nine automated tests | Completed |
| Ruff quality checks | Completed |
| GitHub Actions CI | Completed |
| Docker image build | Completed |
| JUnit XML test artifact | Completed |
| Git SHA image tagging | Completed |
| Docker image artifact reuse | Completed |
| SHA-256 archive verification | Completed |
| Simulated Continuous Delivery | Completed |
| Application health verification | Completed |
| Application version verification | Completed |
| Quality gate regression demonstration | Completed |
| Manual Docker rollback | Completed |
| Local scripted rollback | Completed |
| Automated rollback verification in CI | Completed |

### GitHub Actions Evidence

Selected workflow runs:

| Pipeline | Demonstration | Result |
|----------|---------------|--------|
| #6 | Controlled regression | Expected failure |
| #7 | Regression corrected | Success |
| #8 | Version 1.1.0 release | Success |
| #11 | Docker image reuse | Success |
| #12 | Automated rollback verification | Success |

Pipeline #12 completed successfully with all four jobs configured.

### Key Outcome

The project demonstrates an automated delivery process that validates source code, builds container images, verifies application deployment and tests recovery from a simulated deployment failure.

---

## 19. Project Scope

This project was developed for educational and demonstration purposes.

It showcases practical understanding of:

- Continuous Integration
- Continuous Delivery
- Automated Testing
- Containerization
- Version Control
- Pipeline Dependencies
- Artifact Management
- Deployment Verification
- Regression Prevention
- Rollback Automation
- Recovery Validation
- Technical Documentation

The application itself is intentionally simple so that the primary focus remains on DevOps workflows, automation and software delivery reliability.

---

## Author

**GitHub:** [moqa99](https://github.com/moqa99)

**Education:** DevOps Engineer - Nackademin, Sweden

**Project:** NEXUS CI/CD

**Repository:** [devops25-ci-cd-2026](https://github.com/moqa99/devops25-ci-cd-2026/tree/demo/nexus-cicd)

**Current Application Version:** 1.1.0

**Primary Technologies:** Python, FastAPI, Docker, GitHub Actions, Pytest, Ruff and Bash
