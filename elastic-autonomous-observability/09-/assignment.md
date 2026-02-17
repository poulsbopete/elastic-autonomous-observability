---
slug: create-slo-query
type: challenge
title: Create an SLO-style query
teaser: Write a query that expresses a simple SLO and use it to detect problems.
notes:
- type: text
  contents: |
    Build a success-rate or p95 latency SLO in Kibana (Discover, ES|QL, or APM). Use the Elastic
    Serverless tab to run your query and detect violations.
tabs:
- id: tab-shell-09
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-09
  title: Elastic Serverless
  type: service
  hostname: es3-api
  path: /app/dashboards#/list?_g=(filters:!(),refreshInterval:(pause:!f,value:30000),time:(from:now-30m,to:now))
  port: 8080
  custom_request_headers:
  - key: Content-Security-Policy
    value: 'script-src ''self'' https://kibana.estccdn.com; worker-src blob: ''self''; style-src ''unsafe-inline'' ''self'' https://kibana.estccdn.com; style-src-elem ''unsafe-inline'' ''self'' https://kibana.estccdn.com'
  custom_response_headers:
  - key: Content-Security-Policy
    value: 'script-src ''self'' https://kibana.estccdn.com; worker-src blob: ''self''; style-src ''unsafe-inline'' ''self'' https://kibana.estccdn.com; style-src-elem ''unsafe-inline'' ''self'' https://kibana.estccdn.com'
difficulty: intermediate
timelimit: 600
enhanced_loading: null
---

# Create an SLO-style query

## Learning objective

You will express a simple service-level objective (e.g. "99% of checkout requests succeed" or "p95 latency under 500 ms") as a query or aggregation in Kibana and use it to detect when the objective is violated.

## Background

The product team wants a simple way to know when checkout is "broken": e.g. success rate below 99% or p95 latency above 500 ms. You'll turn that into a concrete query so you can alert or dashboard it.

## Your task

1. **Choose an SLO**: Pick one of:
   - **Availability**: e.g. "At least 99% of checkout requests succeed (no 5xx or span error)."
   - **Latency**: e.g. "p95 latency for checkout is under 500 ms."
2. **Implement the query**: In Kibana:
   - For **availability**: Use Discover, ES|QL, or a visualization to compute (successful requests / total requests) over a time bucket (e.g. last 1 hour, 5-minute buckets). Filter to checkout service or transaction. Success might be `transaction.result: success` or `span.status_code != 5xx`.
   - For **latency**: Use APM, Metrics, or ES|QL to compute p95 of duration for checkout over the same window. Compare to 500 ms.
3. **Detect a problem**: Either use a time range when you know there were failures or slow requests, or temporarily lower the bar (e.g. "100% success") so the current data violates it. Show one result: e.g. "Success rate in this window was X%" or "p95 was Y ms (above 500 ms)."

## Expected outcome

- You have a runnable query or visualization that computes your chosen SLO (success rate or p95).
- You have used it to identify at least one time window or sample where the SLO is violated (or would be if the threshold were strict enough).

## Hints

- ES|QL: use `STATS count(...) BY bucket(...)` and then derive success rate from success count / total count. For p95, use `PERCENTILE(duration, 95)`.
- In APM, the "Latency" and "Throughput" / "Error rate" panels often give you the building blocks; you can replicate the logic in Discover or ES|QL for a custom SLO view.

## Validation

The check verifies that a saved query, saved search, or ES|QL query exists that computes either (1) success rate for checkout or (2) p95 latency for checkout, and that the query returns at least one result in the last 2 hours.

## Success

You've built an SLO-style query that can detect problems. Next you'll use the AI assistant to investigate.
