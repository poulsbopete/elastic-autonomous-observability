---
slug: send-traces
type: challenge
title: Send traces
teaser: Emit OTLP traces and view them in the Elastic trace experience.
notes:
- type: text
  contents: |
    Send distributed traces via the collector and open them in Kibana Traces/APM. Use the Shell tab
    to generate traces and the Elastic Serverless tab to view the trace UI.
tabs:
- id: tab-shell-04
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-04
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

# Send traces

## Learning objective

You will send distributed traces via the OpenTelemetry Collector and see spans in Elastic's trace UI.

## Background

Traces show how a request flows across services. The collector is set up to accept OTLP traces and export them to Elastic. You'll generate a trace (one or more spans) and find it in Kibana.

## Your task

1. **Check the traces pipeline** in the Collector config: OTLP receiver for traces and exporter to Elastic. Ensure the service name (or resource attributes) will let you identify your spans.
2. **Generate a trace**:
   - Call an HTTP endpoint that the demo app exposes (e.g. `curl http://app:8080/checkout` or similar), or
   - Run a lab script that creates a trace with a known operation name.
3. **Find the trace in Kibana**: Open Traces (or APM → Traces). Set time to "Last 15 minutes." Search or filter by service name, operation name, or trace ID. Open a trace and look at the span list and timeline.

## Expected outcome

- At least one trace (with one or more spans) that you generated appears in Kibana.
- You can open the trace and see span names, duration, and service names.

## Hints

- Trace IDs are often in response headers (e.g. `traceparent`) or in logs. You can search by trace ID in the Traces view.
- Resource attributes (e.g. `service.name`) are set by the SDK or collector and are used for filtering in Kibana.

## Validation

The check verifies that a trace (or span) exists in Elastic in the last 15 minutes with the expected service or operation name.

## Success

You've sent a trace and seen it in Kibana. Next you'll correlate logs and traces.
