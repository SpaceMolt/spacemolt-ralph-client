#!/usr/bin/env bash

HARNESS="${1:-opencode}"
SCRIPT_DIR="$(dirname "$0")"
PROMPT_FILE="$SCRIPT_DIR/ralph-prompt.md"

echo "pwd=$(pwd)"
echo "harness=$HARNESS"

while true; do
  case "$HARNESS" in
    opencode)
      opencode run --format json -- "$(tr -d '\0' < "$PROMPT_FILE")" | jq -c
      ;;
    cursor)
      tr -d '\0' < "$PROMPT_FILE" | agent --model auto --force --stream-partial-output --output-format stream-json | jq -c
      ;;
    *)
      echo "Unknown harness: $HARNESS (expected: opencode, cursor)" >&2
      exit 1
      ;;
  esac
  sleep 1
done
