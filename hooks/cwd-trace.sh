#!/usr/bin/env bash
mkdir -p "$HOME/.claude/usage-data"
printf '%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(pwd)" \
    >> "$HOME/.claude/usage-data/cwd-trace.log" 2>/dev/null || true
exit 0
