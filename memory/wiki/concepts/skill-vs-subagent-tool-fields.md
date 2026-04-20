---
name: Skill allowed-tools vs subagent tools field
description: The `allowed-tools` field in SKILL.md pre-approves; the `tools:` field in .claude/agents/ restricts. Same-looking fields, opposite semantics.
type: concept
tags: [claude-code, skills, subagents, permissions, frontmatter]
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-19
related:
  - "[[allowed-tools-semantics]]"
  - "[[allowed-tools-for-multi-agent-plugins]]"
  - "[[skill-frontmatter-reference]]"
  - "[[hierarchical-agent-decomposition]]"
sources:
  - "[[claude-code-skills-official-docs]]"
---

# Skill `allowed-tools` vs Subagent `tools`

Two frontmatter fields look similar and are often conflated. They behave oppositely.

## Comparison

| Aspect | Skill `allowed-tools` (in `SKILL.md`) | Subagent `tools` (in `.claude/agents/*.md`) |
|--------|---------------------------------------|---------------------------------------------|
| **Semantic role** | Pre-approves tools (waives per-use prompts) | Defines capability boundary for isolated agent |
| **Enforcement** | Permissive (not a sandbox) | Restrictive (hard allowlist) |
| **Context** | Runs inline in main conversation | Runs in isolated context window |
| **Unlisted tools** | Still callable; fall through to user permission rules | Not available to the subagent at all |
| **Field name** | `allowed-tools` (hyphen) | `tools` |
| **File location** | `skills/<name>/SKILL.md` | `.claude/agents/<name>.md` or `~/.claude/agents/` |
| **SDK behavior** | Ignored — SDK uses `allowedTools` query option | Same field works via Agent SDK subagent config |
| **Typical value** | `Read Grep` (space-separated) or YAML list | `Read, Grep, Glob, Bash` (comma-separated) |

## Mental Model

- A **skill** is reference material loaded into the main agent. Its `allowed-tools` is a **UX shortcut** — "don't interrupt the user for these."
- A **subagent** is an isolated worker with its own context. Its `tools` is a **capability envelope** — "this is all you're permitted to use."

## Bridging Pattern

A skill can spawn a subagent via `context: fork` + `agent: <name>`. When this happens:

- The skill's `allowed-tools` governs what the **calling context** can do without prompts.
- The subagent's `tools:` governs what the **forked agent** can do at all.

Example in `SKILL.md`:

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore           # Uses Explore subagent's tools list
allowed-tools: Bash(gh *)  # Pre-approves gh CLI in the outer context
---
```

The `Explore` built-in subagent restricts itself to `Glob`, `Grep`, `Read`. `Bash(gh *)` in `allowed-tools` applies to any pre-processing `` !`gh ...` `` commands that run before the fork.

## Why This Matters for Multi-Agent Plugins

Plugin authors who want real capability restriction per workflow step should reach for subagents, not `allowed-tools`. See [[allowed-tools-for-multi-agent-plugins]] for the full pattern applied to claude-workflow and similar orchestrator plugins.

## Common Mistakes

- Writing `allowed-tools: Read` in a skill and assuming Write is now blocked — it isn't.
- Copying a subagent's `tools:` line into a skill's frontmatter — wrong field name (should be `allowed-tools`) and wrong semantics (would pre-approve, not restrict).
- Declaring both in a skill hoping for belt-and-braces — only one is read; the effect is the same as declaring `allowed-tools` alone.
