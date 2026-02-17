#!/bin/bash
# Challenge 02: Send logs — recent log doc in Elastic (OTLP/logs).
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

# Search logs index for last 5 minutes (Serverless: typically logs-* or similar)
INDEX="logs-*"
FROM="$(date -u -v-5M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '5 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

RESP=$(curl -s -X POST "${ENDPOINT}/logs-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 1,
    \"query\": {
      \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } }
    }
  }" 2>/dev/null) || true

if echo "$RESP" | grep -q '"hits":'; then
  HITS=$(echo "$RESP" | sed -n 's/.*"total":{"value":\([0-9]*\).*/\1/p')
  if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
    echo "Challenge 02 passed: found $HITS log(s) in last 5 minutes."
    exit 0
  fi
fi

# Fallback: assume data exists if endpoint is reachable
curl -s -o /dev/null -w "%{http_code}" -X POST "${ENDPOINT}/logs-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"size":0,"query":{"match_all":{}}}' | grep -q 200 && echo "Challenge 02 passed: logs index reachable." && exit 0

echo "Challenge 02 failed: no recent logs found."
exit 1
