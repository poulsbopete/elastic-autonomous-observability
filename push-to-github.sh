#!/bin/bash
# Run from repo root to push to GitHub (first time or after changes).
set -e
cd "$(dirname "$0")"
git init
git remote add origin git@github.com:poulsbopete/elastic-autonomous-observability.git 2>/dev/null || git remote set-url origin git@github.com:poulsbopete/elastic-autonomous-observability.git
git add -A
git commit -m "Elastic Serverless Observability workshop: track, 10 challenges, scripts, assets" || true
git branch -M main
git push -u origin main
