---
slug: send-metrics
type: challenge
title: Send metrics
teaser: Emit OTLP metrics and view them in Elastic Serverless.
notes:
- type: text
  contents: |
    Send metrics via the OpenTelemetry Collector and view them in Kibana Metrics or Discover.
    Use the Shell tab to emit metrics and the Elastic Serverless tab to explore.
tabs:
- id: tab-shell-03
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-03
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

# Send metrics

## Learning objective

You will send metrics via the OpenTelemetry Collector and understand how they appear in Elastic (e.g. as time series or in Metrics Explorer).

## Background

Metrics give you rates, counts, and distributions over time—different from event-by-event logs. The collector accepts OTLP metrics and forwards them. You'll emit a metric and then find it in Kibana.

## Your task

1. **Confirm the metrics pipeline** in the Collector config: an OTLP receiver for metrics and an exporter to Elastic. Note the port if you need to point an app at it.
2. **Emit a metric**:
   - Use a lab script (e.g. `./scripts/emit-metric.sh`) that sends a counter or gauge via OTLP, or
   - Trigger behavior in a demo app that reports a metric (e.g. requests handled, queue depth).
3. **Find the metric in Kibana**: Open Metrics (Metrics Explorer, Inventory, or Discover on a metrics index). Set time to "Last 15 minutes." Filter or search by metric name or by resource attributes (e.g. `service.name`). Optionally create a simple time series chart.

## Expected outcome

- At least one metric time series (or metric document) that you generated appears in Kibana.
- You can associate it with a metric name and at least one dimension (e.g. service or host).

## Hints

- OTLP metrics often land in data streams or indices matching `metrics-*`. Use the field list or index pattern to find names like `metric.name` or `system.cpu.utilization`.
- If you use a script, ensure it uses the same endpoint and API key as the collector (or sends to the collector's OTLP port).

## Validation

The check queries Elastic for a metric data point (or document) in the last 15 minutes that matches the expected metric name or resource attributes.

## Success

You've sent a metric through the collector and seen it in Kibana. Next you'll add traces.
