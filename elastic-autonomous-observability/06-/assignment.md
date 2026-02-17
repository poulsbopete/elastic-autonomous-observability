---
slug: investigate-latency
type: challenge
title: Investigate a latency issue
teaser: Use RED metrics and latency percentiles to find slow operations.
notes:
- type: text
  contents: |
    Use the service map and RED metrics in Kibana to find where checkout is slow. Use latency
    percentiles and open a slow trace. Shell and Elastic Serverless tabs.
tabs:
- id: tab-shell-06
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-06
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

# Investigate a latency issue

## Learning objective

You will use RED metrics (Rate, Errors, Duration) and latency percentiles to identify which operation or service is slow and interpret the service map.

## Background

Users report that "checkout" sometimes feels slow. You have traces and metrics in Elastic. Your job is to find where time is spent and what "slow" means in numbers.

## Your task

1. **Find checkout in the service map**: Open the Service Map (or Dependencies / Map) in Kibana. Locate the service that handles checkout and the edges (dependencies) to other services. Note which downstream services it calls.
2. **Get RED-style metrics**: In Metrics or APM, find for the checkout service (or the checkout transaction):
   - **Rate**: requests per minute (or count).
   - **Errors**: error count or error rate.
   - **Duration**: average or p95/p99 latency. Note the values and time range.
3. **Use latency percentiles**: In the trace or metrics UI, break down latency by percentile (e.g. p50, p95, p99). Identify whether the slow tail (e.g. p99) is much higher than the median. Note the p95 or p99 value for the checkout operation.
4. **Open a slow trace**: Filter traces by duration (e.g. "longer than 2 seconds") and open one slow checkout trace. Look at the span timeline: which span or dependency is taking most of the time?

## Expected outcome

- You can point to the service (or span name) that contributes most to checkout latency.
- You have at least one numeric finding: e.g. "Checkout p95 is X ms" or "Downstream service Y accounts for Z% of the trace duration."

## Hints

- RED metrics might appear under APM → Services → [service] or in a custom dashboard. Duration is often "Latency" or "Response time."
- On the service map, edge thickness or color sometimes indicates traffic or error rate; use it to prioritize which dependency to inspect.

## Validation

The check verifies that you have queried or viewed latency (e.g. p95 or average duration) for the checkout-related service or transaction in the last 30 minutes.

## Success

You've used RED metrics and percentiles to locate the slow part of checkout. Next you'll find a failing dependency.
