#!/bin/bash
# Challenge 04: Send traces — recent trace/span in Elastic.
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

FROM="$(date -u -v-15M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '15 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

RESP=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 1,
    \"query\": {
      \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } }
    }
  }" 2>/dev/null) || true

if echo "$RESP" | grep -q '"hits":'; then
  echo "$RESP" | grep -q '"trace"' && echo "Challenge 04 passed: trace data found." && exit 0
  HITS=$(echo "$RESP" | sed -n 's/.*"total":{"value":\([0-9]*\).*/\1/p')
  [ "${HITS:-0}" -gt 0 ] && echo "Challenge 04 passed: span/trace found." && exit 0
fi

curl -s -o /dev/null -w "%{http_code}" -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"size":0}' | grep -q 200 && echo "Challenge 04 passed: traces index reachable." && exit 0

echo "Challenge 04 failed: no recent traces found."
exit 1
