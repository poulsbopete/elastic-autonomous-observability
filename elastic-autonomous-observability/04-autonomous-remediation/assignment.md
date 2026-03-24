---
slug: autonomous-remediation
id: jxuqxkjpmkhe
type: challenge
title: Autonomous Investigation & Remediation
teaser: Watch Elastic's AI agent investigate the fault, generate a root-cause analysis,
  and trigger automated remediation — closing the loop without human intervention.
notes:
- type: text
  contents: |
    ## Lab 4 — Autonomous Investigation & Remediation

    **By the end of this challenge you will:**

    - ✅ Watch an ES|QL alert rule detect the fault you injected
    - ✅ See the Workflow automatically call the AI agent for root-cause analysis
    - ✅ Review the AI agent's investigation steps and remediation action
    - ✅ Find the auto-created Kibana Case with the full RCA summary
    - ✅ Confirm the fault is resolved and the alert recovers

    **This is the complete autonomous loop** — detection → investigation → remediation → documentation — with zero human intervention.
- type: text
  contents: |
    ## The Autonomous Loop in 5 Steps

    When your fault alert fires, this happens automatically:

    | Step | What runs | Time |
    |------|-----------|------|
    | **1** | ES|QL alert rule detects error spike | 0–60s |
    | **2** | Alert triggers **Significant Event Notification** workflow | immediate |
    | **3** | Workflow calls **AI agent** with error context | ~10s |
    | **4** | AI agent queries logs, identifies root cause, calls remediation | ~30s |
    | **5** | Workflow creates **Kibana Case** with full RCA + audit trail | ~5s |

    Total time from fault to resolved case: **2–3 minutes**.
- type: text
  contents: |
    ## The AI Agent's Toolbox

    The AI agent in this lab has two tools it can call:

    **`log_search`** — searches `logs.otel` by error type using parameterized ES|QL:
    ```
    FROM logs.otel, logs.otel.*
    | WHERE body.text : "{{ error_type }}"
    | WHERE @timestamp > NOW() - 5 MINUTES
    | STATS count = COUNT(*) BY service.name
    ```

    **`remediation_action`** — calls the Remediation Workflow with:
    ```json
    { "action_type": "resolve", "channel": 12, "dry_run": false }
    ```

    The agent runs a **multi-step reasoning loop**: call a tool → read results → decide next action — just like a human SRE would, but in seconds.
- type: text
  contents: |
    ## Traditional vs. Autonomous Observability

    | Traditional | Elastic Autonomous |
    |---|---|
    | Alert pages on-call engineer | Alert triggers workflow |
    | Engineer searches logs manually | AI agent queries ES\|QL |
    | Engineer identifies root cause | Agent produces structured RCA |
    | Engineer runs fix command | Workflow calls remediation API |
    | Engineer writes incident report | Kibana Case auto-created |
    | **MTTR: 30–90 minutes** | **MTTR: 2–3 minutes** |

    Humans shift from **doing** to **reviewing** — approving outcomes, not debugging incidents.
- type: text
  contents: |
    ## While You Wait...

    <iframe src="https://poulsbopete.github.io/Vampire-Clone/" width="100%" height="600" frameborder="0" allowfullscreen></iframe>
tabs:
- id: j9eexry1fgmk
  title: Demo App
  type: service
  hostname: es3-api
  path: /
  port: 8090
- id: 7zyo0vkzoic6
  title: Elastic Serverless
  type: service
  hostname: es3-api
  path: /app/observability/alerts?_g=(filters:!(),refreshInterval:(pause:!f,value:10000),time:(from:now-1h,to:now))
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

# Autonomous Investigation & Remediation

In this final challenge, you'll watch Elastic autonomously investigate the fault you injected and remediate it — then verify the full loop has closed.

---

## Step 1 — Watch the Alert Fire

First, confirm the alert rule detected your fault:

**Observability → Alerts**

Within 30–60 seconds of triggering a fault you should see an active alert. If no alert appears yet, wait a minute — the ES|QL rules run on a 30-second interval.

---

## Step 2 — Watch the Workflow Execute

Once an alert fires, the **Significant Event Notification** workflow runs automatically. In the **Elastic Serverless** tab:

**Observability → Workflows**

Find **Fanatics Collectibles Significant Event Notification** and click **Executions** to see:
- `count_errors` — ES|QL query counting recent errors
- `run_rca` — AI agent root-cause analysis
- `create_case` — Kibana case created with RCA findings

> **Note:** The **Remediation Action** workflow is a separate workflow called on-demand — it won't show executions here unless you manually trigger it.

---

## Step 3 — Review the AI Agent Investigation & Remediation

In the workflow execution log, expand the **run_rca** step to see what the AI agent did:

- **Error identification** — which service, which error type
- **Log correlation** — how many errors in the detection window
- **Root cause hypothesis** — what the AI agent determined
- **Remediation executed** — the agent automatically calls the `remediation_action` tool to resolve the fault

You can also chat directly with the AI agent — click **AI Agent** (top right in the Elastic Serverless tab) and ask:

```
What happened with the fault that was just detected? What caused it and how should it be resolved?
```

---

## Step 4 — Confirm the Loop Closed

After the workflow completes, verify end-to-end in the **Elastic Serverless** tab:

1. **Cases** — a new case with the AI's root-cause analysis and remediation summary
2. **Observability → Alerts** — alert moves to "Recovered" state
3. **Discover → ES|QL** — error rate drops back to baseline:
```esql
FROM logs*
| WHERE @timestamp > NOW() - 5 MINUTES
| WHERE severity_text == "ERROR"
| STATS error_count = COUNT(*) BY service.name
| SORT error_count DESC
```
4. **Demo App → Chaos** link — all channels back to **STANDBY**

---

## Step 5 — Try a Cascade (Optional)

Trigger **multiple channels at once** from the **Demo App → Chaos** link to see cascade effects — inject channels 7, 8, and 9 (all GCP network_access services). Watch how the AI agent correlates errors across multiple services back to a single root cause, then resolves all three automatically.

---

## What You've Built

By completing this lab, you've seen the complete Elastic Autonomous Observability loop:

| Stage | Elastic Feature |
|-------|----------------|
| **Instrument** | OTLP ingestion — logs, metrics, traces |
| **Detect** | ES|QL alert rules — real-time anomaly detection |
| **Investigate** | AI Agent with tools — automated root-cause analysis |
| **Remediate** | Elastic Serverless Workflows — auto-remediation + notification |
| **Verify** | Dashboards & APM — confirm resolution |

✅ **Ready to complete when** all fault channels are resolved (no active chaos).
