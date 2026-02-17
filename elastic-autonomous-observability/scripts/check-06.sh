#!/bin/bash
# Challenge 06: Investigate latency — latency (duration) data for checkout/service.
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

FROM="$(date -u -v-30M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '30 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# Check for duration/latency in traces (transaction.duration.us or span duration)
RESP=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 0,
    \"query\": {
      \"bool\": {
        \"must\": [
          { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } },
          { \"exists\": { \"field\": \"transaction.duration.us\" } }
        ]
      }
    }
  }" 2>/dev/null) || true

HITS=$(echo "$RESP" | sed -n 's/.*"value":\([0-9]*\).*/\1/p')
if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
  echo "Challenge 06 passed: latency (transaction duration) data found."
  exit 0
fi

# Alternative: any duration field
RESP2=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 1,
    \"query\": { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } }
  }" 2>/dev/null) || true
echo "$RESP2" | grep -qE '"duration"|"latency"|transaction\.duration' && \
  echo "Challenge 06 passed: trace duration data present." && exit 0

echo "Challenge 06 failed: no latency/duration data found."
exit 1
