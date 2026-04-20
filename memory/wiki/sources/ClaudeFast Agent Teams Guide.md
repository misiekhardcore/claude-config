---
name: ClaudeFast Agent Teams Guide
description: ClaudeFast practical guide to Claude Code subagents, Agent Teams (TeamCreate), parallel vs sequential patterns, and artifact handoffs
type: source
source_type: guide
author: ClaudeFast
date_published: 2026
url: https://claudefa.st/blog/guide/agents/agent-teams
source_reliability: medium
key_claims:
  - Subagents start fresh, isolated from main conversation context
  - Subagents cannot spawn other subagents (hard Anthropic limit)
  - TeamCreate (experimental) enables real-time agent-to-agent communication via SendMessage
  - File-based artifact handoff is the canonical chaining pattern
  - Domain ownership between agents prevents merge conflicts
tags: [claude-code, subagents, TeamCreate, orchestration]
status: developing
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[agent-handoff-artifact-pattern]]"
evidence: []
---

# ClaudeFast — Agent Teams Guide

Practical guide covering Claude Code's subagent and Agent Teams (TeamCreate) features. Confidence: medium (secondary source, but aligned with official Anthropic docs).

## Key Claims

1. **Subagents**: isolated Claude instances with own context. Start fresh; take task, do work, return only summary.
2. **Hard limit**: "Subagents can't spawn other subagents." Critical for workflow design — forces either flat decomposition or switch to TeamCreate.
3. **Agent Teams (experimental)**: "Lets you orchestrate teams of Claude Code sessions working together on a shared project. One session acts as the team lead... Teammates communicate directly with each other."
4. **Activation**: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` enables TeamCreate.
5. **Dual-mode detection**: workflows auto-select subagent vs. team mode based on TeamCreate availability.
6. **Artifact handoff**: "Use the output files as the handoff mechanism between stages. The design subagent isn't distracted by implementation concerns."
7. **Domain ownership**: frontend/backend/QA agents own non-overlapping file trees to prevent conflicts.
8. **Fresh-perspective review**: a subagent with no conversation history catches bugs familiarity obscures.

## Relevance to claude-workflow

- Explains why claude-workflow needs TeamCreate for two-level team nesting (subagents alone max out at one level).
- Validates the "GitHub issue body as artifact" choice — aligns with the canonical file-based handoff pattern.
- Supports the fresh-session-per-phase rule.

## Related

- [[multiskill-workflow-patterns]]
- [[hierarchical-agent-decomposition]] — cites the subagent depth limit
- [[agent-handoff-artifact-pattern]] — artifact-handoff claim
