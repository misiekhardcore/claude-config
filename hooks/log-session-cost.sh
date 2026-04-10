#!/usr/bin/env bash
# Logs session cost to ~/.claude/cost-history.log on session end.
# Format: ISO-timestamp<TAB>session_id<TAB>cost_usd<TAB>cwd

LOG_FILE="$HOME/.claude/cost-history.log"
COST_DIR="$HOME/.claude/session-costs"

input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id // empty')

# Read the last known cost for this session (written by the status line script)
cost_file="$COST_DIR/${session_id}.cost"
if [ -f "$cost_file" ]; then
  cost_usd=$(cat "$cost_file")
  rm -f "$cost_file"
else
  cost_usd="0"
fi

# Only log if there was actual cost
if [ -n "$cost_usd" ] && [ "$cost_usd" != "0" ] && [ "$cost_usd" != "null" ]; then
  cwd=$(echo "$input" | jq -r '.cwd // ""')
  timestamp=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
  printf '%s\t%s\t%s\t%s\n' "$timestamp" "$session_id" "$cost_usd" "$cwd" >> "$LOG_FILE"
fi
