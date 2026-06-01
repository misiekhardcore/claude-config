---
type: concept
title: Scope Assessment vs. Specialist Activation (Two-Mechanism Pattern)
tags: [claude-workflow, skill-authoring, agent-design, architecture]
status: current
confidence: EXTRACTED
evidence: []
related: []
---

# Scope Assessment vs. Specialist Activation (Two-Mechanism Pattern)

## Problem

Skills using single-axis scope labels (Lightweight/Standard/Deep) conflate two independent concerns:
1. **Team shape** — how many agents? what resource budget?
2. **Specialist activation** — which domain experts? what context triggers them?

This creates arbitrary, inconsistent labeling and couples team structure to skill logic.

## Pattern

Separate concerns into two independent mechanisms:

**1. Scope assessment** (shared tier-3 skill)
- Pure algorithm: given work-unit size and complexity, determine team tier (solo agent, small team, large team)
- Resource-conflict grouping logic (invariant across all skills)
- Input: plan/diff/AC metrics; output: tier classification

**2. Specialist activation** (per-skill tier-3 assessment skills, e.g., `*-specialist-assessment`)
- Domain-specific logic: given skill context + plan/diff, decide which expert roles are load-bearing
- Per-skill because activation signals are domain-specific (e.g., "frontend changes = need design review")
- Custom agent files in `agents/` directory (one per specialist role)

## Entry Points

Both seeded (orchestrator-invoked) and standalone entry paths converge:
- **Seeded**: orchestrator invokes sub-skill assessment → derives specialist list from context
- **Standalone**: skill invokes own assessment → derives specialist list from context
- Result: same specialist activation logic, reachable from both paths

## Implementation Notes

- `seed-brief` drops `scope_class` parameter; assessment skills derive their own specialist list
- Shared scope-assessment reused because the algorithm (team-sizing) is invariant
- Per-skill specialist-assessment exists because activation logic is load-bearing and domain-specific
- Mirrors existing scope-assessment pattern: shared algorithm tier-3 + per-caller work-unit definition
