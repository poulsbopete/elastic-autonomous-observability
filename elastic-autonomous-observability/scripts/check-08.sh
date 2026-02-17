#!/bin/bash
# Challenge 08: Reduce cardinality — collector config has drop/aggregate processor.
set -euo pipefail

CONFIG_FILE="${1:-}"
if [ -z "$CONFIG_FILE" ] || [ ! -f "$CONFIG_FILE" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  CONFIG_FILE="${SCRIPT_DIR}/../assets/otel-config.yaml"
fi
[ -f "$CONFIG_FILE" ] || CONFIG_FILE="/workshop/otel-config.yaml"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Challenge 08 failed: no otel-config.yaml found."
  exit 1
fi

# Look for attribute-dropping or cardinality-reducing config
if grep -qE 'drop|delete_key|aggregation|limit|truncate|resource.*attributes' "$CONFIG_FILE" 2>/dev/null; then
  echo "Challenge 08 passed: config contains drop/aggregate or attribute processing."
  exit 0
fi

# Or check for a processor that reduces dimensions
if grep -qE 'processors:|attributes:|resource:' "$CONFIG_FILE" 2>/dev/null; then
  echo "Challenge 08 passed: processor pipeline present for cardinality control."
  exit 0
fi

echo "Challenge 08 failed: no cardinality-reducing config found."
exit 1
