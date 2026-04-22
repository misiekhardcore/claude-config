---
type: concept
title: "Out-of-Session Plugin Config Access via settings.local.json"
created: 2026-04-22
updated: 2026-04-22
tags:
  - plugin-development
  - claude-code
  - hooks
  - cron
  - pattern
status: current
confidence: EXTRACTED
evidence:
  - "misiekhardcore/claude-obsidian PR #32 — added settings.local.json fallback to resolve-vault.sh"
  - "Verified: jq and python3 fallbacks both resolve vault_path from out-of-session context"
related:
  - "[[Claude Code Hook Template Variable Expansion Scope]]"
  - "[[Plugin Root Variable in Skills]]"
  - "[[claude-plugin-userconfig-schema]]"
implements:
  - "[[Claude Code Hook Template Variable Expansion Scope]]"
---

# Out-of-Session Plugin Config Access via settings.local.json

## Context

When shell scripts in Claude Code plugins are invoked outside an active session (cron jobs, systemd timers, CI pipelines, manual calls), the `${user_config.*}` template variables are not available. The harness only expands these at session start, inside `hooks.json` command strings. External invocations receive no session context.

This is the symmetric out-of-session counterpart to [[Claude Code Hook Template Variable Expansion Scope]] (which covers the in-session fix via `$1` argument passing).

Affected: any plugin script that needs user-configured values (paths, tokens, options) when called from cron or directly.

## Guidance

Add a fallback that reads `~/.claude/settings.local.json` directly. Use `jq` if available, `python3` as fallback:

```bash
if [ -z "$VAULT" ] && [ -f "$HOME/.claude/settings.local.json" ]; then
  if command -v jq >/dev/null 2>&1; then
    VAULT=$(jq -r '(.pluginConfigs // {}) | to_entries[] | select(.key | contains("claude-obsidian")) | .value.options.vault_path // empty' "$HOME/.claude/settings.local.json" 2>/dev/null | head -1)
  elif command -v python3 >/dev/null 2>&1; then
    VAULT=$(python3 -c "
import json
try:
    with open('$HOME/.claude/settings.local.json') as f:
        d = json.load(f)
    for k, v in d.get('pluginConfigs', {}).items():
        if 'claude-obsidian' in k:
            print(v.get('options', {}).get('vault_path', ''))
            break
except Exception:
    pass
" 2>/dev/null)
  fi
fi
```

JSON path in `settings.local.json`:
```
pluginConfigs["<plugin>@<marketplace>"].options.<config-key>
```

Use `contains("plugin-name")` for key matching — the install ID format is `<plugin>@<marketplace>` and can vary by install method. Do not hardcode the exact ID.

## Why

`~/.claude/settings.local.json` is the persistent machine-local config store the harness reads at session start to populate `${user_config.*}`. Reading it directly is the only reliable way to access plugin options from an external process. The value is always present after the user has run `/wiki init` (or equivalent setup).

## When to Use

Any plugin shell script that:
1. May be invoked outside a Claude Code session (cron, systemd, CI, manual)
2. Needs access to a value the user configured via `pluginConfigs.options`

Recommended fallback order:
1. Explicit `$1` argument (in-session hook call)
2. CWD heuristic (e.g. presence of `wiki/` subdir)
3. `settings.local.json` read (out-of-session fallback)
4. Error with actionable message

## Examples

`scripts/resolve-vault.sh` in `misiekhardcore/claude-obsidian` — resolves vault path for the `bin/wiki-lint-cron.sh` cron runner. Without this fallback, the cron job documented in the README failed out of the box even when the vault was correctly configured (issue #31, fixed in PR #32).
