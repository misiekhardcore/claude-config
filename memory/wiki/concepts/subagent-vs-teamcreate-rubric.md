---
name: Subagent vs TeamCreate Decision Rubric
description: Applied decision framework for choosing between Task-tool subagents, TeamCreate agent teams, inline single-agent, and /batch. Replaces the vague "3+ independent files" heuristic with empirically-grounded criteria.
type: concept
tags: [claude-code, agent-teams, subagents, decision-framework, claude-workflow]
status: current
created: 2026-04-22
updated: 2026-04-22
confidence: INFERRED
evidence:
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-sub-agents-docs]]"
  - "[[google-deepmind-scaling-agent-systems]]"
uses:
  - "[[subagent-spawn-mechanics]]"
  - "[[teamcreate-architecture]]"
  - "[[agent-scaling-empirical-evidence]]"
related:
  - "[[subagent-spawn-mechanics]]"
  - "[[teamcreate-architecture]]"
  - "[[agent-scaling-empirical-evidence]]"
  - "[[multiskill-workflow-patterns]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[hierarchical-agent-decomposition]]"
sources:
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-sub-agents-docs]]"
  - "[[claude-code-costs-docs]]"
  - "[[charles-jones-agent-teams-when-beat-subagents]]"
  - "[[mindstudio-agent-teams-vs-subagents]]"
  - "[[google-deepmind-scaling-agent-systems]]"
---

# Subagent vs TeamCreate Decision Rubric

The question "which parallelism primitive should I use?" has four answers, not two. This page lays out concrete criteria for each, grounded in [[agent-scaling-empirical-evidence]].

## The Four Options

| Primitive | What it is | Cost ratio (vs single session) | Flag required |
|---|---|---|---|
| **Single session (inline)** | No delegation. Main agent does it all. | 1× | None |
| **Subagent (Task tool)** | One-shot disposable worker. Returns one message. | ≈ 1× per spawn (+1× parent accumulation per spawn) | None |
| **`/batch` or worktrees** | Independent Claude Code sessions, worktree-isolated. | N× (full session per item) | None |
| **Agent Teams (TeamCreate)** | Long-lived peer teammates with mailbox + shared task list. | **~7×** (plan mode; official Anthropic figure) | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` |

## Decision Criteria

### Pick **single session** when
- Work fits in the main agent's context without flooding it.
- Task is sequential / tightly coupled.
- Quick fix, focused question, or single-file change.
- Deep cross-cutting reasoning (the chain would break across agents).
- *Default.* Anthropic's official advice: "For routine tasks, a single session is more cost-effective."

### Pick **subagents** when
- A side task would flood the main conversation (logs, large file contents, verbose tool output you won't reference again).
- You want **context isolation** — the work stays in the subagent, only a summary returns.
- Work is bounded, with no need for the subagent to communicate with other subagents.
- You can route to a cheaper model (`model: haiku`) for cost savings.
- Parallelism is a bonus, not the goal. Up to ~10 subagents can run concurrently.

### Pick **agent teams (TeamCreate)** when
- Workers **genuinely need to talk to each other** mid-task. This is the primary differentiator.
- 3+ long-lived parallel workstreams that coordinate (e.g. frontend/backend/tests).
- Adversarial debate or hypothesis testing where peers challenge each other.
- Multi-module feature where teammates own disjoint file sets and synchronize via mailbox.
- You can absorb the **~7× token premium** (Anthropic official).
- Team size target: **3–5 teammates**, 5–6 tasks per teammate.

### Pick **`/batch` or manual worktrees** when
- Independent parallelizable edits that don't need coordination at all.
- Each item produces a commit or PR — fully self-contained.
- You want worktree isolation (no file conflicts possible).
- Cheaper than TeamCreate because no mailbox/task-list overhead.

## Quick-Reference Flowchart

```
Does the work need cross-worker communication mid-task?
│
├── YES ──► Agent Teams (TeamCreate)
│
└── NO
    │
    Can the main session handle it without context bloat?
    │
    ├── YES ──► Single session (inline)
    │
    └── NO
        │
        Is each item self-contained enough to end in a commit/PR?
        │
        ├── YES ──► /batch or manual worktrees
        │
        └── NO ──► Subagent (context isolation + summary return)
```

## Empirically-Grounded Thresholds

Replace "3+ independent files" in `_shared/composition.md` with:

- **≥ 3 independent subtasks** (ideally 5+, to match 3 teammates × 5-6 tasks).
- **Genuine file disjointness** — no two agents touch the same file. Else expect merge conflicts.
- **Clear synthesis step** — a final aggregation adds value. Without this, parallel work is wasted.
- **Task is classifiably parallel**, not sequential. Sequential tasks degrade by up to 70% under MAS ([[google-deepmind-scaling-agent-systems]]).
- **Expected wall-clock payoff ≥ 3×** to justify the ~7× token premium. Below that, use sequential subagents.

## Antipatterns (From Official Docs + Empirical Work)

1. **Reflexive team spawning for any "complex" task** — Anthropic's own guidance is that a single session is more cost-effective for routine tasks; MAS pays off only on genuinely parallelizable work. (The often-cited Princeton NLP "64% of benchmarks" figure is [unverified](../questions/princeton-nlp-64-percent-unverified.md) — see [[princeton-nlp-64-percent-unverified]].)
2. **Deep cross-cutting refactors in a team** — the logic chain breaks across teammates.
3. **Same-file edits in parallel** — no worktree isolation between subagents; teammates can clobber each other without explicit ownership.
4. **Leaving teams running unattended** — idle teammates continue consuming tokens.
5. **Using broadcast messaging** — scales as O(N), explicitly flagged as costly by Anthropic.
6. **Ignoring the experimental-flag requirement** — fail closed to sequential or subagents when the flag isn't set.

## Applied to `claude-workflow` Scope Classes

Mapping the existing `_shared/composition.md` scope taxonomy onto these primitives:

| Scope | Primitive | Rationale |
|---|---|---|
| **Lightweight** (single file, no unknowns) | Single session | Coordination overhead > benefit |
| **Standard** (multi-file, some unknowns) | Subagents for bounded specialist tasks (review, verify) | Context isolation, no cross-talk needed |
| **Deep** (cross-module, architecture-changing) | TeamCreate **only if** specialists need to coordinate | Otherwise subagents in hierarchical decomposition |
| **Research sweep** (parallel exploration) | Multiple Explore subagents | Fast, independent, no cross-talk |
| **Adversarial review** (debate) | TeamCreate | Mailbox is the value |

## What Issue #30 Should Add to composition.md

Based on this research:
1. **Cite the verified 7× multiplier** with the official Anthropic URL.
2. **Reframe escalation as cost escalation** — Lightweight → Standard → Deep is not only a complexity gradient but a ~1× → ~2× → ~7× cost gradient.
3. **Add the "need cross-worker communication" pivot question** — this is the primary differentiator per official docs.
4. **Quantify the wall-clock / token tradeoff** — parallelism buys wall-clock, not tokens; the critical path bounds the gain.
5. **Link to this rubric** and [[agent-scaling-empirical-evidence]] for the empirical basis.

## Related

- [[subagent-spawn-mechanics]] — what loads into a subagent
- [[teamcreate-architecture]] — what loads into a teammate, operational model
- [[agent-scaling-empirical-evidence]] — the numbers behind the thresholds
- [[multiskill-workflow-patterns]] — the four composition shapes (linear/branch/loop/parallel)
- [[claude-workflow-phase-shape]] — applied pattern in the orchestrator plugin
- [[hierarchical-agent-decomposition]] — why subagent depth limit forces specific shapes
