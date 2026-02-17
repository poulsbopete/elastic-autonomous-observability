---
slug: correlate-signals
type: challenge
title: Correlate signals
teaser: Link logs and traces using trace ID and understand resource vs span attributes.
notes:
- type: text
  contents: |
    Use trace ID to jump from a trace to its related logs in Kibana. Distinguish resource attributes
    from span attributes. Use both Shell and Elastic Serverless tabs.
tabs:
- id: tab-shell-05
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-05
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
difficulty: basic
timelimit: 600
enhanced_loading: null
---

# Correlate signals

## Learning objective

You will use a shared identifier (trace ID) to move between a trace and its related logs, and you'll distinguish resource attributes from span attributes.

## Background

When a request fails or is slow, you want to jump from a trace to the logs for that same request. OpenTelemetry puts `trace_id` (and often `span_id`) in log records when the logging SDK is trace-aware. Elastic can use that to link traces and logs.

## Your task

1. **Capture a trace ID**: In Kibana Traces, pick a recent trace and copy its trace ID (from the trace detail or the URL).
2. **Find related logs**: In Logs (or Discover on logs), add a filter or query for `trace.id` (or your project's field for trace ID) equals that trace ID. Confirm you see log lines that belong to that request.
3. **Understand attributes**: In the same trace, open a span. In the span detail, note:
   - **Resource attributes** (e.g. `service.name`, `service.version`, `host.name`). These describe the resource (process/service) and are usually the same for all spans from that process.
   - **Span attributes** (e.g. `http.method`, `http.url`, `error`). These describe the specific operation.
   - Check whether your logs also carry resource-like fields (e.g. `service.name`) and whether they include `trace.id`.

## Expected outcome

- You have used a trace ID to find at least one related log entry.
- You can explain in one sentence the difference between resource attributes (who) and span attributes (what for this span).

## Hints

- Field names may be `trace.id` and `span.id` in Elastic, or `trace_id` / `span_id` depending on the integration.
- If no logs have trace IDs, the app may need to be configured to inject trace context into the logging SDK (e.g. log record attributes).

## Validation

The check verifies that (1) a trace exists with the expected service/operation and (2) a log document with the same `trace.id` exists in the same time window.

## Success

You've correlated a trace and its logs. Next you'll use this to investigate a latency issue.
