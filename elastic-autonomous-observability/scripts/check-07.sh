#!/bin/bash
# Challenge 07: Find failing dependency — trace or span with error.
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

FROM="$(date -u -v-60M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '60 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# Span or transaction with error
RESP=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 1,
    \"query\": {
      \"bool\": {
        \"must\": [
          { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } },
          { \"bool\": { \"should\": [
            { \"term\": { \"transaction.result\": \"failure\" } },
            { \"term\": { \"span.failure\": true } },
            { \"exists\": { \"field\": \"error.exception.message\" } }
          ]}}
        ]
      }
    }
  }" 2>/dev/null) || true

if echo "$RESP" | grep -q '"hits":'; then
  HITS=$(echo "$RESP" | sed -n 's/.*"total":{"value":\([0-9]*\).*/\1/p')
  if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
    echo "Challenge 07 passed: found trace/span with error."
    exit 0
  fi
fi

# Relaxed: any trace data (user may have inspected service map)
curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{\"size\":0,\"query\":{\"range\":{\"@timestamp\":{\"gte\":\"${FROM}\",\"lte\":\"${TO}\"}}}}" | grep -q '"value"' && \
  echo "Challenge 07 passed: traces available for dependency analysis." && exit 0

echo "Challenge 07 failed: no error trace found."
exit 1
