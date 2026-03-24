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
    ## Lab 3 — Inject a Fault and Watch Elastic Detect It

    **By the end of this challenge you will:**

    - ✅ Trigger a realistic fault using the Demo App Chaos controller
    - ✅ Watch the error spike appear in Elastic's log stream within seconds
    - ✅ See an ES|QL alert rule fire within 30–60 seconds
    - ✅ Observe the AI agent begin its investigation automatically

    **You have 20 fault channels to choose from** — each simulates a realistic incident across AWS, GCP, and Azure services. Pick any one and watch Elastic light up.
- type: text
  contents: |
    ## How Fault Detection Works

    Every fault channel is monitored by a dedicated **ES|QL alert rule** running on a 30-second schedule:

    ```
    FROM logs*
    | WHERE @timestamp > NOW() - 2 MINUTES
    | WHERE body.text : "MacAddressFlappingException"
    | STATS error_count = COUNT(*)
    | WHERE error_count > 5
    ```

    When errors exceed the threshold:
    1. The alert fires and appears in **Observability → Alerts**
    2. The alert triggers the **Significant Event Notification** workflow
    3. The workflow calls the **AI agent** with the error context
    4. The agent queries logs, correlates signals, and produces a root-cause analysis
- type: text
  contents: |
    ## Fault Cascade: Why Observability Is Hard

    A single fault channel doesn't just affect one service — it cascades:

    | Step | What happens |
    |------|-------------|
    | **1** | Primary service emits `ERROR` logs with a specific exception type |
    | **2** | Downstream services emit `WARN` — degraded upstream responses |
    | **3** | Trace spans show elevated latency at integration boundaries |
    | **4** | Host metrics spike on the affected cloud provider |

    This cascade across logs, metrics, and traces is what makes incidents hard to diagnose manually — and what makes Elastic's correlated view so powerful.
- type: text
  contents: |
    ## 20 Fault Channels — Pick One

    | Category | Cloud | Example Faults |
    |----------|-------|---------------|
    | **Network Core** | Azure | MAC flapping, BGP peer drop, spanning tree change |
    | **Security** | Azure | Firewall session exhaustion, SSL cert expiry |
    | **WiFi / Network Access** | GCP | AP disconnect storm, channel interference |
    | **Network Services** | Azure | DNS failure, DHCP lease storm |
    | **Commerce** | AWS | Bid latency spike, payment timeout, catalog sync failure |
    | **Manufacturing** | AWS | Print queue overflow, QC rejection spike |
    | **Logistics** | GCP | Label printer failure, warehouse scanner desync |
    | **Cloud Ops** | GCP | Orphaned resource alert, VPN tunnel flapping |

    Start with **Channel 12 — Auction Bid Latency Spike** for the clearest end-to-end demo.
tabs:
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

Back in the **Demo App** tab, the Chaos controller will show your active channel with a red **ACTIVE** badge. You can also confirm in the **Elastic Serverless** tab — the error log stream will show a spike from the affected service within seconds.

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

✅ **Ready to continue when** at least one fault channel shows **ACTIVE** in the Demo App Chaos controller.
