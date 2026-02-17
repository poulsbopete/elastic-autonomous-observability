---
slug: ai-assisted-investigation
type: challenge
title: AI-assisted investigation
teaser: Use the Elastic AI assistant to troubleshoot an issue from your data.
notes:
- type: text
  contents: |
    Use the AI assistant in Kibana to ask a troubleshooting question and validate its suggestion.
    Use the Elastic Serverless tab to open the assistant and run queries.
tabs:
- id: tab-shell-10
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-10
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

# AI-assisted investigation

## Learning objective

You will use the Elastic AI assistant (or built-in AI features) to ask a troubleshooting question about your observability data and interpret the answer.

## Background

You've investigated latency and failures by hand. Now you'll see how the AI assistant can speed that up: you give it context (e.g. a time range, service name, or an error) and it suggests queries, summaries, or next steps.

## Your task

1. **Open the AI assistant**: In Kibana, find the AI assistant or "Investigate" / "Observe" AI feature (often in the Observability or global header). Open it.
2. **Ask a troubleshooting question**: Using real data from your lab, ask something like:
   - "Why was the checkout service slow between [start] and [end]?"
   - "What errors occurred for service X in the last hour?"
   - "Summarize the failures in trace ID [id]."
   Use a time range and service/trace that you know have data (and ideally some errors or slowness).
3. **Use the response**: Note what the assistant suggested: e.g. a query to run, a link to a trace, or a summary. Run any suggested query or open the suggested link and confirm it matches what you see in the data.
4. **Record one finding**: In your own words, write one sentence: "The AI assistant suggested [X], and when I checked, [Y]." (e.g. "It suggested looking at dependency Z; I opened the trace and confirmed Z was timing out.")

## Expected outcome

- You have asked at least one troubleshooting question that references your data (time range, service, or trace).
- You have used the assistant's output (query, link, or summary) to verify something in Kibana (trace, log, or metric).

## Hints

- If the assistant doesn't have direct access to your project, it may still generate ES|QL or KQL that you can paste into Discover or Dev Tools. Run it and interpret the result.
- Be specific: "checkout service, last 30 minutes" is better than "recent errors."

## Validation

The check verifies that you have used the AI assistant in this session. Depending on lab capabilities, this may be confirmed by a note you submit (e.g. the one-sentence finding) or by a script that checks for recent AI-related activity or a saved object created from the assistant.

## Success

You've used the AI assistant to investigate an issue and validated its suggestion. You've completed the Serverless Observability with OpenTelemetry workshop.
