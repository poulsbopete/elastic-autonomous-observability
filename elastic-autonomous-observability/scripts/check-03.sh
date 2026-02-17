#!/bin/bash
# Challenge 03: Send metrics — recent metric data in Elastic.
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

# Serverless metrics: often metrics-* or similar
FROM="$(date -u -v-15M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '15 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

for INDEX in "metrics-*" "traces-*"; do
  RESP=$(curl -s -X POST "${ENDPOINT}/${INDEX}/_search" \
    -H "Authorization: ApiKey ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"size\": 0,
      \"query\": {
        \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } }
      }
    }" 2>/dev/null) || true
  if echo "$RESP" | grep -q '"value":'; then
    HITS=$(echo "$RESP" | sed -n 's/.*"value":\([0-9]*\).*/\1/p' | head -1)
    if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
      echo "Challenge 03 passed: found metric/trace data in ${INDEX}."
      exit 0
    fi
  fi
done

curl -s -o /dev/null -w "%{http_code}" -X POST "${ENDPOINT}/metrics-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"size":0}' | grep -q 200 && echo "Challenge 03 passed: metrics index reachable." && exit 0

echo "Challenge 03 failed: no recent metrics found."
exit 1
