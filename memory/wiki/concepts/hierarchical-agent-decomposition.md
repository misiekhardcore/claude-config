---
name: Hierarchical agent decomposition
description: Parent orchestrator spawns a few feature leads; each lead spawns its own specialists. Keeps parent context clean and avoids subagent-depth limits.
type: concept
tags: [claude-code, skills, orchestration, claude-workflow]
status: current
updated: 2026-04-19
created: 2026-04-19
updated: 2026-04-20
confidence: INFERRED
evidence: []
uses:
  - "[[multiskill-workflow-patterns]]"
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[seed-brief-pattern]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[claude-workflow-phase-shape]]"
---

# Hierarchical Agent Decomposition

For workflows that decompose into many specialists, a flat spawn (orchestrator fires off all N) fragments the orchestrator's context. The alternative: the orchestrator spawns 2-3 **feature leads**, each of which spawns its own specialists. The parent only talks to the leads.

## Shape

```
Flat (fragments parent context):
    Orchestrator
    ├── Specialist A
    ├── Specialist B
    ├── Specialist C
    ├── Specialist D
    ├── Specialist E
    └── Specialist F

Hierarchical (keeps parent context clean):
    Orchestrator
    ├── Feature Lead X
    │   ├── Specialist A
    │   ├── Specialist B
    │   └── Specialist C
    └── Feature Lead Y
        ├── Specialist D
        ├── Specialist E
        └── Specialist F
```

The parent receives two structured results (from X and Y) instead of six, keeping context clean (Source: [[Addy Osmani Code Agent Orchestra]]).

## How It Maps to `claude-workflow`

`/discovery` (Standard mode) is structured this way:

- **Top level**: `/discovery` spawns a team (describe specialist, specify specialist, Prior-Art Scout)
- **Inside `/describe`**: another team spawns (problem analyst, domain researcher, failure-mode analyst)
- **Inside `/specify`**: another team spawns (happy-path analyst, edge-case analyst)

The orchestrator at `/discovery` never sees the inner-team specialists. It sees the outputs of describe and specify — two summarized results — plus the Prior-Art Scout brief.

## Hard Constraint: Subagents Cannot Spawn Subagents

Anthropic's docs state this limit explicitly (Source: [[ClaudeFast Agent Teams Guide]]). This shapes hierarchical design:

- **Classic subagents** via `Agent()` are one level deep. A subagent cannot spawn another subagent.
- **TeamCreate** (experimental, gated by `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) removes this limit — teammates are session-level, can call each other, and can run with `TeamCreate` themselves.

`claude-workflow` uses TeamCreate for exactly this reason: the phase skills need to spawn specialists that themselves spawn sub-specialists. Without TeamCreate, the hierarchy would be capped at two levels and `/describe`'s internal team would not be possible from within `/discovery`.

## Feature Lead Brief Shape

Each feature lead receives:

1. **The portion of the overall goal assigned to it** — "Build the search feature" (Source: [[Addy Osmani Code Agent Orchestra]]).
2. **A seed brief** from the orchestrator — upstream research, prior decisions. See [[seed-brief-pattern]].
3. **Boundaries** — what files/modules it owns, what's out of scope. Prevents merge conflicts between leads (Source: [[ClaudeFast Agent Teams Guide]]).

Each feature lead decomposes autonomously. The orchestrator does not prescribe the specialist list — that's the lead's responsibility based on the brief.

## When NOT to Hierarchize

- **< 4 specialists total**: flat is simpler. The context fragmentation isn't a problem yet.
- **Specialists are tightly coupled**: if A and B must talk constantly, putting them under separate leads introduces transfer cost.
- **You don't have TeamCreate**: with classic subagents, you hit the depth limit.

## Observability Caveat

The deeper the hierarchy, the harder to debug. Instrument all handoffs; log which lead received which brief and what each specialist returned. The Azure guide calls this out: troubleshooting distributed agents is a core CS challenge, and it gets worse with depth (Source: [[Microsoft Agent Framework]]).

## Related

- [[multiskill-workflow-patterns]] — hierarchical is a shape within the Parallel pattern
- [[seed-brief-pattern]] — the mechanism for passing context down levels
- [[agent-handoff-artifact-pattern]] — cross-phase handoff, orthogonal to hierarchy depth
- [[claude-workflow-phase-shape]] — specific hierarchy in this repo
