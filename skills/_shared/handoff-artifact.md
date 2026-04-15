# Handoff Artifact — Shared Template

Used by phase-boundary skills (`/discovery`, `/define`, `/implement`, `/wrap-up`) to hand off state to the next phase. The GitHub issue is the artifact. Each phase updates it with the five fields below, then the user resets and starts the next phase in a fresh session.

This file is reference material — read it on demand when the skill reaches a handoff step. Do not preload.

## The five fields

Every handoff artifact contains:

1. **Objectives** — acceptance criteria, unchanged from `/discovery`. One line each.
2. **Constraints** — files in scope, files out of scope, non-negotiable decisions from `/define`.
3. **Prior decisions** — "we chose X over Y because Z" entries. One line each. Include links to the conversation or code that produced the decision.
4. **Evidence** — links to commits, PRs, benchmark output, design reviews, or approvals that justify each decision.
5. **Open questions** — things the next phase must resolve. Explicit — no "obvious, will figure out later".

## Shape

Post this as the issue body (new phase) or a pinned comment (mid-phase update). Keep field order consistent across phases so the next session can scan-read it.

```markdown
## Handoff: /<prev> → /<next>

**Objectives** (from /discovery, unchanged)
- AC1: ...
- AC2: ...

**Constraints**
- In scope: <paths>
- Out of scope: <paths>
- Must reuse: <existing module/util>

**Prior decisions**
- <one-line decision> (why: <rationale>)
- ...

**Evidence**
- <link to commit | PR | benchmark | design review>
- ...

**Open questions**
- <question the next phase must resolve>
- ...
```

## Precedence

Two persistent stores, no overlap:

- **The issue is authoritative for cross-phase state** — acceptance criteria, locked architectural decisions, the handoff fields below.
- **`NOTES.md` is authoritative for in-flight state within a phase** — current task, intra-phase decisions not yet promoted, working open questions. See `skills/_shared/notes-md-protocol.md`.

When a phase ends, intra-phase state from `NOTES.md` that the next phase needs is **promoted** into the issue (typically by `/wrap-up`). Until promotion, the issue does not know about it. After promotion, the issue is the source of truth for that item.

## Rules

- **Reset after posting.** Once the artifact is written, tell the user to start the next phase in a fresh session. Do not call the next skill from within the current one.
- **For cross-phase state, the issue wins.** If in-context recall disagrees with the issue, trust the issue.
- **Never include secrets.** Evidence links should point to internal systems, not paste credentials.
- **Never drop prior decisions to save space.** If the list is long, that's the workflow working — not a bug. Link to a sub-comment if scrolling is a problem.
- **Open questions are mandatory.** If there are none, say so explicitly ("No open questions") — never omit the section.

## Why this shape

The five fields map to Anthropic's "structured handoff artifact" and OpenAI's `input_type` handoff metadata pattern. Summarization in place loses detail that the next phase needs; a reset with this exact shape preserves the surviving content exact. See `.claude/docs/solutions/workflow-context-compacting.md` for the full rationale.
