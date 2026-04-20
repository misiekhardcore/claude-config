---
name: Superpowers GitHub
description: obra/superpowers GitHub repository — complete agentic skills framework with structured dev methodology, TDD enforcement, subagent-driven execution
type: source
source_type: github-repo
author: Jesse Vincent (obra)
date_published: 2025-10
url: https://github.com/obra/superpowers
source_reliability: high
key_claims:
  - Skills auto-activate on context, not manual invocation
  - TDD enforcement via test-driven-development skill (RED-GREEN-REFACTOR)
  - Subagent-driven development with two-stage review
  - Gating philosophy — cannot build what you haven't designed
tags: [claude-code, plugin, orchestration, TDD]
status: developing
confidence: EXTRACTED
created: 2026-04-19
related:
  - "[[Superpowers Plugin]]"
  - "[[claude-workflow-phase-shape]]"
evidence: []
---

# GitHub — obra/superpowers

Source repository for the Superpowers Claude Code plugin by Jesse Vincent. Confidence: high (primary source).

## Key Claims

1. **Auto-activation model**: skills monitor context and self-activate. "The agent checks for relevant skills before any task. Mandatory workflows, not suggestions."
2. **Hard gates**: brainstorm → design spec → plan → execute. Skipping a gate fails predictably.
3. **Subagent-driven execution**: `subagent-driven-development` skill dispatches fresh subagents per task.
4. **Two-stage review** (v4.0+): spec-compliance reviewer and code-quality reviewer are distinct agents.
5. **TDD as a first-class skill** that enforces RED-GREEN-REFACTOR — makes Claude delete code written before tests.

## Relevance to claude-workflow

Sibling framework. Philosophical spine matches (structured workflow, durable artifacts, subagent-driven execution, gating). Key design differences documented in [[Superpowers Plugin]].

## Related

- [[Superpowers Plugin]] — entity page with full comparison to claude-workflow
- [[claude-workflow-phase-shape]]
