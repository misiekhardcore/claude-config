---
type: concept
title: "Claude Plugin userConfig Schema — Required Fields"
created: 2026-04-21
updated: 2026-04-21
tags:
  - plugin-development
  - claude-code
  - userconfig
  - bug-fix
status: current
confidence: EXTRACTED
evidence:
  - "misiekhardcore/claude-obsidian PR #28 — added title+type to fix install failure"
  - "claude plugin install error messages: userConfig.vault_path.type: Invalid option, userConfig.vault_path.title: Invalid input"
related:
  - "[[Plugin Root Variable in Skills]]"
  - "[[claude-skill-anatomy]]"
  - "[[skill-frontmatter-reference]]"
  - "[[claude-hook-template-variable-expansion]]"
---

# Claude Plugin userConfig Schema — Required Fields

## Problem

Claude Code plugin install fails with cryptic validation errors when `userConfig` fields in `plugin.json` are missing required schema properties.

## Symptoms

`claude plugin install` reports:
```
userConfig.vault_path.type: Invalid option
userConfig.vault_path.title: Invalid input
```

The plugin appears in the marketplace but fails to install or prompts never render correctly.

## What Didn't Work

Defining `userConfig` with only a `description` field:

```json
"userConfig": {
  "vault_path": { "description": "Path to your Obsidian vault" }
}
```

Claude Code's schema validator rejects this silently at install time.

## Solution

Every `userConfig` field must have both `title` (string) AND `type` (one of `string|number|boolean|directory|file`):

```json
"userConfig": {
  "vault_path": {
    "title": "Vault path",
    "type": "directory",
    "description": "Absolute path to your Obsidian vault"
  }
}
```

## Why It Works

Claude Code validates the `userConfig` schema strictly at install time. Both `title` and `type` are required by the internal validator — `description` alone is insufficient. The validator does not fall back to defaults or emit a warning; it hard-fails.

## Prevention

When authoring a Claude Code plugin, always include all three fields for every `userConfig` entry:

| Field | Type | Purpose |
|-------|------|---------|
| `title` | string | Display name shown in the settings UI |
| `type` | `string\|number\|boolean\|directory\|file` | Controls input widget and path resolution |
| `description` | string | Help text shown below the field |

Lint check: `grep -A5 '"userConfig"' plugin.json` and confirm every leaf has `title` + `type`.
