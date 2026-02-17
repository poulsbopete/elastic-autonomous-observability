---
slug: send-logs
type: challenge
title: Send logs
teaser: Emit application logs and ship them to Elastic via the OpenTelemetry Collector.
notes:
- type: text
  contents: |
    Send logs through the OTLP collector and see them in Elastic. Use the Shell tab to run commands
    and the Elastic Serverless tab to find your logs in Kibana.
tabs:
- id: tab-shell-02
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-02
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

# Send logs

## Learning objective

You will send application logs through the OpenTelemetry Collector (OTLP) and see them in Elastic.

## Background

The team wants all app logs in one place. The collector is already configured to accept OTLP and forward to Elastic. Your job is to produce a log line from a service and confirm it shows up in Kibana.

## Your task

1. **Locate the Collector config** (e.g. in the lab `assets` or `/etc/otelcol/config.yaml`). Find the OTLP receiver and the exporter that sends to Elastic (e.g. `otlphttp` or `elasticsearch`). You don't need to change it yet—just confirm the pipeline exists.
2. **Generate a log** from one of the demo apps:
   - Either run a one-off command that the lab provides (e.g. `./scripts/emit-log.sh`), or
   - Trigger an action in the app that writes a distinct log message (e.g. "Order submitted" or "Health check").
3. **Find your log in Kibana**: Open Logs (or Discover on the logs index). Set time to "Last 5 minutes." Search or filter for your message or service name. Open one document and note key fields (e.g. `message`, `service.name`, `@timestamp`).

## Expected outcome

- At least one log record that you generated appears in Kibana within the chosen time range.
- You can identify the log by message content or by `service.name` / resource attributes.

## Hints

- If the lab uses a file-based log shipper, ensure the app is writing to the path the collector tails.
- OTLP log pipelines often use a receiver on port 4317 (gRPC) or 4318 (HTTP). The lab may expose these on the collector container.

## Validation

The check verifies that a log document matching the expected service or message pattern exists in the Elastic project within the last 5 minutes.

## Success

You've sent a log through the collector and seen it in Kibana. Next you'll do the same for metrics.
