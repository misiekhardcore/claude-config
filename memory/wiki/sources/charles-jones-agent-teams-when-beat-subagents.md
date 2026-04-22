---
type: source
title: "Agent Teams Just Shipped in Claude Code. Here's When They Beat Subagents."
source_type: blog
author: Charles Jones
date_published: 2026-02
url: https://charlesjones.dev/blog/claude-code-agent-teams-vs-subagents-parallel-development
source_reliability: medium
accessed: 2026-04-22
tags:
  - claude-code
  - agent-teams
  - subagents
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "A 3-teammate team uses roughly 3-4x the tokens of a single session doing the same work sequentially, but time savings justify the cost"
  - "If worker A discovers something B needs, subagent pattern forces A to report back and relaunch B — teams eliminate this bottleneck"
  - "Sequential tasks, same-file edits, or tight dependencies: subagents/single-session are more cost-effective"
  - "/batch is a simpler alternative for independent parallelizable changes that don't need coordination"
related:
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[teamcreate-architecture]]"
---

# Charles Jones — When Agent Teams Beat Subagents

Practitioner post from shortly after the Feb 2026 TeamCreate release.

## Summary

Focused decision rubric: when the mailbox/task-list coordination in teams provides value that subagents cannot match. The core argument: subagents can't share findings mid-task; the main agent becomes a bottleneck.

## Key Contributions

1. **Cost model**: 3-teammate team ≈ 3-4× single-session tokens (conservative vs Anthropic's 7× figure; likely reflects non-plan-mode usage and focused spawn prompts).
2. **Communication bottleneck**: in the subagent pattern, worker A discovering something B needs must report back to the parent, which then relaunches B with the new context — a serialization point. In teams, A and B talk directly via mailbox.
3. **Interdependence as the tiebreaker**: if workers are independent, subagents are the right choice. If they need cross-talk mid-task, teams are the right choice.
4. **Alternatives named**: `/batch` for independent parallel edits (worktree-isolated), manual parallel sessions via git worktrees for full independence.

## Direct Quote

> Rule of thumb: if agents don't need to talk to each other, use subagents. If they need to share a task queue, send each other findings, or coordinate across separate sessions, use teams.

## Scenario Examples Called Out

**Teams win:**
- Frontend developer writes UI components; backend developer creates API endpoints; tester writes integration tests — all need to know what the others are building in real time.

**Subagents win:**
- Independent research probes across unrelated docs.
- Parallel linting of disjoint file sets.
- Code reviews where each reviewer applies a different lens and findings are synthesized at the end.

## Caveats

Blog source. Cost figures (3-4×) differ from Anthropic's 7× — treat as the lower bound for disciplined use, with 7× as the realistic ceiling when teammates run in plan mode.
