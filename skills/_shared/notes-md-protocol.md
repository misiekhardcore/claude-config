# NOTES.md — Living Worklog Protocol

Used by `/build` (primary), `/implement` (resume awareness), and `/wrap-up` (harvest) to maintain a durable in-phase scratchpad. The purpose is to survive **unexpected** session close mid-phase, when `/wrap-up` has not run and the issue was last touched at phase start.

This file is reference material — read it on demand when a skill creates, updates, or harvests NOTES.md. Do not preload.

## Location and lifecycle

- **Path:** `<worktree-root>/NOTES.md`. One per worktree, one per feature.
- **Created by `/build`** at the start of the phase, immediately after `git worktree add`.
- **Updated by `/build`** after each completed task, each significant decision, and before any proactive `/compact`.
- **Read on resume** by `/build` and `/implement` — before re-reading the issue.
- **Harvested by `/wrap-up`** into the GitHub issue comment on clean exit.
- **Left in place** after the phase ends. The next session resuming the same worktree should read it. It is cleaned up only when the worktree is removed (`wt remove`).
- **Not committed to git.** Listed in `.gitignore` at the repo root.

## Required sections

NOTES.md is a bullet list, not prose. Keep the whole file readable in one screen.

```markdown
# NOTES — feat/<feature-slug>

## Current task
- <the one thing you are working on right now>

## Task list
- [x] <done task>
- [>] <in-progress task>
- [ ] <pending task>
- [!] <blocked task — with reason>

## Decisions made this session
- <one-line decision> (why: <rationale>)
- ...

## Open questions
- <question that needs the user or next phase to resolve>

## Next action on resume
- <exact command or file to open if the session dies>
```

## Update cadence

Update NOTES.md at these points (it is fast — bullet-level only):

- **After each completed task** — flip the checkbox, log any decision that resulted from completing it.
- **After each significant decision** — one line, with rationale.
- **Before every proactive `/compact`** — flush the working set into NOTES.md *first*, so the preservation note can afford to be terse.
- **Before ending the session normally** — `/wrap-up` will harvest it.

Do **not** update it for trivial moves (opening a file, running a test command). It is a checkpoint log, not a transcript.

## Resume protocol

On a fresh session in an existing worktree:

1. Read `./NOTES.md` first.
2. Read the GitHub issue second (for acceptance criteria, constraints, and decisions from prior phases).
3. Resume from **Next action on resume** — or, if that field is stale, from the first unchecked item in the Task list.
4. Before your first real action, update NOTES.md's **Current task** and **Next action on resume** to reflect the new session.

## Rules

- **NOTES.md is authoritative for in-flight state.** If your recall disagrees with it, trust the file.
- **Bullet-only. No prose.** The whole file should cost <1k tokens to re-read.
- **Never commit it.** Add to `.gitignore` if not already there.
- **Never delete it automatically.** The owning session may archive it on clean exit; do not remove it from within a running phase.
- **Complement to `TodoWrite`, not replacement.** `TodoWrite` is in-session task tracking for the current agent; NOTES.md is cross-session durable state for any agent (or human) resuming. Mirror significant state changes from `TodoWrite` into NOTES.md.

## Why

Rules 1–4 from `.claude/docs/solutions/workflow-context-compacting.md` cover phase *boundaries* (via the GitHub issue) and sub-agent *isolation*. NOTES.md fills the remaining gap: a session that dies mid-build, before `/wrap-up` runs, must still be recoverable. A gitignored worktree-local worklog is the cheapest durable answer — the same pattern used by Anthropic's research harness (external memory files), Aider (`.aider.chat.md`), and OpenHands/Cursor scratchpads.
