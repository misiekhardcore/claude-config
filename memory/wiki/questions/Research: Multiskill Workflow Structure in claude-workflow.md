---
type: synthesis
title: "Research: Multiskill Workflow Structure in claude-workflow"
created: 2026-04-19
updated: 2026-04-19
tags:
  - research
  - claude-workflow
  - orchestration
  - skills
status: developing
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[seed-brief-pattern]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[Superpowers Plugin]]"
  - "[[Microsoft Agent Framework]]"
  - "[[skill-invocation-model]]"
sources:
  - "[[MindStudio Skill Collaboration Pattern]]"
  - "[[Beam Multi-Agent Orchestration Patterns]]"
  - "[[Microsoft Agent Framework Handoff Workflows]]"
  - "[[Addy Osmani Code Agent Orchestra]]"
  - "[[ClaudeFast Agent Teams Guide]]"
  - "[[Superpowers GitHub]]"
---

# Research: Multiskill Workflow Structure in claude-workflow

## Overview

How should the claude-workflow plugin structure workflows where one skill invokes other skills? Research across Anthropic's sub-agent docs, Microsoft Agent Framework, Superpowers plugin, and multi-agent orchestration literature converges on a clear answer: **durable artifacts between phases, hierarchical team shapes within phases, seed briefs for shared context between specialists, and Claude-as-orchestrator for cross-skill composition**. The existing claude-workflow design aligns with this; recent edits (Prior-Art Scout hoisting in `/discovery`) further match the seed-brief pattern already used in `/define`.

## Key Findings

- **Claude is the default orchestrator.** Skills don't call each other directly; Claude reads each output and decides the next call. The sub-skill (parent/child) pattern exists but "reduces flexibility and is harder to debug" (Source: [[MindStudio Skill Collaboration Pattern]]). claude-workflow uses sub-skills deliberately at phase boundaries where gating is required.

- **Four composition shapes** — linear, branching, loop, parallel — with most workflows being hybrids (Source: [[MindStudio Skill Collaboration Pattern]]). claude-workflow uses: linear at the phase level (`/discovery → /define → /implement`), parallel within each phase (specialists), sometimes branching (mode-triaged team composition).

- **Durable artifact handoffs between phases.** The GitHub issue body is the cross-phase artifact in claude-workflow — five-field handoff block, updated in place, single source of truth. Fresh session starts each phase. This aligns with the file-based handoff pattern (Source: [[ClaudeFast Agent Teams Guide]]).

- **Seed briefs within phases.** `/define` dispatches a research team whose brief seeds `/architecture` and `/design`, letting them skip their own research. Newly hoisted: `/discovery`'s Prior-Art Scout brief seeds `/describe` and `/specify`. Same contract. See [[seed-brief-pattern]].

- **Hierarchical decomposition** prevents orchestrator context fragmentation. claude-workflow uses two levels: phase team → specialist's nested team. Only possible via TeamCreate (subagents can't spawn subagents). See [[hierarchical-agent-decomposition]].

- **Single-agent is the default for good reason.** Princeton NLP: a well-built single agent matches multi-agent on 64% of tasks at half the cost (Source: [[Addy Osmani Code Agent Orchestra]]). claude-workflow's CLAUDE.md encodes this: TeamCreate only for parallelizable work across 3+ independent files or sub-issues.

- **Infinite handoff loops are the #1 failure mode** in multi-agent systems (Source: [[Beam Multi-Agent Orchestration Patterns]]). claude-workflow's linear phase DAG with explicit approval gates avoids this by design — no runtime routing back.

- **Structured I/O contracts.** Reliable composition needs structured outputs (JSON or fixed markdown shape), not free text. claude-workflow uses markdown: the five-field handoff block + structured research briefs with known field names.

## Key Entities

- [[Superpowers Plugin]]: sibling agentic skills framework by Jesse Vincent. Shares philosophical spine with claude-workflow (gating, artifacts, subagents). Differs in auto-activation vs. explicit phase invocation, and in TDD enforcement.
- [[Microsoft Agent Framework]]: enterprise handoff pattern with runtime-routed typed edges. claude-workflow is a simpler static DAG cousin with user approval gates.

## Key Concepts

- [[multiskill-workflow-patterns]]: linear / branch / loop / parallel + Claude-as-orchestrator
- [[agent-handoff-artifact-pattern]]: durable artifact between phases; fresh session per phase; two stores (issue body / NOTES.md) with promotion rule
- [[seed-brief-pattern]]: upstream research seeds downstream specialists; specialists skip own research when brief is provided
- [[hierarchical-agent-decomposition]]: parent → feature leads → specialists; TeamCreate required for two levels
- [[claude-workflow-phase-shape]]: the applied synthesis — concrete discovery/define/implement team shapes

## Contradictions

- **Claude-as-orchestrator vs. sub-skill pattern**: [[MindStudio Skill Collaboration Pattern]] recommends Claude-as-orchestrator as the default. claude-workflow uses the sub-skill pattern at phase boundaries (e.g., `/discovery` calls `/describe` + `/specify` as specialists). Resolution: sub-skill is an intentional choice where gating must be enforced; Claude-as-orchestrator remains the default for ad-hoc composition.

- **TeamCreate vs. classic subagents**: [[ClaudeFast Agent Teams Guide]] notes TeamCreate is experimental and needs `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. claude-workflow's two-level team nesting requires TeamCreate — so classic subagent deployment would break the current hierarchy. Resolution: claude-workflow implicitly requires the experimental flag; this should be documented more explicitly in README.

## Open Questions

- ~~**Is `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` documented as a prerequisite?**~~ CLOSED by PR #14 (issue #13): documented in README.md, CLAUDE.md, and `_shared/composition.md`.
- ~~**Do skills need explicit `## Input` sections for seed briefs?**~~ CLOSED by PR #14 (issue #13): `skills/specify/SKILL.md` and `skills/design/SKILL.md` now document optional prior-art and research briefs. `_shared/composition.md` defines all three brief types canonically.
- **Is there a plan vs. architectural-decision tension** between the two-level team hierarchy and the single-agent-default rule? Both are CLAUDE.md rules; phase skills violate the default because their work is genuinely parallelizable. Worth reviewing whether the rule should be scoped to build-phase skills explicitly.
- **How does auto-compaction interact with deeply nested teams?** The 25K re-attachment budget is shared across invoked skills — a deep hierarchy may exhaust it. Untested.
- **Does fresh-session-between-phases actually happen in practice?** The skill tells the user to start a new session; there's no hard enforcement. Worth instrumenting.

## Sources

- [[MindStudio Skill Collaboration Pattern]]: MindStudio, 2026-03 — Claude-as-orchestrator framing and four-pattern taxonomy
- [[Beam Multi-Agent Orchestration Patterns]]: Beam.ai, 2026 — production failure modes and framework comparisons
- [[Microsoft Agent Framework Handoff Workflows]]: Microsoft Learn, 2026 — official Handoff orchestration docs
- [[Addy Osmani Code Agent Orchestra]]: Addy Osmani, 2026 — Princeton NLP single-agent finding; hierarchical decomposition
- [[ClaudeFast Agent Teams Guide]]: ClaudeFast, 2026 — subagents vs. TeamCreate; artifact handoff
- [[Superpowers GitHub]]: Jesse Vincent / obra, 2025-10 — sibling framework with TDD gates
