---
slug: explore-telemetry
id: txtall3df8hr
type: challenge
title: Explore Live OpenTelemetry Data
teaser: Navigate Elastic Serverless to see logs, distributed traces, and host metrics
  flowing from 9 simulated microservices across three cloud providers.
notes:
- type: text
  contents: |
    ## Real OpenTelemetry, Real Data

    Your demo platform is emitting **real OpenTelemetry telemetry** — not synthetic data, not replayed recordings. Every log record, trace span, and metric data point is generated fresh and shipped via OTLP directly to Elastic.

    **9 microservices** run across:
    - ☁️ **AWS us-east-1** — 3 services
    - ☁️ **GCP us-central1** — 3 services
    - ☁️ **Azure eastus** — 3 services

    Background generators also emit host metrics (3 virtual hosts), Kubernetes node metrics, Nginx access logs, MySQL query logs, and distributed traces — giving you a rich, realistic data set to explore.
- type: text
  contents: |
    ## Unified Observability: Logs, Metrics & Traces Together

    Elastic correlates all three telemetry signals in a single store — no switching between tools, no separate data silos.

    **How signals connect:**

    - A **trace span** in an APM service links to the **logs** emitted during that request (via `trace.id`)
    - A **log error spike** surfaces in the same timeline as **host CPU and memory metrics**
    - **Service maps** are built automatically from distributed trace spans — no manual topology config
    - **Infrastructure views** merge OTel host metrics with Kubernetes node/pod data into one inventory

    This unified model is why Elastic consistently tops analyst evaluations for observability breadth.
- type: text
  contents: |
    ## APM & Distributed Tracing

    Elastic APM captures every request hop across service boundaries, giving you end-to-end latency visibility.

    **Key APM capabilities you'll explore:**

    - **Service Inventory** — health, throughput, error rate, and latency for every instrumented service
    - **Service Map** — auto-generated topology showing call dependencies and error propagation
    - **Transaction traces** — full flame-graph breakdown of individual request spans
    - **Correlations** — statistically significant attributes that appear more in slow or failing transactions vs healthy ones

    In this lab, distributed traces flow from the Bid Engine through the Card Printing service and into Payment Processing — visible in a single trace waterfall.
- type: text
  contents: |
    ## Infrastructure Monitoring with OTel

    Elastic's Infrastructure UI works natively with OpenTelemetry host metrics — no Elastic Agent required.

    **What you'll see:**

    - **Hosts view** — CPU utilization, memory, disk I/O, and network throughput per host, auto-grouped by cloud provider
    - **Kubernetes view** — node and pod metrics from the OTel Collector's kubeletstats receiver
    - **Metric Explorer** — ad-hoc charting of any `metrics-*` field using Lens or ES|QL

    The OTel host metrics receiver emits the exact scope names (`hostmetricsreceiver/internal/scraper/*`) that Elastic's Infrastructure UI expects — so dashboards populate automatically without any manual data-view configuration.
- type: text
  contents: |
    ## ES|QL: Time-Series Analysis at Scale

    The `TS` (Time Series) command in ES|QL unlocks high-performance queries over TSDB-optimized metric data streams.

    **Examples you'll run in this challenge:**

    ```
    TS metrics*
    | EVAL minute = DATE_TRUNC(1 minute, @timestamp)
    | STATS avg_latency = AVG(http.server.request.duration) BY service.name, minute
    | SORT minute DESC
    ```

    ```
    TS metrics*
    | EVAL minute = DATE_TRUNC(1 minute, @timestamp)
    | STATS
        errors = COUNT(*) WHERE severity_text == "ERROR",
        total  = COUNT(*)
      BY service.name, minute
    ```

    ES|QL queries run directly in **Discover → ES|QL** — no dashboard required.
tabs:
- id: lxtizjrsysoh
  title: Demo App
  type: service
  hostname: es3-api
  path: /
  port: 8090
- id: f0kedcdtykyx
  title: Elastic Serverless
  type: service
  hostname: es3-api
  path: /app/dashboards#/list?_g=(filters:!(),refreshInterval:(pause:!f,value:30000),time:(from:now-30m,to:now))
  port: 8080
  custom_request_headers:
  - key: Content-Security-Policy
    value: 'script-src ''self'' https://kibana.estccdn.com; worker-src blob: ''self'';
      style-src ''unsafe-inline'' ''self'' https://kibana.estccdn.com; style-src-elem
      ''unsafe-inline'' ''self'' https://kibana.estccdn.com'
  custom_response_headers:
  - key: Content-Security-Policy
    value: 'script-src ''self'' https://kibana.estccdn.com; worker-src blob: ''self'';
      style-src ''unsafe-inline'' ''self'' https://kibana.estccdn.com; style-src-elem
      ''unsafe-inline'' ''self'' https://kibana.estccdn.com'
difficulty: basic
enhanced_loading: null
---

# Explore Live OpenTelemetry Telemetry

Now that your scenario is running, let's explore the data flowing into Elastic. Open the **Elastic Serverless** tab.

---

## What's Generating Telemetry

The platform runs several background generators simultaneously:

| Generator | What It Produces |
|-----------|-----------------|
| **9 scenario services** | Application logs, traces, errors |
| **Host metrics** | CPU, memory, disk, network for 3 cloud hosts |
| **Kubernetes metrics** | Node, pod, container metrics |
| **Nginx metrics + logs** | Access logs, error logs, request spans |
| **MySQL logs** | Slow query + error logs |
| **VPC flow logs** | Network flow telemetry |
| **Distributed traces** | Multi-service request chains |

---

## Explore #1 — Logs via ES|QL

1. In the **Elastic Serverless** tab → **Discover**
2. Switch to **ES|QL** mode (top-left toggle)
3. Run this query:

```esql
FROM logs*
| WHERE @timestamp > NOW() - 5 MINUTES
| KEEP service.name, body.text, severity_text, @timestamp
| SORT @timestamp DESC
| LIMIT 50
```

You should see a stream of logs from multiple services. Once you confirm data is flowing, try filtering to errors only:

```esql
FROM logs*
| WHERE @timestamp > NOW() - 15 MINUTES
| WHERE severity_text == "ERROR"
| STATS error_count = COUNT(*) BY service.name
| SORT error_count DESC
```

**Things to notice:**
- `service.name`: `auction-engine`, `card-printing-system`, `digital-marketplace`, `packaging-fulfillment`, `cloud-inventory-scanner`, `nginx-proxy`, `mysql-primary`, and more
- `severity_text`: `INFO`, `WARN`, `ERROR`
- `body.text` contains the raw log message and error type

---

## Explore #2 — APM / Services

1. In the **Elastic Serverless** tab → **Applications → Service inventory**
2. You should see **7 services** — the 5 application services plus `nginx-proxy` and `mysql-primary`
   > The remaining 2 network/infrastructure services (`wifi-controller`, `network-controller`, `firewall-gateway`, `dns-dhcp-service`) emit logs only — no traces — so they won't appear here
3. Click any service to see latency, throughput, and error rate
4. Open a transaction to see the **distributed trace waterfall**

---

## Explore #3 — Infrastructure / Hosts

1. In the **Elastic Serverless** tab → **Observability → Infrastructure**
2. You should see 3 hosts — one per cloud provider:
   - `fanatics-aws-host-01`
   - `fanatics-gcp-host-01`
   - `fanatics-azure-host-01`
3. Click a host to see CPU, memory, disk, and network metrics

> **Note:** If hosts don't appear immediately, wait 1–2 minutes for the host metrics generator to send its first batch.

---

## Explore #4 — Dashboards

The deployer created an **Executive Dashboard** pre-configured for your scenario. Find it in:

**Elastic Serverless** tab → **Dashboards** → search "Fanatics" (or "Executive")

---

## Explore #5 — ES|QL Time Series Queries

In the **Elastic Serverless** tab → **Discover** → **ES|QL** mode, try these queries against the live metrics stream.

### Auction health at a glance
```esql
TS metrics*
| WHERE @timestamp > NOW() - 15 MINUTES
| EVAL minute = DATE_TRUNC(1 minute, @timestamp)
| STATS
    active_auctions = AVG(auction.active_auctions),
    bid_latency_ms  = AVG(auction.bid_latency_ms),
    bids_per_min    = AVG(auction.bids_per_min),
    websocket_conns = AVG(auction.websocket_connections)
  BY minute
| SORT minute DESC
```

### Spot a latency spike before users notice
```esql
TS metrics*
| WHERE @timestamp > NOW() - 30 MINUTES
| EVAL minute = DATE_TRUNC(1 minute, @timestamp)
| STATS avg_latency = AVG(auction.bid_latency_ms) BY minute
| EVAL status = CASE(
    avg_latency > 45, "🔴 CRITICAL",
    avg_latency > 30, "🟡 DEGRADED",
    "🟢 HEALTHY"
  )
| SORT minute DESC
```

### Card printing throughput vs queue depth
```esql
TS metrics*
| WHERE @timestamp > NOW() - 20 MINUTES
| EVAL minute = DATE_TRUNC(1 minute, @timestamp)
| STATS
    queue_depth    = AVG(card_printing.queue_depth),
    throughput     = AVG(card_printing.throughput),
    substrate_temp = AVG(card_printing.substrate_temp)
  BY minute
| EVAL backlog_ratio = ROUND(queue_depth / throughput, 2)
| SORT minute DESC
```

### Multi-cloud compliance drift
```esql
TS metrics*
| WHERE @timestamp > NOW() - 30 MINUTES
| EVAL bucket5m = DATE_TRUNC(5 minutes, @timestamp)
| STATS
    aws_compliance   = AVG(cloud_inventory.aws.compliance_pct),
    gcp_compliance   = AVG(cloud_inventory.gcp.compliance_pct),
    azure_compliance = AVG(cloud_inventory.azure.compliance_pct)
  BY bucket5m
| EVAL lowest = LEAST(aws_compliance, gcp_compliance, azure_compliance)
| EVAL at_risk_cloud = CASE(
    lowest == aws_compliance, "AWS",
    lowest == gcp_compliance, "GCP",
    "Azure"
  )
| SORT bucket5m DESC
```

### Log volume by service and severity over time
```esql
FROM logs*
| WHERE @timestamp > NOW() - 30 MINUTES
| EVAL minute = DATE_TRUNC(1 minute, @timestamp)
| STATS
    errors = COUNT(*) WHERE severity_text == "ERROR",
    warnings = COUNT(*) WHERE severity_text == "WARN",
    total  = COUNT(*)
  BY minute, service.name
| SORT minute DESC, total DESC
```

> **Tip:** After triggering a chaos fault in the next challenge, re-run this query to watch the error count spike for the affected service in real time — while healthy services stay flat.

✅ **Ready to continue when** you've seen logs, traces, or metrics in Elastic Serverless and confirmed services are healthy.
