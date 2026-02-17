#!/bin/bash
# Challenge 10: AI-assisted investigation — user used AI (marker or note).
set -euo pipefail

# Verification is manual: user documents one finding from the AI assistant.
# Marker file indicates completion.
MARKER="${HOME}/.ai-investigation-done"
if [ -f "$MARKER" ]; then
  echo "Challenge 10 passed: AI-assisted investigation completed."
  exit 0
fi

echo "Challenge 10: Use the AI assistant in Kibana to investigate an issue, then run: touch ${MARKER}"
exit 1
