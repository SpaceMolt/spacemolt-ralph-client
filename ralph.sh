#!/usr/bin/env bash

HARNESS="opencode"
MODEL=""
SLEEP=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --harness) HARNESS="$2"; shift 2 ;;
    --model)   MODEL="$2"; shift 2 ;;
    --sleep)   SLEEP="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(dirname "$0")"
PROMPT_FILE="$SCRIPT_DIR/ralph-prompt.md"
PROMPT="$(tr -d '\0' < "$PROMPT_FILE")"

echo "pwd=$(pwd)"
echo "harness=$HARNESS model=${MODEL:-default} sleep=$SLEEP"

while true; do
  case "$HARNESS" in
    opencode)
      opencode run --format json \
        ${MODEL:+--model "$MODEL"} \
        -- "$PROMPT" | jq -c
      ;;
    cursor)
      echo "$PROMPT" | agent \
        --model "${MODEL:-auto}" \
        --force --stream-partial-output --output-format stream-json | jq -c
      ;;
    gemini)
      gemini \
        ${MODEL:+--model "$MODEL"} \
        --prompt "$PROMPT" \
        --output-format stream-json \
        --yolo | jq -c
      ;;
    claude)
      claude \
        ${MODEL:+--model "$MODEL"} \
        --print --output-format stream-json \
        --dangerously-skip-permissions \
        "$PROMPT" | jq -c
      ;;
    *)
      echo "Unknown harness: $HARNESS (expected: opencode, cursor, gemini, claude)" >&2
      exit 1
      ;;
  esac
  sleep "$SLEEP"
done
