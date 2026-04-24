#!/usr/bin/env bash
# Push the Instruqt track to play.instruqt.com (run from repo root).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/elastic-autonomous-observability"
exec instruqt track push --force "$@"
