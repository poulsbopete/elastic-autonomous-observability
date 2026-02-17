---
slug: find-failing-dependency
type: challenge
title: Find the failing dependency
teaser: Use traces and the service map to identify the root cause of checkout failures.
notes:
- type: text
  contents: |
    Filter for failed traces, inspect the span tree and service map, and confirm with logs. Use
    the Elastic Serverless tab to find the failing dependency.
tabs:
- id: tab-shell-07
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-07
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

# Find the failing dependency

## Learning objective

You will trace a failing or slow checkout to a specific downstream dependency (service or endpoint) and confirm the root cause using spans and logs.

## Background

Checkout is failing for some users. You've already seen that one service calls several dependencies. Now you need to see which dependency is failing or timing out and tie it to the errors you see.

## Your task

1. **Filter for errors**: In Traces (or APM), filter to show only failed or errored traces (e.g. `transaction.result: failure` or "Has errors"). Open one failed checkout trace.
2. **Inspect the span tree**: In that trace, find the span(s) that indicate an error (e.g. red or "error" flag, status code 5xx, or `error=true`). Note the name of the operation and the service (or dependency) it calls.
3. **Use the service map**: Open the service map. Identify the edge from the checkout service to the failing dependency. Optionally check error rate or latency on that edge if the UI shows it.
4. **Confirm with logs**: Using the trace ID of the failed trace, switch to Logs and find log entries for that request. Look for error messages or stack traces that mention the same dependency or failure reason.

## Expected outcome

- You can name the failing dependency (service or endpoint) that causes checkout failures.
- You have at least one piece of evidence: a failed span, a log line, or an error rate on the service map edge.

## Hints

- Span attributes like `http.status_code`, `error`, or `exception.message` often indicate failure. Resource attributes on the span tell you which service produced it.
- If the failure is a timeout, the span may still show the dependency name and a long duration.

## Validation

The check verifies that a trace with an error (or a span with error status) exists and that the dependency name or service identified in the trace matches the expected failing component.

## Success

You've found the root cause of the failing checkout. Next you'll reduce cost by lowering cardinality.
