---
type: concept
title: "Claude Code Hook Template Variable Expansion Scope"
created: 2026-04-21
updated: 2026-04-21
tags:
  - plugin-development
  - claude-code
  - hooks
  - template-variables
  - bug-fix
status: current
confidence: EXTRACTED
evidence:
  - "misiekhardcore/claude-obsidian PR #29 — fixed resolve-vault.sh to receive vault_path as $1"
  - "Observed: ${user_config.vault_path} in shell script body always empty; same variable in hooks.json command string expands correctly"
related:
  - "[[Plugin Root Variable in Skills]]"
  - "[[claude-plugin-userconfig-schema]]"
  - "[[claude-skill-anatomy]]"
  - "[[out-of-session-plugin-config-access]]"
---

# Claude Code Hook Template Variable Expansion Scope

## Context

Claude Code plugins can define `userConfig` fields (e.g. `vault_path`) that users set in their `settings.json` `pluginConfigs` block. These values are available at hook execution time as template variables like `${user_config.vault_path}`.

## Guidance

Template variables such as `${user_config.vault_path}` and `${CLAUDE_PLUGIN_ROOT}` are expanded **only in hook `command` strings inside `hooks.json`**. They are NOT expanded inside external shell script files that hooks call.

**Correct pattern — pass the value as a positional argument from hooks.json:**

`hooks.json`:
```json
{
  "command": "\"${CLAUDE_PLUGIN_ROOT}/scripts/resolve-vault.sh\" \"${user_config.vault_path}\""
}
```

`resolve-vault.sh`:
```bash
#!/usr/bin/env bash
VAULT="${1:-}"                           # $1 is the expanded vault_path
[ -z "$VAULT" ] && [ -d "$(pwd)/wiki" ] && VAULT="$(pwd)"
[ -z "$VAULT" ] && echo "no vault configured" >&2 && exit 1
echo "$VAULT"
```

**Broken pattern — reading the variable inside the script:**

```bash
#!/usr/bin/env bash
VAULT="${user_config.vault_path}"       # NEVER expands — always empty string
```

## Why

Claude Code's hook runner performs template substitution on the `command` string before passing it to the shell. Once the shell receives the command, it sees a normal bash string — any `${...}` that wasn't substituted at the Claude level is interpreted as a shell variable, which is undefined and expands to empty.

External scripts inherit the shell environment but not Claude Code's template context.

## When to Use

Apply this pattern any time a hook calls an external script that needs a `userConfig` value, a `CLAUDE_PLUGIN_ROOT` subpath, or any other Claude template variable.

## Examples

All four hooks in `claude-obsidian`'s `hooks.json` follow this pattern:

```json
"command": "VAULT=$(\"${CLAUDE_PLUGIN_ROOT}/scripts/resolve-vault.sh\" \"${user_config.vault_path}\") || exit 0; ..."
```

The script receives the path as `$1` and the hook command handles the expansion before the shell sees it.
