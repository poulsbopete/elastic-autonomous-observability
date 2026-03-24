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
    ## Lab 1 — Connect to Elastic Cloud & Deploy

    **What's happening right now:**
    Your Elastic Cloud Serverless Observability project is being provisioned and the Fanatics Live demo platform is being configured with your credentials.

    **By the end of this challenge you will:**

    - ✅ Confirm the Fanatics Live scenario is deployed and sending telemetry
    - ✅ Open your Elastic Serverless project — no login required
    - ✅ Verify logs, metrics, and traces are flowing from 9 microservices
    - ✅ Review the auto-provisioned AI agent, alert rules, and workflows

    *Setup takes 3–4 minutes. Grab a coffee — it'll be ready soon.*
- type: text
  contents: |
    ## Your Lab Environment

    **Two tabs, everything you need:**

    | Tab | What it is |
    |-----|-----------|
    | **Demo App** | Control panel — view service health, manage deployments, inject faults |
    | **Elastic Serverless** | Your Observability project — pre-logged in, data already flowing |

    **The Fanatics Live scenario simulates 9 microservices across 3 clouds:**

    - ☁️ **AWS** — Auction Engine, Card Printing, Payment Processing
    - ☁️ **GCP** — Fan Engagement, Loyalty Rewards, Streaming CDN
    - ☁️ **Azure** — Navigation, Fraud Detection, Fulfillment

    Every service emits **real OpenTelemetry** logs, metrics, and traces — no synthetic data.
- type: text
  contents: |
    ## What Was Auto-Deployed

    When the lab started, the setup script provisioned your full observability stack automatically:

    | Resource | Details |
    |----------|---------|
    | **Alert rules** | 20 ES\|QL rules — one per fault channel, 30s interval |
    | **AI agent** | Investigation tools + system prompt |
    | **Workflows** | Alert → investigate → create case → remediate |
    | **Dashboards** | Executive dashboard + OTel signal dashboards |
    | **Data views** | `logs.otel`, `metrics-*`, `traces-*` |

    This is the same stack you'd deploy in production — configured in code, repeatable, version-controlled.
- type: text
  contents: |
    ## Key Concepts: Elastic Serverless + OpenTelemetry

    **Elastic Serverless** scales compute and storage independently. No cluster management, no shard tuning — just ingest and query.

    **OpenTelemetry (OTel)** is the CNCF standard for vendor-neutral instrumentation. Elastic is a Platinum member and natively ingests OTLP — no Collector required.

    **ES|QL** is Elastic's pipe-based query language, purpose-built for telemetry at scale:

    ```
    FROM logs*
    | WHERE severity_text == "ERROR"
    | STATS errors = COUNT(*) BY service.name
    | SORT errors DESC
    ```

    **AI Workflows** connect alert detection to investigation to remediation — all without human intervention.
- type: text
  contents: |
    ## While You Wait — Play a Game! 🎮

    Setup takes a few minutes. Pass the time with Vampire Clone:

    <iframe src="https://poulsbopete.github.io/Vampire-Clone/" width="100%" height="800" frameborder="0" allowfullscreen style="border-radius:8px;display:block;"></iframe>
tabs:
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
