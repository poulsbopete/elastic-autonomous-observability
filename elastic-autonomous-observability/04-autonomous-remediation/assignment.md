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
    ## Closing the Loop — Autonomously

    This is where Elastic's Autonomous Observability story comes together.

    When an alert fires, an Elastic Serverless Workflow automatically:

    1. **Searches** recent error logs to gather context
    2. **Calls the AI agent** with the error details
    3. The **AI agent** uses its tools to:
       - Query ES|QL for related error patterns
       - Look up the event in the significant events log
       - Cross-reference with infrastructure metrics
       - Produce a root-cause analysis
    4. **Calls the remediation API** to resolve the fault
    5. **Creates a Kibana Case** with the full RCA + remediation summary

    All of this happens within 2–3 minutes of the fault being detected — with zero human interaction required.
- type: text
  contents: |
    ## Kibana Workflows: Orchestration Without Code

    Elastic **Workflows** (Pre-GA) is a YAML-first automation engine built into Kibana Serverless.

    **What workflows can do:**

    - Query Elasticsearch and ES|QL natively — no external connectors needed
    - Call AI agents and receive structured responses
    - Branch on conditions, loop over results, set variables
    - Send email, Slack, Jira tickets, or webhook calls via connectors
    - Create Kibana Cases for incident tracking
    - Trigger other workflows as sub-processes

    Workflows are triggered by **alert rules** (using the built-in `.workflows` system connector), schedules, or manual runs — making them the glue between detection and response.
- type: text
  contents: |
    ## AI Agent Builder: Tools the LLM Can Call

    The **Agent Builder** lets you define an AI agent with a set of tools — each backed by an ES|QL query or a workflow — and a system prompt that guides the agent's behavior.

    **How the agent in this lab works:**

    - **`log_search` tool** — parameterized ES|QL that searches `logs.otel` by error type; the agent provides the error type, the query handles field routing
    - **`remediation_action` tool** — calls the remediation Kibana Workflow with `action_type`, `channel`, and `dry_run: false`
    - **System prompt** — instructs the agent to always use `body.text` for log searches, produce a structured RCA, and immediately execute remediation after analysis

    The agent runs as a **multi-step reasoning loop**: it calls tools, reads results, and decides its next action — just like a human SRE would.
- type: text
  contents: |
    ## Kibana Cases: Collaborative Incident Management

    Elastic **Cases** is a built-in incident tracking system — no external ticketing tool required.

    **Cases in this lab:**

    - Created automatically by the Workflow after the AI agent completes RCA + remediation
    - Title includes the scenario name and the alert rule that fired
    - Description contains a link to the full AI conversation and the RCA summary
    - Tagged with the scenario namespace and the error type for easy filtering
    - Severity set to `high` automatically — no manual triage needed

    **Why Cases matter for autonomous observability:** the entire incident lifecycle — detection, investigation, remediation, and documentation — is captured in one place, with a full audit trail, without a human ever touching a terminal.
- type: text
  contents: |
    ## What "Autonomous Observability" Really Means

    Traditional observability is **reactive**: humans watch dashboards, get paged, log in, investigate, fix.

    Elastic's model is **autonomous**: the platform detects, investigates, remediates, and documents — humans review outcomes, not processes.

    **The shift in practice:**

    | Traditional | Autonomous |
    |---|---|
    | Alert pages on-call engineer | Alert triggers workflow |
    | Engineer searches logs manually | AI agent queries ES\|QL via tools |
    | Engineer identifies root cause | Agent produces structured RCA |
    | Engineer runs fix command | Workflow calls remediation API |
    | Engineer writes incident report | Case created with full audit trail |
    | MTTR: 30–90 minutes | MTTR: 2–3 minutes |

    This lab demonstrates that entire journey — in a real Elastic Serverless environment.
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
