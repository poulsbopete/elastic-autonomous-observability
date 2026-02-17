---
slug: explore-the-system
type: challenge
title: Explore the system
teaser: Get oriented with the lab environment and confirm data is flowing.
notes:
- type: text
  contents: |
    Get oriented with the lab and the Elastic Serverless Observability project. Use the Shell tab
    to run commands and the Elastic Serverless tab to open Kibana and see where logs, metrics, and traces land.
tabs:
- id: tab-shell-01
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-01
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

# Explore the system

## Learning objective

By the end of this challenge you will know what is running in the lab and where to look in Kibana for your telemetry.

## Background

You've been given a lab with a few microservices and an OpenTelemetry Collector already pointed at an Elastic Serverless Observability project. Before changing anything, you need to see what's there and where data lands.

## Your task

1. **List running containers** on the terminal (e.g. `docker ps` or the script your lab provides). Note the names of the app and collector containers.
2. **Open Kibana** (virtual browser tab). Use the left navigation to find:
   - **Logs** (or Discover with a logs index pattern)
   - **Metrics** (or Metrics Explorer / Inventory)
   - **Traces** (APM / Traces)
3. **Confirm recent data**: In each area, adjust the time range to "Last 15 minutes" and confirm you see recent documents or series.

## Expected outcome

- You can name at least two services or components that are running.
- In Kibana you see recent logs, metrics, or traces (at least one signal type) in the last 15 minutes.

## Hints

- If you don't see a "Traces" or "APM" entry, look under "Observability" or "Stack Management" for the project's app.
- Time range is usually in the top-right of Kibana.

## Validation

The check verifies that (1) expected containers are running and (2) the Elastic endpoint and API key are set so Kibana can show data.

## Success

You've explored the system and confirmed where logs, metrics, and traces appear in Kibana. Next you'll send each signal type yourself.
