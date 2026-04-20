---
name: allowed-tools frontmatter semantics
description: The `allowed-tools` field in SKILL.md pre-approves tools (UX), it does not restrict them (sandbox). Restriction requires deny rules or subagent tools field.
type: concept
tags: [claude-code, skills, frontmatter, permissions, security]
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-19
related:
  - "[[skill-frontmatter-reference]]"
  - "[[skill-vs-subagent-tool-fields]]"
  - "[[allowed-tools-for-multi-agent-plugins]]"
  - "[[claude-code-skills-official-docs]]"
  - "[[agent-skills-best-practices-anthropic]]"
sources:
  - "[[agent-skills-best-practices-anthropic]]"
  - "[[claude-code-skills-official-docs]]"
---

# `allowed-tools` Frontmatter Semantics

## The Rule

`allowed-tools` in `SKILL.md` frontmatter is a **pre-approval list**, not a restriction list.

When a skill with `allowed-tools: Read Grep` is active, Claude can call `Read` and `Grep` without per-use permission prompts. Claude can still call `Write`, `Bash`, or any other tool — those fall through to the user's normal permission settings (prompt, allow, or deny per `.claude/settings.json`).

(Source: [[agent-skills-best-practices-anthropic]], [[claude-code-skills-official-docs]])

## What It Does Not Do

- Does **not** hide or remove tools from Claude's toolkit.
- Does **not** enforce a sandbox during skill execution.
- Does **not** apply in `bypassPermissions` mode (every tool is auto-approved regardless).
- Does **not** apply when a skill is loaded via the Agent SDK — the SDK ignores this frontmatter and uses the `allowedTools` query option instead. Relevant only for Claude Code CLI.

## How to Actually Restrict

| Goal | Mechanism |
|------|-----------|
| Block a tool for one skill | Deny rule in `.claude/settings.json`: `Skill(name) + deny Write` pattern, or global deny rule |
| Hard allowlist in SDK | `allowedTools: [...]` query option **+** `permissionMode: "dontAsk"` (denies unlisted tools) |
| Sandbox an agent-level workflow | Use a subagent (`.claude/agents/*.md` with `tools:` field) — that field IS restrictive |
| Prevent automatic invocation entirely | `disable-model-invocation: true` (side-effect skills like `/deploy`, `/commit`) |

## Permission Evaluation Order (Claude Code CLI)

1. Deny rules (from `settings.json`, `disallowed_tools`) — blocks even in `bypassPermissions`.
2. Active permission mode — `bypassPermissions` approves everything past this point, ignoring `allowed-tools`.
3. `allowed-tools` pre-approvals — skip the prompt for listed tools.
4. Allow rules in settings.
5. User prompt for everything remaining.

(Source: [[agent-skills-best-practices-anthropic]])

## Common Misconception

Several community guides (and the claude-workflow plugin's own `AUTHORING.md` as of 2026-04-19) describe `allowed-tools` as "restrict the skill to a subset of tools." That matches subagent `tools:` semantics, not skill `allowed-tools` semantics. The official docs contradict this reading directly:

> It does not restrict which tools are available: every tool remains callable, and your permission settings still govern tools that are not listed.
> — code.claude.com/docs/en/skills, "Pre-approve tools for a skill" section

> [!gap] Claude-workflow repo's `_templates/AUTHORING.md` is incorrect on this point. Fix when next editing that file.

## When to Declare

Declare `allowed-tools` when:

- The skill routinely runs specific tool calls and per-use prompts would interrupt flow (e.g., `/commit` runs `Bash(git add *)`, `Bash(git commit *)`, `Bash(git status *)`).
- The skill is tightly scoped and pre-approval is the whole point (e.g., a forked research agent that only reads).
- Combined with `disable-model-invocation: true` for side-effectful commands — defense in depth: user-only invocation + narrow pre-approved toolset.

Omit `allowed-tools` when:

- The skill uses standard tools the user already has rules for.
- You want to defer to user-level permissions for every call.
- The skill may run under the Agent SDK (field is ignored there).
- Cross-platform portability matters (tool names differ: Claude Code `Read` vs Copilot CLI `read_file`).

## Why

The UX contract separates two concerns:

- **Discovery** (description) — whether the skill loads.
- **Capability** (tools available to Claude) — governed by the permission system.
- **Consent** (per-use prompts) — governed by `allowed-tools` + user rules.

Treating `allowed-tools` as a sandbox breaks the separation and produces false security: a skill author who thinks they've restricted access has instead only waived prompts for a subset while leaving everything else reachable. Real isolation requires either deny rules, SDK `permissionMode: "dontAsk"`, or a subagent with a `tools:` restriction.
