#!/bin/bash
# Track-level setup: ensure env, copy assets, start collector and demo apps.
# Environment is pre-provisioned with ELASTIC_ENDPOINT, ELASTIC_API_KEY.
set -euo pipefail

WORKSHOP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ASSETS="${WORKSHOP_ROOT}/assets"
mkdir -p /workshop
cp -r "${ASSETS}"/* /workshop/ 2>/dev/null || true

# Require Elastic credentials (provided by Instruqt secrets)
if [ -z "${ELASTIC_ENDPOINT:-}" ] || [ -z "${ELASTIC_API_KEY:-}" ]; then
  echo "ELASTIC_ENDPOINT and ELASTIC_API_KEY must be set."
  exit 1
fi

# If Docker and containers are used, start them (optional; lab may pre-run)
if command -v docker &>/dev/null && [ -f /workshop/otel-config.yaml ]; then
  export ELASTIC_ENDPOINT ELASTIC_API_KEY
  # Substitute env in config if needed
  sed -e "s|{{ELASTIC_ENDPOINT}}|${ELASTIC_ENDPOINT}|g" \
      -e "s|{{ELASTIC_API_KEY}}|${ELASTIC_API_KEY}|g" \
      /workshop/otel-config.yaml > /tmp/otel-config.yaml 2>/dev/null || cp /workshop/otel-config.yaml /tmp/otel-config.yaml
  # Start collector and apps if scripts exist
  [ -x /workshop/load-generator ] && /workshop/load-generator start 2>/dev/null || true
fi

echo "Setup complete. ELASTIC_ENDPOINT and ELASTIC_API_KEY are set."
