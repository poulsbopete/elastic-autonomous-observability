#!/bin/bash
# Challenge 09: SLO query — success rate or p95 query exists (saved object or marker file).
set -euo pipefail

# Option A: Check for a saved search/query (would require Kibana API and space id)
# Option B: Check that user created a marker file after running their SLO query in Kibana
MARKER="${HOME}/.slo-query-done"
if [ -f "$MARKER" ]; then
  echo "Challenge 09 passed: SLO query completed (marker found)."
  exit 0
fi

# Option C: Verify Elastic has data that supports SLO (transactions with result)
ENDPOINT="${ELASTIC_ENDPOINT:-}"
API_KEY="${ELASTIC_API_KEY:-}"
if [ -n "$ENDPOINT" ] && [ -n "$API_KEY" ]; then
  FROM="$(date -u -v-2H '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '2 hours ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)"
  TO="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  RESP=$(curl -s -X POST "${ENDPOINT}/traces-*/_search" \
    -H "Authorization: ApiKey ${API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{
      \"size\": 0,
      \"query\": { \"range\": { \"@timestamp\": { \"gte\": \"${FROM}\", \"lte\": \"${TO}\" } } }
    }" 2>/dev/null) || true
  HITS=$(echo "$RESP" | sed -n 's/.*"value":\([0-9]*\).*/\1/p')
  if [ -n "$HITS" ] && [ "${HITS:-0}" -gt 0 ]; then
    echo "Challenge 09 passed: trace data available for SLO (run your SLO query in Kibana and create: touch ${MARKER})."
    exit 0
  fi
fi

echo "Challenge 09: Create an SLO-style query in Kibana (success rate or p95), then run: touch ${MARKER}"
exit 1
