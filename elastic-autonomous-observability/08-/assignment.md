---
slug: reduce-cardinality
type: challenge
title: Reduce cardinality
teaser: Lower cost by aggregating metrics and filtering noisy attributes.
notes:
- type: text
  contents: |
    Reduce metric and log cardinality in the collector or in Elastic. Use the Shell tab to edit
    config and the Elastic Serverless tab to inspect data.
tabs:
- id: tab-shell-08
  title: Shell
  type: terminal
  hostname: host01
- id: tab-elastic-08
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

# Reduce cardinality

## Learning objective

You will reduce metric cardinality (and thus cost) by using aggregation in the collector or in Elastic, and by filtering out high-cardinality or noisy attributes you don't need.

## Background

Your Serverless project is growing: more unique combinations of dimensions (e.g. URL path, user ID, request ID) mean more time series and higher cost. You'll keep the signals you need while dropping or aggregating the rest.

## Your task

1. **Identify high cardinality**: In Kibana, use Metrics or a data stream listing to see which metrics (or which attributes) have many unique values. Alternatively, run a lab script that reports cardinality (e.g. distinct count of `url.path` or `user.id`). Pick one metric and one attribute that you're willing to drop or aggregate.
2. **Apply aggregation**: For a chosen metric (e.g. request duration), create or use an aggregated view:
   - Either in the Collector: add a processor that aggregates (e.g. drop dimensions, or use a summary metric instead of per-request metrics), or
   - In Elastic: use a transform, aggregation in a dashboard, or a reduced data stream that stores only pre-aggregated series (e.g. by `service.name` only, not by `url.path`).
   - Document or implement one concrete change (e.g. "drop `request_id` from metric attributes" or "aggregate to service-level only").
3. **Filter noisy attributes**: In the Collector config (or in an Elastic ingest pipeline), add a filter that removes one high-cardinality or noisy attribute from logs or metrics (e.g. remove `trace_id` from logs if you don't need it in every log line, or drop a debug attribute). Restart or reload the collector and confirm that new data no longer includes that attribute (or that cardinality decreased).

## Expected outcome

- You have made at least one change that reduces cardinality: either an aggregation (e.g. service-level metric) or a filter that drops an attribute.
- You can explain in one sentence how that change reduces cost (fewer unique time series or smaller documents).

## Hints

- OTLP Collector processors: `attributes`, `resource`, or metric-specific processors can delete or truncate attributes. Check the Otelcol docs for "drop" or "limit."
- In Serverless, storage and indexing cost scale with cardinality; reducing unique dimension combinations directly reduces cost.

## Validation

The check verifies that the collector config (or a provided config file) contains a processor or rule that drops or aggregates at least one attribute or dimension, or that a metric/log sample no longer contains a previously high-cardinality field.

## Success

You've reduced cardinality and set up for lower cost. Next you'll define an SLO-style query.
