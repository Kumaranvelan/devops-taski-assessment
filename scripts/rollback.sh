#!/bin/bash
# ─────────────────────────────────────────
# Rollback Script
# Usage: ./rollback.sh <deployment-name>
# Example: ./rollback.sh taski-devops-app
# ─────────────────────────────────────────

set -e

# ── Variables ──
DEPLOYMENT=${1:-"taski-devops-app"}

echo "⚠️  Starting rollback for: $DEPLOYMENT"

# ── Check deployment exists ──
if ! kubectl get deployment $DEPLOYMENT > /dev/null 2>&1; then
    echo "❌ Deployment $DEPLOYMENT not found!"
    exit 1
fi

# ── Show current status ──
echo "📊 Current deployment status:"
kubectl rollout status deployment/$DEPLOYMENT

# ── Perform Rollback ──
echo "🔄 Rolling back to previous version..."
kubectl rollout undo deployment/$DEPLOYMENT

# ── Wait for rollback to complete ──
echo "⏳ Waiting for rollback to complete..."
kubectl rollout status deployment/$DEPLOYMENT --timeout=120s

# ── Verify pods are running ──
echo "📋 Pod status after rollback:"
kubectl get pods -l app=$DEPLOYMENT

echo "✅ Rollback completed successfully!"