# Elastic Autonomous Observability

Instruqt workshop: **Elastic Serverless Observability with OpenTelemetry**.

Send logs, metrics, and traces via OpenTelemetry to Elastic Serverless; correlate signals, investigate latency and failures, reduce cardinality, and use AI-assisted investigation.

## Contents

- **Track**: `elastic-autonomous-observability/` — track config, 10 challenges, shared `scripts/` and `assets/`.
- **Challenges**: Explore the system, Send logs/metrics/traces, Correlate signals, Investigate latency, Find failing dependency, Reduce cardinality, Create SLO query, AI-assisted investigation.

## Pushing to Instruqt

From the repo root (recommended):

```bash
./scripts/instruqt-track-push.sh
```

Or from the track directory:

```bash
cd elastic-autonomous-observability && instruqt track push --force
```

The Cursor rule **Instruqt track — always push** reminds the agent to run a push after any change under `elastic-autonomous-observability/`.

Use a track pulled from Instruqt (with challenge dirs like `01-untitled-challenge-xxx`) so directory names match the server.

## Pushing to GitHub

```bash
git init
git remote add origin git@github.com:poulsbopete/elastic-autonomous-observability.git
git add -A
git commit -m "Elastic Serverless Observability workshop"
git branch -M main
git push -u origin main
```
