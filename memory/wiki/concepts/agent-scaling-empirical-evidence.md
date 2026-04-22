---
name: Agent Scaling Empirical Evidence
description: Measured data on when multi-agent scaling pays off. Aggregates Princeton NLP, Google DeepMind, and practitioner reports on wall-clock speedup, error amplification, and diminishing returns.
type: concept
tags: [multi-agent, scaling, empirical, research, coordination-overhead]
status: current
created: 2026-04-22
updated: 2026-04-22
confidence: EXTRACTED
evidence:
  - "[[google-deepmind-scaling-agent-systems]]"
  - "[[Addy Osmani Code Agent Orchestra]]"
uses: []
related:
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[teamcreate-architecture]]"
  - "[[subagent-spawn-mechanics]]"
sources:
  - "[[google-deepmind-scaling-agent-systems]]"
  - "[[Addy Osmani Code Agent Orchestra]]"
  - "[[charles-jones-agent-teams-when-beat-subagents]]"
  - "[[mindstudio-agent-teams-vs-subagents]]"
---

# Agent Scaling Empirical Evidence

Quantitative findings from 2025–2026 research on when multi-agent (MAS) systems pay off.

## Headline Numbers

| Finding | Value | Source |
|---|---|---|
| Tasks where single-agent matches MAS | **64%** of benchmarks | Princeton NLP (via [[Addy Osmani Code Agent Orchestra]]) |
| Accuracy gain from MAS (avg) | +2.1 percentage points | Princeton NLP |
| Cost multiplier for that gain | **~2× cost** | Princeton NLP |
| Performance degradation on sequential tasks | up to **70%** | [[google-deepmind-scaling-agent-systems]] (180-config study) |
| Error amplification, independent parallel agents (no orchestrator) | **17×** | "Bag of Agents" failure-mode study |
| Error amplification, centralized orchestrator | **4.4×** | Same study |
| Typical sweet-spot team size | **3–6 agents** | Multiple practitioner reports |
| Wall-clock speedup, genuinely independent parallel work | **3.8× – 5×** | Practitioner (4 Explore subagents: 3:40 vs 14:00) |
| Subagent concurrent parallelism ceiling | **~10** | Community-observed Claude Code limit |

## Core Principle

> Multi-agent coordination dramatically improves performance on parallelizable tasks but degrades it on sequential ones. ([[google-deepmind-scaling-agent-systems]])

The task type gates the decision. Not the scope size, not the complexity — the **shape** of the decomposition. Parallel decomposable → MAS helps. Sequential dependent → MAS hurts, often severely.

## Wall-Clock vs Token Cost

Critical distinction: **wall-clock latency is governed by the critical path, not aggregate compute.**

- If a task decomposes into N independent subtasks of roughly equal duration X, parallel execution takes ≈ X + coordination overhead.
- Sequential execution takes N × X.
- Token cost is roughly the same either way (sometimes higher for parallel due to overhead).
- Conclusion: **parallel MAS buys wall-clock, not tokens.**

This is why [[teamcreate-architecture]] notes a 7× token multiplier and a 4–5× wall-clock win as simultaneously true.

## Diminishing Returns

- Beyond ~6 agents, merge complexity eats the gains (practitioner consensus).
- Google DeepMind observed a clear efficiency plateau under lightweight coordination.
- Frontier-model upgrades often eliminate the rationale for MAS entirely — if a single stronger model solves the task well, MAS is redundant.

## Failure Modes Quantified

1. **Error amplification without verification** — 17× for bag-of-agents; 4.4× even with orchestrator. An orchestrator catches but does not eliminate amplification.
2. **Sycophantic consensus** — agents tend to agree with majority position, producing confidently-wrong outputs after multiple rounds.
3. **Message-passing overhead** — explicit but serializing. Team mailbox traffic scales with N².
4. **Per-agent friction** — more messages, more latency, more drift opportunities.

## Mitigations With Measured Impact

- **Shared memory / task list** — reduces redundant work; fewer total steps, lower wall-clock.
- **Streaming partials** — synthesis starts as first shards land; **15–24% latency reduction** reported.
- **Capability saturation** — upgrade base model before adding agents; often cheaper and better.

## When Parallelism Genuinely Pays (Measured)

From practitioner data:
- 3+ independent, read-heavy or file-disjoint subtasks
- Synthesis step adds value at the end
- Research sweeps, multi-domain audits, adversarial review
- 4 parallel Explore subagents: 3:40 wall-clock vs 14:00 sequential

## When It Actively Hurts (Measured)

- Sequential dependencies (70% degradation)
- Same-file edits (merge conflicts; no isolation)
- Small tasks (delegation overhead > benefit)
- Deep cross-cutting reasoning (the logic chain breaks across agents)

## Implication for claude-workflow

The "default to single-agent" rule in claude-workflow's CLAUDE.md has empirical basis: Princeton NLP's 64% and Google DeepMind's 70%-degradation finding both argue against reflexive MAS spawning. The existing `_shared/composition.md` rule — "Never pay coordination overhead for work a single agent completes in under a minute" — aligns with this literature, though could cite specific numbers (see [[subagent-vs-teamcreate-rubric]] for the proposed update).

## Related

- [[subagent-vs-teamcreate-rubric]] — the applied decision framework
- [[teamcreate-architecture]] — the operational cost structure
- [[hierarchical-agent-decomposition]] — why depth matters
