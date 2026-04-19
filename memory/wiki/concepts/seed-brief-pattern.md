---
name: Seed brief pattern
description: An upstream research team produces a structured brief that seeds downstream specialists, who skip their own research when a brief is provided
type: concept
tags: [claude-code, skills, orchestration, claude-workflow]
status: current
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[Microsoft Agent Framework]]"
---

# Seed Brief Pattern

An upstream research step produces a **structured brief** that downstream specialists read as seed context. Specialists that would otherwise run their own research phase skip it when a brief is present. The brief is an intra-phase artifact — not a cross-phase handoff.

## Shape

```
┌──────────────────┐
│ Research team    │───┐
│ (parallel agents)│   │  seed brief
└──────────────────┘   ▼
                       ┌──────────────────────┐
                       │ Specialist 1         │
                       │ (skips own research) │
                       ├──────────────────────┤
                       │ Specialist 2         │
                       │ (skips own research) │
                       └──────────────────────┘
```

The brief is passed by reference through the orchestrating skill's context, not by re-invocation.

## Example: `/define` → `/architecture` in `claude-workflow`

`/define` dispatches a research team (codebase + patterns/learnings) **before** the architecture/design specialists. The brief feeds both specialists as seed context:

> Pass the research brief as input — the Architecture specialist skips its own research phase when a research brief is provided.
> — `skills/define/SKILL.md:25-27`

`/architecture` has its own nested research team internally, but when invoked from `/define` it skips that phase and uses the seed brief instead. This:

- Avoids duplicated research (the same codebase scanned twice)
- Lets both architecture and design work from the **same** brief (consistency)
- Runs research in parallel with other specialist setup, not sequentially before it

## Example: `/discovery` Prior-Art Scout (recent addition)

Parallel pattern at the discovery phase: a Prior-Art Scout runs at the discovery team level, gathering institutional memory (vault → past issues/PRs → docs). Its brief seeds `/describe` and `/specify`. `/describe` skips its own prior-art search when a brief is provided. See the hoisting decision in `skills/discovery/SKILL.md` and the paired edit in `skills/describe/SKILL.md`.

## Contract Requirements

For the seed-brief contract to work:

1. **The specialist skill must have a documented `## Input` section** describing what a brief looks like and how to incorporate it.
2. **The brief must have a known shape** — fields, ordering, vocabulary. For claude-workflow:
   - Research brief: `Technology stack`, `Module structure`, `Related implementations`, `Naming conventions`, `Existing patterns`, `Prior decisions`, `External references`.
   - Prior-art brief: `Prior decisions`, `Prior attempts and outcomes`, `Related open/closed issues`, `Relevant patterns`.
3. **The orchestrating skill must document that it passes the brief** — e.g., "seeded with research output".

Without these three, the specialist can't tell whether a brief is present or what to do with it.

## Why Not Just Pass More Context?

The alternative — dumping all research output into the specialist's prompt — breaks three ways:

- **Noise**: the specialist re-derives what it needs from raw data on every run
- **Inconsistency**: two specialists may interpret the same data differently
- **Token cost**: the same facts are re-tokenized per specialist

A brief is pre-synthesized: the interpretation is fixed upstream and each specialist reads a small, consistent artifact.

## When NOT to Use

- **Single downstream consumer**: if only one specialist reads the brief, the research can live inside that specialist. Seed-brief is worth it when two or more specialists share the input.
- **Specialist has fundamentally different research needs**: a Security Reviewer and an Architect may both need research, but if their queries have zero overlap, separate researchers scoped to each specialist is simpler.
- **Lightweight workflows**: `/discovery`'s Lightweight mode skips the scout entirely. Don't pay for a brief that's not worth gathering.

## Related

- [[multiskill-workflow-patterns]] — seed-brief is a composition move inside the Parallel or Linear patterns
- [[agent-handoff-artifact-pattern]] — cross-phase version of the same idea
- [[hierarchical-agent-decomposition]] — briefs are how parent levels hand down context
- [[Microsoft Agent Framework]] — triage agent carries initial brief to specialists
