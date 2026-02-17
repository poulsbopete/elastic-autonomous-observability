#!/bin/bash
# Challenge 01: Explore the system — containers running and Elastic env set.
set -euo pipefail

# 1) Expected containers (adjust names to match config)
for name in otelcol demo-app; do
  if docker ps --format '{{.Names}}' 2>/dev/null | grep -q "$name"; then
    echo "Container $name is running."
  fi
done

# 2) Elastic endpoint and API key set
[ -n "${ELASTIC_ENDPOINT:-}" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "${ELASTIC_API_KEY:-}" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

echo "Challenge 01 passed: system explored, env ready."
