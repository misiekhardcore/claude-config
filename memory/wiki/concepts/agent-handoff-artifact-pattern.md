---
name: Agent handoff artifact pattern
description: Durable file- or issue-based artifact as the handoff mechanism between multiskill workflow phases — fresh session per phase
type: concept
tags: [claude-code, skills, orchestration, claude-workflow]
status: current
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[seed-brief-pattern]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[Microsoft Agent Framework]]"
---

# Agent Handoff Artifact Pattern

A durable artifact — a file or an issue body — is the handoff medium between phases of a multiskill workflow. The next phase reads the artifact from a fresh session; the prior session's context is not carried forward.

## Why Artifacts, Not Chat Context

Passing state through conversation context accumulates noise and hits token limits. Passing it through a durable artifact:

- Lets the next phase start in a fresh session with clean context
- Forces the handing-off phase to promote only what matters
- Makes the workflow resumable (re-read the artifact, resume)
- Makes reviews possible — the artifact is a reviewable object (Source: [[ClaudeFast Agent Teams Guide]] — each stage should complete before the next begins; output files are the handoff mechanism).

## Canonical Shape in `claude-workflow`

The **GitHub issue body** is the cross-phase artifact. Each phase updates it in place with a five-field handoff block:

1. **Acceptance criteria** — testable scenarios, unchanged from `/discovery`
2. **Constraints** — in/out scope, non-negotiable decisions
3. **Prior decisions** — "we chose X over Y because Z", one line each
4. **Evidence** — links to commits, PRs, benchmarks, design reviews
5. **Open questions** — things the next phase must resolve (explicit; never omit)

Field order is uniform across phases so any next-phase session can scan-read top to bottom. See `_shared/handoff-artifact.md` in claude-workflow for the canonical template.

## Rules

- **Update the body, not a comment.** Comments are for discussion, not state.
- **Reset after updating.** After an artifact update, instruct the user to start the next phase in a fresh session — do not invoke the next skill from within the current one.
- **For cross-phase state, the artifact wins.** If in-context recall disagrees with the artifact, trust the artifact.
- **Never include secrets.** Evidence links go to internal systems, not pasted credentials.
- **Open questions are mandatory.** Say "No open questions" explicitly — never drop the section.

## Two Stores, No Overlap

`claude-workflow` distinguishes two persistent stores:

- **Issue body**: authoritative for cross-phase state (acceptance criteria, locked architectural decisions, the five fields above).
- **`.claude/NOTES.md`**: authoritative for in-flight state within a phase (current task, intra-phase decisions not yet promoted).

At phase end, `.claude/NOTES.md` state that the next phase needs is **promoted** into the issue body (typically by `/wrap-up`). Until promotion, the issue does not know about it.

## Alternative Artifact Types

| Artifact | Use when |
|---|---|
| GitHub issue body | Cross-phase workflow with user review gates (claude-workflow) |
| Markdown file in repo (`docs/api-spec.md`) | Pipeline between subagents without user-facing phase gates (Source: [[ClaudeFast Agent Teams Guide]]) |
| JSON structured output | Skill-to-skill chaining where orchestrator makes routing decisions (Source: [[MindStudio Skill Collaboration Pattern]]) |

Use the artifact type that matches the review boundary. If humans inspect every handoff, use issue body / markdown. If only Claude reads it, structured JSON is cheaper.

## Why "Fresh Session" Matters

Subagents and fresh sessions **start without conversation history** (Source: [[ClaudeFast Agent Teams Guide]]). This is a feature:

- No bias from prior decisions, trade-offs considered, or approaches rejected
- Fresh perspective for review tasks catches what familiarity obscures
- Token budget resets — later phases don't compete with earlier phases for context

The cost: the next phase may need a moment to gather context. The artifact is what closes that gap.

## Related

- [[multiskill-workflow-patterns]] — the broader composition patterns
- [[seed-brief-pattern]] — a research brief is an intra-phase artifact
- [[claude-workflow-phase-shape]] — the concrete discovery → define → implement shape
- [[Microsoft Agent Framework]] — Handoff orchestration with explicit routing rules
