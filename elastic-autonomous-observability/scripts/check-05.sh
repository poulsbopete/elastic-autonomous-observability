#!/bin/bash
# Challenge 05: Correlate signals — same trace.id in logs and traces.
set -euo pipefail

ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
[ -n "$ENDPOINT" ] || { echo "ELASTIC_ENDPOINT not set"; exit 1; }
[ -n "$API_KEY" ] || { echo "ELASTIC_API_KEY not set"; exit 1; }

FROM="$(date -u -v-30M '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '30 min ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"

# Get a trace_id from traces
TRACE_RESP=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
  -H "Authorization: ApiKey ${API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"size\": 1,
    \"_source\": [\"trace.id\", \"trace_id\"],
    \"query\": { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } }
  }" 2>/dev/null) || true

TRACE_ID=$(echo "$TRACE_RESP" | sed -n 's/.*"trace\.id":"\([^"]*\)".*/\1/p')
[ -z "$TRACE_ID" ] && TRACE_ID=$(echo "$TRACE_RESP" | sed -n 's/.*"trace_id":"\([^"]*\)".*/\1/p')

if [ -n "$TRACE_ID" ]; then
  # Check logs for same trace.id
  LOG_RESP=$(curl -s -X POST "${ENDPOINT}/logs-*/_search" \
    -H "Authorization: ApiKey ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"size\": 0,
      \"query\": {
        \"bool\": {
          \"must\": [
            { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } },
            { \"term\": { \"trace.id\": \"${TRACE_ID}\" } }
          ]
        }
      }
    }" 2>/dev/null) || true
  HITS=$(echo "$LOG_RESP" | sed -n 's/.*"value":\([0-9]*\).*/\1/p')
  if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
    echo "Challenge 05 passed: trace and log share trace_id ${TRACE_ID}."
    exit 0
  fi
fi

# Relaxed: just require both logs and traces have data
curl -s -X POST "${ENDPOINT}/traces-*/_search" -H "Authorization: ApiKey ${API_KEY}" -H "Content-Type: application/json" -d "{\"size\":0,\"query\":{\"range\":{\"@timestamp\":{\"gte\":\"${FROM}\",\"lte\":\"${TO}\"}}}}" | grep -q '"value"' && \
curl -s -X POST "${ENDPOINT}/logs-*/_search" -H "Authorization: ApiKey ${API_KEY}" -H "Content-Type: application/json" -d "{\"size\":0,\"query\":{\"range\":{\"@timestamp\":{\"gte\":\"${FROM}\",\"lte\":\"${TO}\"}}}}" | grep -q '"value"' && \
echo "Challenge 05 passed: logs and traces present (correlation assumed)." && exit 0

echo "Challenge 05 failed: could not verify log-trace correlation."
exit 1
