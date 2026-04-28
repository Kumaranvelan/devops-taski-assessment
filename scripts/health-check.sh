#!/bin/bash
# ─────────────────────────────────────────
# Health Check Script
# Usage: ./health-check.sh <app-url>
# Example: ./health-check.sh http://localhost:3000
# ─────────────────────────────────────────

set -e  # Exit immediately if any command fails

# ── Variables ──
APP_URL=${1:-"http://localhost:3000"}
MAX_RETRIES=5
RETRY_INTERVAL=10
HEALTHY=false

echo "🔍 Starting health check for: $APP_URL"

# ── Retry Loop ──
for i in $(seq 1 $MAX_RETRIES); do
    echo "Attempt $i of $MAX_RETRIES..."

    # Hit /health endpoint
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL/health)

    if [ "$RESPONSE" == "200" ]; then
        echo "✅ Health check passed! Status: $RESPONSE"
        HEALTHY=true
        break
    else
        echo "❌ Health check failed! Status: $RESPONSE"
        echo "Retrying in $RETRY_INTERVAL seconds..."
        sleep $RETRY_INTERVAL
    fi
done

# ── Final Result ──
if [ "$HEALTHY" = false ]; then
    echo "🚨 App is NOT healthy after $MAX_RETRIES attempts!"
    exit 1  # Pipeline will fail if this exits with 1
fi