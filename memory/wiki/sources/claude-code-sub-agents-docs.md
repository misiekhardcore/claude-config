---
type: source
title: "Claude Code Subagents Documentation"
source_type: official-docs
author: Anthropic
date_published: 2026-04
url: https://code.claude.com/docs/en/sub-agents
source_reliability: high
accessed: 2026-04-22
tags:
  - claude-code
  - subagents
  - task-tool
  - official
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions."
  - "Control costs by routing tasks to faster, cheaper models like Haiku."
  - "If you need multiple agents working in parallel and communicating with each other, see agent teams instead."
  - "Use one when a side task would flood your main conversation with search results, logs, or file contents you won't reference again."
related:
  - "[[subagent-spawn-mechanics]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[claude-code-agent-teams-docs]]"
  - "[[skill-vs-subagent-tool-fields]]"
---

# Claude Code Subagents Documentation

Canonical Anthropic reference for subagents (Task tool + custom agent definitions).

## Summary

Official `/en/sub-agents` page. Defines what subagents are, why you'd use them, how to create custom ones, default types, and their context-isolation model.

## Core Definition (Verbatim)

> Subagents are specialized AI assistants that handle specific types of tasks. Use one when a side task would flood your main conversation with search results, logs, or file contents you won't reference again: the subagent does that work in its own context and returns only the summary.

> Each subagent runs in its own context window with a custom system prompt, specific tool access, and independent permissions. When Claude encounters a task that matches a subagent's description, it delegates to that subagent, which works independently and returns results.

## What Subagents Enable (Verbatim Bullets)

- **Preserve context** by keeping exploration and implementation out of your main conversation
- **Enforce constraints** by limiting which tools a subagent can use
- **Reuse configurations** across projects with user-level subagents
- **Specialize behavior** with focused system prompts for specific domains
- **Control costs** by routing tasks to faster, cheaper models like Haiku

## Relationship to Agent Teams (Verbatim)

> If you need multiple agents working in parallel and communicating with each other, see agent teams instead. Subagents work within a single session; agent teams coordinate across separate sessions.

## Default Subagent Types (From Docs + Reverse-Engineering)

| Type | Context inheritance | Tool surface |
|---|---|---|
| `general-purpose` | Full inherit | All tools (except nested Task) |
| `Plan` | Full inherit | Planning/read tools |
| `Explore` | Fresh context | Glob, Grep, Read (no Edit/Write) |
| `claude-code-guide` | Fresh | Docs lookup |
| `statusline-setup` | Fresh | Read, Edit |

Custom subagents defined in `.claude/agents/<name>.md` start with fresh context; only the prompt string crosses from parent.

## Model Override

Per-subagent `model:` frontmatter field. `model: inherit` matches parent. Default for all inherited via `CLAUDE_CODE_SUBAGENT_MODEL` env var. Officially recommended: route cheap tasks to Haiku.

## Permissions Model

Subagents inherit parent permissions plus any additional tool restrictions from their `tools:` frontmatter field. `tools:` is a restrictive allowlist (opposite semantics from Skill `allowed-tools`, which is permissive pre-approval). See [[skill-vs-subagent-tool-fields]].

## Hard Constraint

Subagents cannot spawn subagents. Parallelism is orchestrated from the main thread only.

## Caveats

- Context is fresh per-spawn (except `general-purpose`/`Plan` inheriting defaults)
- Parent → subagent channel is a single prompt string
- Subagent → parent channel is the final message only; intermediate tool calls stay in subagent context
- Open feature request for opt-in `fork_context: true` to inherit full conversation history
