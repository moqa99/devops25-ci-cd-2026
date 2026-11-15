
#!/usr/bin/env bash
set -euo pipefail

TARGET_IMAGE="${1:-nexus-cicd-api:1.1.0}"
EXPECTED_VERSION="${2:-1.1.0}"

FALLBACK_IMAGE="nexus-cicd-api:1.0.0"
CONTAINER_NAME="nexus-cicd-rollback-demo"
BASE_URL="http://127.0.0.1:8001"

echo "=== NEXUS Automated Deployment & Rollback ==="

# Check that both images exist locally
docker image inspect "$TARGET_IMAGE" >/dev/null
docker image inspect "$FALLBACK_IMAGE" >/dev/null

# Start a specific Docker image
start_container() {
    local image="$1"

    docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true

    docker run -d --rm \
        --name "$CONTAINER_NAME" \
        -p 127.0.0.1:8001:8000 \
        "$image" >/dev/null
}

# Verify a JSON field returned by an API endpoint
check_endpoint() {
    local endpoint="$1"
    local field="$2"
    local expected="$3"

    curl -fsS --max-time 2 "$BASE_URL/$endpoint" 2>/dev/null |
        python -c '
import json
import sys

data = json.load(sys.stdin)
actual = data.get(sys.argv[1])
sys.exit(0 if actual == sys.argv[2] else 1)
' "$field" "$expected" >/dev/null 2>&1
}

# Check health and the running version
verify_deployment() {
    local expected="$1"

    for attempt in {1..12}; do
        if check_endpoint health status ok &&
           check_endpoint version version "$expected"; then
            echo "Verification passed: $expected"
            return 0
        fi

        sleep 1
    done

    return 1
}

echo "Deploying: $TARGET_IMAGE"

if start_container "$TARGET_IMAGE" &&
   verify_deployment "$EXPECTED_VERSION"; then

    echo "SUCCESS: Deployment verified"
    exit 0
fi

echo "FAILED: Deployment verification failed"
echo "Starting rollback to $FALLBACK_IMAGE"

docker logs "$CONTAINER_NAME" 2>&1 || true

if start_container "$FALLBACK_IMAGE" &&
   verify_deployment "1.0.0"; then

    echo "ROLLBACK SUCCESSFUL: Version 1.0.0 restored"
    exit 2
fi

echo "CRITICAL: Rollback verification failed"
exit 1
