---
slug: inject-fault
id: qzk6l9lifubk
type: challenge
title: Inject a Fault and Watch Elastic Detect It
teaser: Use the incident simulator to inject a realistic multi-cloud fault and watch
  Elastic's ES|QL alert rules and AI agent fire within seconds.
notes:
- type: text
  contents: |
    ## Break Things on Purpose

    The most powerful way to demonstrate observability is to break something — deliberately, in a controlled way — and watch the platform catch it.

    The demo platform has **20 independent fault channels**, each simulating a realistic incident: upstream pressure anomalies, network packet loss, sensor calibration drift, relay corruption, and more.

    When you trigger a fault:
    1. The affected microservices start emitting error-level OTLP logs with the fault's error type
    2. Cascade effects propagate warnings to dependent services
    3. Elastic's ES|QL alert rules detect the error spike within 30 seconds
    4. The AI agent starts investigating — looking up related events, querying logs, correlating traces
    5. The automated remediation workflow fires
- type: text
  contents: |
    ## Elastic Alerting: ES|QL-Powered Detection

    Every alert rule in this lab is backed by an **ES|QL query** that runs on a 30-second schedule — detecting error spikes the moment they appear in the data stream.

    **How alert rules work in Elastic Serverless:**

    - Rules run as managed scheduled tasks — no infrastructure to maintain
    - The `.es-query` rule type executes ES|QL or KQL against any index pattern
    - Thresholds are fully configurable: count, percentage, rate of change
    - Each rule can trigger multiple **actions**: workflows, webhooks, email, Slack, PagerDuty, Jira
    - Alert state is tracked per-group, so you get one alert per fault channel — not thousands of duplicates

    In this lab, 20 alert rules monitor 20 fault channels simultaneously.
- type: text
  contents: |
    ## Streams: Significant Event Detection

    Elastic **Streams** (Technical Preview) is a zero-config log routing and analysis layer built on top of data streams.

    **Significant Events on the `logs` stream:**

    - You define KQL queries that describe meaningful patterns (e.g., `body.text: "FuelPressureException" AND severity_text: "ERROR"`)
    - Elastic monitors ingested log volume against those queries in near-real-time
    - When a pattern's rate deviates significantly from baseline, it surfaces as a **Significant Event**
    - Significant Events appear in the Observability UI and can trigger workflows

    This is how Elastic detects *unknown unknowns* — anomalous log patterns you didn't pre-define an alert for.
- type: text
  contents: |
    ## How Faults Propagate Through Microservices

    The Fanatics Live scenario simulates realistic fault cascade behavior — not just a single service throwing errors.

    **Cascade pattern:**

    1. A fault channel activates on a primary service (e.g., `fuel-system`)
    2. That service begins emitting `ERROR` severity OTLP logs with a specific exception type
    3. Downstream services that depend on it emit `WARN` logs indicating degraded upstream responses
    4. End-to-end trace spans show elevated latency or errors at the integration boundaries
    5. Host metrics on the affected cloud provider may show elevated CPU from retry storms

    This cascade is what makes observability *hard* in practice — and what makes Elastic's correlated view across logs, metrics, and traces so valuable for incident response.
tabs:
- id: evu3zosviiyy
  title: Terminal
  type: terminal
  hostname: es3-api
- id: u5cmidsfkwal
  title: Demo App
  type: service
  hostname: es3-api
  path: /
  port: 8090
- id: jhbi4afnff98
  title: Elastic Serverless
  type: service
  hostname: es3-api
  path: /app/discover#/?_a=(columns:!(service.name,severity_text,body.text),index:logs.otel,interval:auto,query:(esql:'FROM+logs.otel%2Clogs.otel.*+%7C+WHERE+%40timestamp+>+NOW()+-+30+minutes+%7C+WHERE+severity_text+%3D%3D+%22ERROR%22+%7C+KEEP+service.name%2C+body.text%2C+severity_text%2C+%40timestamp+%7C+SORT+%40timestamp+DESC+%7C+LIMIT+50',language:esql),sort:!(!('@timestamp',desc)))&_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:now-30m,to:now))
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

# Inject a Fault and Watch Elastic Detect It

Now it's time to break something. The incident simulator lets you inject realistic faults into the simulated environment — then watch Elastic light up.

---

## Trigger a Fault

1. Open the **Demo App** tab
2. Find your running **Fanatics Collectibles** deployment and click the **Chaos** link next to it
3. You'll see 20 fault channels organized by subsystem and cloud provider
4. Select a channel from the dropdown and click **Inject Fault**

---

## What to Watch in Elastic Serverless

Once you trigger a fault, switch to the **Elastic Serverless** tab and watch:

### 1. Logs — Error Spike

The tab opens directly to the error log stream. Or navigate there manually:

**Discover → ES|QL** and run:

```esql
FROM logs*
| WHERE @timestamp > NOW() - 10 MINUTES
| WHERE severity_text == "ERROR"
| STATS error_count = COUNT(*) BY service.name
| SORT error_count DESC
```

You should see an error spike from the affected service within seconds.

### 2. Alert Rules — Detection
**Observability → Alerts**

The ES|QL alert rules will fire within 30–60 seconds of the error spike. You'll see an active alert appear.

### 3. AI Agent Investigation
**Observability → AI Assistant** (or the Workflows execution log)

The alert triggers a workflow that calls the AI agent. The agent:
- Identifies the error type from the alert tags
- Queries recent error logs for context
- Searches for related events
- Produces a root-cause analysis summary

---

## Verify the Fault is Active

In the Terminal tab:

```bash
demo-chaos
```

You should see the triggered channel with `"state": "ACTIVE"`.

---

## Fault Channel Reference (Fanatics Scenario)

| Ch | Name | Subsystem | Cloud |
|----|------|-----------|-------|
| 1 | MAC Address Flapping | network_core | Azure |
| 2 | Spanning Tree Topology Change | network_core | Azure |
| 3 | BGP Peer Flapping | network_core | Azure |
| 4 | Firewall Session Table Exhaustion | security | Azure |
| 5 | Firewall CPU Overload | security | Azure |
| 6 | SSL Decryption Certificate Expiry | security | Azure |
| 7 | WiFi AP Disconnect Storm | network_access | GCP |
| 8 | WiFi Channel Interference | network_access | GCP |
| 9 | Client Authentication Storm | network_access | GCP |
| 10 | DNS Resolution Failure Over VPN | network_services | Azure |
| 11 | DHCP Lease Storm | network_services | Azure |
| 12 | Auction Bid Latency Spike | commerce | AWS |
| 13 | Payment Processing Timeout | commerce | AWS |
| 14 | Product Catalog Sync Failure | commerce | AWS |
| 15 | Print Queue Overflow | manufacturing | AWS |
| 16 | Quality Control Rejection Spike | manufacturing | AWS |
| 17 | Fulfillment Label Printer Failure | logistics | GCP |
| 18 | Warehouse Scanner Desync | logistics | GCP |
| 19 | Orphaned Cloud Resource Alert | cloud_ops | GCP |
| 20 | Cross-Cloud VPN Tunnel Flapping | cloud_ops | GCP |

✅ **Ready to continue when** at least one fault channel is active (verified by `demo-chaos` showing `"active": true`).
