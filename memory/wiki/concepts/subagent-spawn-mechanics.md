---
name: Subagent Spawn Mechanics
description: What loads into a subagent's context at spawn time, what crosses the parent-subagent boundary, and what the lifecycle looks like. Reference for cost and context-isolation reasoning.
type: concept
tags: [claude-code, subagents, task-tool, context-window]
status: current
created: 2026-04-22
updated: 2026-04-22
confidence: EXTRACTED
evidence:
  - "[[claude-code-sub-agents-docs]]"
uses:
  - "[[skill-vs-subagent-tool-fields]]"
related:
  - "[[teamcreate-architecture]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[skill-vs-subagent-tool-fields]]"
  - "[[hierarchical-agent-decomposition]]"
sources:
  - "[[claude-code-sub-agents-docs]]"
---

# Subagent Spawn Mechanics

The Task tool spawns a subagent. This page documents what actually happens at spawn — what loads, what crosses boundaries, and what returns.

## Lifecycle

```
Parent session
    │
    │  Task({prompt, subagent_type, ...})
    ▼
[Subagent spawns]
    │  Own context window (fresh unless type inherits)
    │  Own system prompt (from agent type definition)
    │  Own permission envelope
    │  Tools restricted by `tools:` field (or parent defaults)
    │
    ▼
[Subagent runs]
    Reads files, calls tools, reasons — all of this stays in the subagent.
    │
    ▼
[Subagent returns]
    Only the final message crosses back to the parent.
    Intermediate tool calls and results are discarded.
```

## What Loads at Spawn

Per the official docs for default agent types:

| Agent type | Context inheritance | Tool surface |
|---|---|---|
| `general-purpose` | **Full inherit** of parent conversation | Most tools (no nested Task) |
| `Plan` | **Full inherit** | Planning/read tools |
| `Explore` | **Fresh** (no parent context) | Glob, Grep, Read only |
| Custom (`.claude/agents/<name>.md`) | **Fresh** — only prompt string crosses | Defined by `tools:` field |

For custom subagents the context starts empty. The only input is the prompt string you pass via the Task tool. If the subagent needs file paths, decisions, or error messages, they must be in that prompt.

## What Does NOT Load Automatically

- Parent's conversation history (except for `general-purpose` and `Plan`).
- Parent's tool results.
- Any files the parent has read, unless the subagent re-reads them.

## What DOES Load Automatically (for custom subagents)

- The subagent's own system prompt from its markdown frontmatter/body.
- Claude Code's base system prompt (same as parent).
- Tools listed in `tools:` allowlist (restrictive).

> Ambiguity: does CLAUDE.md load into a custom subagent the same as into a team teammate? The official docs do not state this explicitly for subagents. Agent teams docs explicitly say teammates load CLAUDE.md; subagent docs do not explicitly say either way. Assume yes for practical sizing but verify.

## Return Channel

> Each subagent runs in its own fresh conversation. Intermediate tool calls and results stay inside the subagent; only its final message returns to the parent.

The parent receives the subagent's final message verbatim as the Task tool result. The parent may summarize it further in its own response to the user, but the raw return is the full final message.

## Cost Model

1. **Per-spawn baseline**: roughly 20k tokens to load system prompt + tools + CLAUDE.md (community-reported figure). Comparable to a fresh Claude Code session because it effectively is one.
2. **Execution tokens**: the subagent burns tokens on whatever it does (reads, searches, reasoning).
3. **Return-only cost to parent**: the parent pays for the subagent's final message tokens, not for every intermediate step. This is the core context-savings benefit.

## Parallelism Ceiling

- Subagents cannot spawn subagents (hard limit, one level deep).
- Parent can spawn multiple in parallel. Community-reported concurrent ceiling: ~10 simultaneous Task tool invocations.
- No dynamic queue — the parent waits for the full batch before starting the next.

## Mental Model

> A subagent is a disposable, context-isolated worker whose value proposition is: do a bounded task, burn tokens on it in your own window, return one clean message.

Contrast with teammates (see [[teamcreate-architecture]]), which are long-lived peer sessions that communicate sideways via mailbox — a different shape entirely.

## Related

- [[skill-vs-subagent-tool-fields]] — the `tools:` field semantics (restrictive, opposite of skill's `allowed-tools`)
- [[teamcreate-architecture]] — the alternative parallelism pattern
- [[subagent-vs-teamcreate-rubric]] — when to pick which
- [[hierarchical-agent-decomposition]] — why the one-level limit forces linear decomposition
