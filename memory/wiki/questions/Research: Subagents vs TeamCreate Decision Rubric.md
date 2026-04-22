---
type: synthesis
title: "Research: Subagents vs TeamCreate Decision Rubric"
created: 2026-04-22
updated: 2026-04-22
tags:
  - research
  - claude-code
  - agent-teams
  - subagents
  - claude-workflow
status: current
confidence: INFERRED
evidence: []
related:
  - "[[subagent-spawn-mechanics]]"
  - "[[teamcreate-architecture]]"
  - "[[agent-scaling-empirical-evidence]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-sub-agents-docs]]"
  - "[[claude-code-costs-docs]]"
  - "[[charles-jones-agent-teams-when-beat-subagents]]"
  - "[[mindstudio-agent-teams-vs-subagents]]"
  - "[[google-deepmind-scaling-agent-systems]]"
  - "[[multiskill-workflow-patterns]]"
  - "[[claude-workflow-phase-shape]]"
sources:
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-sub-agents-docs]]"
  - "[[claude-code-costs-docs]]"
  - "[[google-deepmind-scaling-agent-systems]]"
  - "[[charles-jones-agent-teams-when-beat-subagents]]"
  - "[[mindstudio-agent-teams-vs-subagents]]"
  - "[[Addy Osmani Code Agent Orchestra]]"
  - "[[ClaudeFast Agent Teams Guide]]"
---

# Research: Subagents vs TeamCreate Decision Rubric

Triggered by misiekhardcore/claude-workflow issue #30 (cite 7× team cost multiplier in `_shared/composition.md`) and the broader question: when should claude-workflow orchestrators spawn a TeamCreate vs a sequential subagent vs a single session?

## Overview

Claude Code offers four primitives for parallelism: single session (inline), subagents (Task tool), agent teams (TeamCreate), and `/batch`-or-worktrees. The official docs and empirical research converge on a task-shape-based decision: **MAS helps parallelizable tasks and actively hurts sequential ones (up to −70%).** The cost curve escalates sharply from subagents (~1× per spawn) to agent teams (~7× per Anthropic's official figure). The primary pivot question between subagents and teams is not scope size but **whether workers need to communicate mid-task.**

## Key Findings

1. **The 7× multiplier is official and verified.** Anthropic's `/en/costs` page states: "Agent teams use approximately 7x more tokens than standard sessions when teammates run in plan mode, because each teammate maintains its own context window and runs as a separate Claude instance." (Source: [[claude-code-costs-docs]])

2. **Each TeamCreate teammate loads the full project context.** Official Anthropic quote: "Each teammate has its own context window. When spawned, a teammate loads the same project context as a regular session: CLAUDE.md, MCP servers, and skills." Lead's conversation history does NOT carry over. (Source: [[claude-code-agent-teams-docs]])

3. **Subagents start fresh except for two built-in types.** `general-purpose` and `Plan` inherit full parent context; `Explore` and custom subagents start fresh with only the prompt string crossing. Only the final message returns to the parent. (Source: [[claude-code-sub-agents-docs]], [[subagent-spawn-mechanics]])

4. **The primary subagent-vs-team pivot is communication.** Anthropic's comparison table: "Use subagents when you need quick, focused workers that report back. Use agent teams when teammates need to share findings, challenge each other, and coordinate on their own." This is the single most important criterion. (Source: [[claude-code-agent-teams-docs]])

5. **Sequential tasks degrade dramatically under MAS.** Google DeepMind's 180-configuration study: "every multi-agent variant tested degraded performance by up to 70%" on sequential reasoning. A secondary-source figure attributed to Princeton NLP ("single agent matches MAS on 64% of benchmarks at half cost") is often cited as additional support but its primary Princeton paper has not been located — see [[princeton-nlp-64-percent-unverified]]. (Source: [[google-deepmind-scaling-agent-systems]], [[Addy Osmani Code Agent Orchestra]])

6. **Parallelism buys wall-clock, not tokens.** Measured example: 4 parallel Explore subagents finished in 3:40 vs 14:00 sequentially (3.8×). Token cost scales roughly linearly with parallelism; the critical path — not aggregate compute — bounds latency. (Source: [[agent-scaling-empirical-evidence]])

7. **Team size sweet spot: 3–5 teammates.** Anthropic official guidance: start with 3–5 teammates, 5–6 tasks each. Practitioner consensus: beyond ~6 agents, merge complexity eats the gains. (Source: [[claude-code-agent-teams-docs]], [[agent-scaling-empirical-evidence]])

8. **Error amplification is quantifiable.** Independent parallel agents without an orchestrator amplify errors **17×**; centralized orchestrator reduces this to **4.4×** but does not eliminate it. (Source: [[agent-scaling-empirical-evidence]])

9. **Subagent definitions as teammates silently drop `skills:` and `mcpServers:`.** Officially documented gotcha: when spawning a teammate via a subagent definition, those two frontmatter fields are ignored; teammates always load from project/user settings. (Source: [[claude-code-agent-teams-docs]])

10. **Subagents cannot spawn subagents; teammates cannot spawn teammates.** Both depth-limits are hard constraints. TeamCreate allows two-level hierarchies via `/discovery → /describe` pattern because the phase orchestrator itself is the lead, but teammates can't create sub-teams. (Source: [[subagent-spawn-mechanics]], [[teamcreate-architecture]])

## Decision Rubric (Headline)

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

Empirically-grounded thresholds for TeamCreate:
- ≥ 3 independent subtasks
- Genuine file disjointness (no two agents touch the same file)
- Clear synthesis step at the end
- Task is classifiably parallel, not sequential
- Expected wall-clock payoff ≥ 3× (to justify the ~7× token premium)

Full rubric at [[subagent-vs-teamcreate-rubric]].

## Answer to Issue #30

Add a "Cost multiplier" subsection to `_shared/composition.md` citing the ~7× Anthropic figure, and reframe the Lightweight → Standard → Deep scope classes as a cost escalation (~1× → ~2× → ~7×). The decision should not be based on "3+ independent files" alone — add the **communication pivot question** ("do workers need to share findings mid-task?"), the wall-clock-vs-token framing, and a link to [[subagent-vs-teamcreate-rubric]] for the full criteria.

Specifically propose:
1. Verified quote from `https://code.claude.com/docs/en/costs` pinning the ~7×.
2. Breakdown of what each teammate loads (CLAUDE.md + MCP + skills + spawn prompt) so readers understand where the tokens go.
3. Empirical basis (Google DeepMind up to −70% on sequential; Anthropic's own "single session is more cost-effective" guidance; the Princeton NLP 64% figure is unverified and should be flagged accordingly — see [[princeton-nlp-64-percent-unverified]]).
4. Explicit failure modes: sequential work, same-file edits, small tasks, broadcast messaging.
5. Cross-link from discovery/define/implement/build orchestrator skills that actually decide team-vs-subagent.

## Key Entities

- **TeamCreate** — experimental tool gated by `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, requires Claude Code v2.1.32+, spawns long-lived peer teammates with shared mailbox.
- **Task tool** — spawns one-shot subagents; no inter-subagent communication; context isolation is the value.
- **Team Lead** — fixed for the lifetime of the team; coordinates via SendMessage and shared task list.

## Key Concepts

- [[subagent-spawn-mechanics]] — what loads at Task-tool spawn, what crosses the boundary
- [[teamcreate-architecture]] — lead/teammate/task-list/mailbox; what loads per teammate
- [[agent-scaling-empirical-evidence]] — Princeton NLP, Google DeepMind, practitioner measurements
- [[subagent-vs-teamcreate-rubric]] — applied decision framework

## Contradictions

- **MindStudio claims 3–5× *cheaper* per run for teams; Anthropic says 7× *more* tokens.** Reconciliation: MindStudio measures very large batches (50+ items) where subagent orchestrator accumulation (~20k per spawn) compounds; Anthropic's 7× is the per-session ratio for typical plan-mode use. Both can be true in different regimes.
- **Charles Jones cites 3–4× for teams; Anthropic cites 7×.** Reconciliation: 3–4× reflects disciplined use with focused spawn prompts and non-plan-mode teammates; 7× is the realistic ceiling when teammates run in plan mode. The claude-workflow cost guidance should cite 7× as the realistic upper bound.
- **"Start with 3–5 teammates" (Anthropic) vs "3–6 before diminishing returns" (practitioner).** Compatible: both converge on ~3–5 as the sweet spot.

## Open Questions

- **Does CLAUDE.md explicitly load into custom Task-tool subagents?** Official docs confirm it loads into teammates; subagent docs are silent on this. Assume yes based on "same base system prompt" framing, but not verified by direct quote.
- **Is there a measured subagent orchestrator accumulation cost per spawn?** MindStudio cites ~20k; Anthropic doesn't publish this figure. Worth instrumenting in a real claude-workflow session.
- **Does `/batch` integrate with agent teams, or are they mutually exclusive?** Docs reference `/batch` as an alternative but don't cover interaction.
- **Will Opus 4.6 restrictions on TeamCreate (all agents must run same model) relax to allow mixed-model teams?** Community feature request; status unknown.
- **What's the actual cleanup cost of leaving teams running?** Idle tokens are mentioned but not quantified.
- **Fork-context feature request (issue #16153 on anthropics/claude-code)** — if merged, changes the subagent cost model significantly. Track.

## Sources

- [[claude-code-agent-teams-docs]] — Anthropic, official /en/agent-teams
- [[claude-code-sub-agents-docs]] — Anthropic, official /en/sub-agents
- [[claude-code-costs-docs]] — Anthropic, official /en/costs (verified 7× quote)
- [[google-deepmind-scaling-agent-systems]] — arXiv 2512.08296, 180-config study
- [[charles-jones-agent-teams-when-beat-subagents]] — blog, practitioner decision rubric
- [[mindstudio-agent-teams-vs-subagents]] — blog, cost/failure mode framework
- [[Addy Osmani Code Agent Orchestra]] — Princeton NLP finding + hierarchical decomposition
- [[ClaudeFast Agent Teams Guide]] — TeamCreate setup, tooling, limitations (existing)
