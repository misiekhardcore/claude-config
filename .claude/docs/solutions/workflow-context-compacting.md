---
problem_type: pattern
module: workflow
component: phase-handoff
symptoms:
  - context exhaustion mid-build, mid-review, or during long /discovery sessions
  - reviewer sub-agent receives bloated history and misses the point
  - /implement loses track of decisions made during /define
  - /wrap-up surfaces assumptions that were never persisted for the next phase
  - auto-compact fires near 95% and silently drops architectural decisions
root_cause: no structured context-transfer protocol between workflow phases; reliance on in-place summarization instead of reset + handoff artifact
tags:
  - workflow
  - context-management
  - handoff
  - compaction
  - sub-agents
severity: medium
date: 2026-04-14
---

# Context Compacting Between Workflow Phases

## Context

This repo runs a multi-phase workflow — `/discovery` → `/define` → `/implement` (build → review → verify) → `/wrap-up` → `/compound` → `/prune` — where each phase is typically its own conversation and hands off to the next via the GitHub issue plus the git diff. Two pressure points appear in practice:

1. **Within a phase** — a long `/build` session or a thorough `/discovery` can approach the context limit before the phase is done.
2. **Between phases** — the next phase needs to pick up assumptions, decisions, and dead-ends without inheriting the entire prior transcript.

This doc captures the guidance Anthropic and OpenAI have published for exactly these two situations, mapped onto this repo's phases.

## Guidance

Four rules. Apply them in order.

### 1. Prefer a context reset with a handoff artifact over in-place compaction

Anthropic's harness team describes the tradeoff explicitly:

> "A reset provides a clean slate, at the cost of the handoff artifact having enough state for the next agent to pick up the work cleanly. This differs from compaction, where earlier parts of the conversation are summarized in place so the same agent can keep going on a shortened history."
> — [Harness design for long-running apps, Anthropic Engineering](https://www.anthropic.com/engineering/harness-design-long-running-apps)

In this repo, the GitHub issue **is** the handoff artifact. End each phase by updating the issue with the decisions and state the next phase needs, then start the next phase in a fresh session. Do not try to carry conversation history across `/define → /implement` or `/build → /review`.

What the artifact must contain (equivalent to Anthropic's "structured handoff artifact" and OpenAI's [`input_type` handoff metadata](https://openai.github.io/openai-agents-python/handoffs/)):

- **Objectives** — acceptance criteria, unchanged from `/discovery`.
- **Constraints** — files in scope, files out of scope, non-negotiable decisions from `/define`.
- **Prior decisions** — "we chose X over Y because Z" entries, one line each.
- **Evidence** — links to the commit/PR/logs that justify each decision.
- **Open questions** — things the next phase must resolve, explicit.

OpenAI's guidance is the same shape: "Use `input_type` when the handoff needs a small piece of model-generated metadata such as reason, language, priority, or summary" — not the whole transcript ([OpenAI Agents SDK: Handoffs](https://openai.github.io/openai-agents-python/handoffs/)).

### 2. When you must compact in place, do it proactively and with preservation instructions

Inside a phase (typically `/build` or a long `/discovery`), if you cannot cleanly reset yet, compact well before the warning fires. Anthropic's description of what compaction should preserve:

> "Context compaction is implemented by passing the message history to the model to summarize and compress the most critical details, preserving architectural decisions, unresolved bugs, and implementation details while discarding redundant tool outputs or messages."
> — [Effective context engineering for AI agents, Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

And the risk of deferring it:

> "Overly aggressive compaction can result in the loss of subtle but critical context whose importance only becomes apparent later."
> — same source

Practical rules:

- Compact at ~60% utilization, not at the auto-compact threshold.
- Always pass a **preservation note** — see [Examples](#examples).
- After compacting, verify with "summarize where we are and what's next" before issuing the next tool call.
- Prefer [context editing](https://platform.claude.com/docs/en/build-with-claude/context-editing) (clear stale tool results verbatim) over re-summarization when most of the pressure is from large tool outputs. Anthropic reports "context editing enabled agents to complete workflows that would otherwise fail due to context exhaustion — while reducing token consumption by 84%" ([Managing context on the Claude Developer Platform](https://www.anthropic.com/news/context-management)).

### 3. Push exploration into sub-agents so the lead session stays small

This is the sub-agent pattern Anthropic uses for their own research harness:

> "Each subagent might explore extensively, using tens of thousands of tokens or more, but returns only a condensed, distilled summary of its work (often 1,000–2,000 tokens), achieving a clear separation of concerns where the detailed search context remains isolated within sub-agents, while the lead agent focuses on synthesizing and analyzing the results."
> — [Effective context engineering for AI agents, Anthropic](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)

In this repo:

- `/review` already follows this pattern: fresh-context reviewers receive the diff, not the build history. Keep it that way.
- Generalize it to exploration: when `/build` needs to understand an unfamiliar area of the codebase, delegate to an Explore sub-agent and ask for a ≤400-word report — do not read the files directly into the lead context.
- `/verify` should be invoked with only the acceptance criteria plus the running code, never the build transcript.

### 4. Write `/wrap-up` output into the issue before the session ends

`/wrap-up` surfaces assumptions, uncertainties, and follow-ups — but today that output stays in the conversation and is lost when the session ends. That defeats rule (1). Fix: whenever `/wrap-up` runs at a phase boundary, copy its output into the GitHub issue (or a PR comment) as the handoff artifact for the next phase. The captured content then survives the reset.

## Why

Three convergent reasons, all from first-party sources:

1. **Summarization loses detail that compaction and reset preserve.** In-place LLM summarization rewrites prior turns and can silently drop the detail that matters later. A clean reset with a structured artifact keeps the surviving content exact. Anthropic: "the art of compaction lies in the selection of what to keep versus what to discard."

2. **Sub-agent isolation is empirically effective.** Anthropic quantifies it: tens of thousands of tokens of exploration compressed into a 1–2k token report, with the lead agent reasoning over the distilled results. This is the mechanism by which `/review` and `/verify` already stay reliable in this repo.

3. **Models have gotten better at self-compaction, but not at remembering what was never written down.** Anthropic reports they dropped context resets from their harness once Opus 4.5/4.6 stopped exhibiting "context anxiety" ([Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)). The lesson is *not* "skip the artifact" — the artifact is what lets any phase (even one running on a weaker model) pick up cleanly.

## When to Use

Apply rule (1) — reset + artifact — at every phase boundary, always. No exceptions.

Apply rules (2) and (3) when any of the following trigger within a single phase:

- Context utilization crosses ~60% (proactive compaction window).
- About to read more than two large files, or search broad paths — delegate to an Explore sub-agent instead.
- About to spawn a reviewer, verifier, or architect sub-agent — pass the brief, not the transcript.
- `/wrap-up` is about to run — write its output into the issue, then reset.
- Auto-compact warning appears — stop, compact with preservation note, verify, then continue. Do not let auto-compact run unattended.

## Examples

### Structured handoff artifact (for `/define → /implement`)

Paste into the GitHub issue body or a pinned comment before resetting the session:

```markdown
## Handoff: /define → /implement

**Objectives** (from /discovery, unchanged)
- AC1: CSV export button appears on /reports for users with `reports.read`
- AC2: Export respects current filters
- AC3: File downloads within 5s for ≤50k rows

**Constraints**
- In scope: app/reports/**, app/lib/csv.ts (new)
- Out of scope: server-side streaming, S3 upload path
- Must reuse existing filter state from ReportsContext

**Prior decisions**
- Client-side generation via Papa Parse (chose over server endpoint: no infra change needed for ≤50k rows)
- Button lives in ReportsToolbar, not inside the table (consistency with Print button)
- No progress indicator in v1 (UX confirmed acceptable at 50k)

**Evidence**
- Benchmark: 50k rows → 1.4s in Chrome (see thread with @alex, 2026-04-12)
- Design review: figma.com/... (approved)

**Open questions**
- Should empty result sets download an empty file or show a toast? (defer to /build, pick one and note it)
```

This is exactly the "objectives + constraints + prior decisions + supporting evidence" shape OpenAI recommends for handoff metadata.

### Proactive `/compact` with preservation note

Run at ~60% utilization, never blindly:

```
/compact

Keep: issue #482 acceptance criteria; the ReportsToolbar component layout
decision (client-side Papa Parse); files currently in scope
(app/reports/ReportsToolbar.tsx, app/lib/csv.ts); the open question about
empty result sets.

Drop: the earlier exploration of server-side streaming (rejected); Papa
Parse API reading; the tsc output from the first failing compile.
```

Follow up with: `Summarize where we are and what the next step is.` If the summary is missing anything from the "Keep" list, restate it before continuing.

### Sub-agent brief (for `/review`)

Do not pass the build transcript. Pass the brief:

```
Review the diff on branch feat/csv-export against issue #482.

Criteria: AC1–AC3 in the issue body. Architectural decisions already locked
(client-side Papa Parse, button in ReportsToolbar) — do not re-litigate.

Report: correctness, standards, and any AC the diff fails to satisfy.
Under 500 words.
```

This matches Anthropic's sub-agent pattern: the reviewer runs in isolation, returns a distilled report, and the lead session never sees the reviewer's internal exploration.

## See Also

- `skills/compound/SKILL.md` — how learnings from a completed phase become durable solution docs (this file was written via that process).
- `skills/wrap-up/SKILL.md` — the end-of-session assumption audit; remember to persist its output per rule (4).
- `REFERENCE.md` — memory tiers and how auto-memory differs from project-checked-in solution docs.
- `CLAUDE.md` — "Check existing memory first" is what makes this doc discoverable at the start of the next phase.

## Sources

- Anthropic — [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
- Anthropic — [Harness design for long-running application development](https://www.anthropic.com/engineering/harness-design-long-running-apps)
- Anthropic — [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
- Anthropic — [Managing context on the Claude Developer Platform](https://www.anthropic.com/news/context-management)
- Anthropic — [Context editing (API docs)](https://platform.claude.com/docs/en/build-with-claude/context-editing)
- Anthropic — [Compaction (API docs)](https://platform.claude.com/docs/en/build-with-claude/compaction)
- OpenAI — [Agents SDK: Handoffs](https://openai.github.io/openai-agents-python/handoffs/)
- OpenAI — [Orchestrating Agents: Routines and Handoffs (Cookbook)](https://cookbook.openai.com/examples/orchestrating_agents)
