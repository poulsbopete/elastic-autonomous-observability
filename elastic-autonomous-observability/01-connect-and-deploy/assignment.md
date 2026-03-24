---
slug: connect-and-deploy
id: ulfa6lp4prw0
type: challenge
title: Connect to Elastic Cloud & Deploy
teaser: Wire the demo platform to your Elastic Cloud project and launch 9 microservices
  sending live OpenTelemetry telemetry.
notes:
- type: text
  contents: |
    ## Elastic Autonomous Observability

    In this lab you'll connect a pre-built multi-cloud demo platform to your Elastic Cloud project. The platform simulates 9 microservices across AWS, GCP, and Azure, emitting real OpenTelemetry logs, metrics, and traces directly into Elastic.

    Once connected, you'll choose an industry scenario and deploy the full observability stack — AI agent, alert rules, workflows, dashboards — with a single click.

    **What you'll do in this challenge:**

    - Explore the pre-deployed Fanatics Live scenario in the Demo App
    - Open the Elastic Serverless tab — no login required
    - Verify live OpenTelemetry telemetry is flowing from all 9 microservices
    - Review the auto-provisioned AI agent, alert rules, and workflows
- type: text
  contents: |
    ## Elastic Serverless: Zero Ops Observability

    Elastic Serverless automatically scales compute and storage independently — you only pay for what you ingest and query, never for idle capacity.

    **Key serverless facts:**

    - **Three project types:** Elasticsearch, Observability, and Security — each optimized for its workload
    - **No cluster management:** no shard sizing, no JVM tuning, no node rolling restarts
    - **Instant provisioning:** a new Observability project is ready in under 60 seconds
    - **Built-in AI:** every serverless project includes an AI Assistant with access to your live data
- type: text
  contents: |
    ## OpenTelemetry: The Universal Standard

    Elastic is a **Platinum member of the CNCF OpenTelemetry project** and ships a certified OTel distribution for zero-code auto-instrumentation.

    **Why OTel matters:**

    - Vendor-neutral instrumentation — no lock-in, one SDK for logs, metrics, and traces
    - Elastic natively ingests OTLP over gRPC and HTTP without a Collector in the path
    - Resource attributes (service.name, host.name, cloud.provider) flow directly into service maps, infrastructure views, and dashboards
    - The Elastic OTLP endpoint auto-routes signals: `logs-*`, `metrics-*`, `traces-*`
- type: text
  contents: |
    ## ES|QL: The Query Language Built for Telemetry

    ES|QL (Elasticsearch Query Language) is a pipe-based language designed for fast, expressive analysis of logs, metrics, and traces at scale.

    **Powerful features:**

    - `FROM logs* | WHERE severity_text == "ERROR" | STATS count = COUNT(*) BY service.name` — count errors per service in one line
    - `TS metrics* | EVAL minute = DATE_TRUNC(1 minute, @timestamp) | STATS avg_cpu = AVG(system.cpu.utilization) BY host.name, minute` — time-series CPU by host
    - Native **change point detection** finds anomalies automatically in time-series data
    - Results stream back progressively — no waiting for full scans on large datasets
- type: text
  contents: |
    ## Elastic AI Assistant & Autonomous Workflows

    Elastic's AI Assistant is embedded directly in the Observability UI — not a separate product — and has native access to your live telemetry.

    **What makes it autonomous:**

    - **AI Agent (Agent Builder):** define tools backed by ES|QL queries and Kibana workflows; the agent picks the right tool for each investigation step
    - **Workflows:** visual, YAML-defined automation that can query Elasticsearch, call AI agents, send notifications, create cases, and resolve incidents — all triggered by alert rules
    - **Alert → Workflow → Remediation:** a fault detected in logs can trigger RCA, auto-remediation, and a Kibana case — with no human in the loop
    - **Significant Events:** Streams API detects statistically unusual log patterns and surfaces them automatically
- type: text
  contents: |
    ## Multi-Cloud Observability in One Place

    This lab simulates a production-like environment spanning three cloud providers simultaneously.

    **The demo architecture:**

    | Cloud | Services |
    |-------|----------|
    | AWS   | Ticketing, Bid Engine, Card Printing, Fraud Detection |
    | GCP   | Fan Engagement, Loyalty Rewards, Streaming CDN |
    | Azure | Navigation, Payment Processing |

    All 9 services emit **logs, metrics, and traces** via OTLP to a single Elastic Serverless Observability project — giving you a unified view across clouds without any Collector infrastructure.
tabs:
- id: wpzfu4koymhw
  title: Terminal
  type: terminal
  hostname: es3-api
- id: f0jcpawmyzuq
  title: Demo App
  type: service
  hostname: es3-api
  path: /
  port: 8090
- id: dz2mxkupn9oy
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

# Connect to Elastic Cloud & Deploy

Your Elastic Cloud Serverless Observability project was **automatically provisioned** when this lab started — open the **Elastic Serverless** tab directly. No login required.

The demo platform is already running on this VM and has been pre-configured with your project's credentials.

---

## Step 1 — Verify the Deployment is Running

Open the **Demo App** tab. You should see the Fanatics Live scenario already deployed and sending telemetry. If the deployment bar is still in progress, wait a moment for it to complete.

You can also confirm in the **Terminal** tab:

```bash
demo-deployments
```

---

## Step 2 — Explore the Demo App

The Demo App is your control panel for this lab. From here you can:

- **View the live dashboard** — real-time service health across all 9 microservices
- **Open the Chaos Controller** — inject and resolve fault channels
- **Monitor deployment status** — see all active Elastic resources

---

## Step 3 — Open Elastic Serverless

Click the **Elastic Serverless** tab. This opens your auto-provisioned Observability project, pre-logged in. Navigate to:

- **Discover → ES|QL** — query live logs from services like `auction-engine`, `card-printing-system`, `digital-marketplace`
- **Applications → Service inventory** — distributed traces from 7 services (4 network services are logs-only)
- **Observability → Infrastructure** — 3 simulated hosts (AWS, GCP, Azure)

> **Tip:** Set the time range to **Last 15 minutes** to see recent telemetry.

---

## What was auto-deployed

The track setup automatically provisioned the full observability stack in your Elastic project:

| Resource | Details |
|----------|---------|
| Alert rules | 20 ES\|QL rules — one per fault channel |
| AI agent | Investigation tools + system prompt |
| Workflows | Alert → investigate → remediate → notify |
| Dashboards | Executive dashboard + OTel dashboards |
| Data views | `logs.otel`, `logs.otel.*`, `metrics-*` |

✅ **You're ready for the next challenge when** you can see logs or services in the Elastic Serverless tab.
