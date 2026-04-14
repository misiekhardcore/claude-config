---
name: wrap-up
description: End-of-session assumptions audit. Surfaces assumptions, uncertain decisions, and follow-ups from the current session. Harvests ./NOTES.md and writes the audit into the active GitHub issue so it survives session reset. Use before ending long or complex sessions.
model: sonnet
---

You are performing an end-of-session audit. Review what happened in this session and surface anything the user should know before context is lost.

## Process

1. Review the conversation history and identify:
   - **Assumptions** — decisions you made based on inference rather than explicit user instruction
   - **Uncertainties** — places where you were unsure and chose one path over alternatives
   - **Scope changes** — anything you did beyond or short of what was originally asked
   - **Follow-ups** — work that remains, was deferred, or needs human verification

   If `./NOTES.md` exists in the worktree, read it first — it is the authoritative worklog for this phase. Merge its **Decisions made this session** and **Open questions** into the audit so nothing is lost on reset.

2. For each item, note:
   - What the assumption/decision was
   - Why you made that choice
   - What the alternative would have been
   - Risk level (low/medium/high) if the assumption is wrong

3. **Determine the active issue.** Check the git branch name for an issue reference, or run `gh issue list --search <branch-slug>`, or ask the user directly. The audit must be tied to a specific issue — this is the handoff artifact for the next phase. See `skills/_shared/handoff-artifact.md` for the shape.

4. **Draft the issue comment.** Produce the audit in the Output format below, wrapped in a fenced markdown block labelled for the target issue. Show the draft to the user and ask: `Post to issue #N? (y/n)`. On yes, run `gh issue comment N --body-file -` with the draft body. **Never auto-post** — wrong issue, leaked assumptions, or duplicate comments on replay all have real blast radius. Keep the fenced draft visible in the terminal even if the user declines, so they can copy it manually.

## Output

Present the audit as a fenced markdown block labelled `paste into issue #N — handoff artifact`, so the user can copy it even if they decline the auto-post prompt:

````markdown
## Wrap-up — session handoff

### Assumptions Made
- [assumption] — [why] — [risk if wrong]

### Uncertain Decisions
- [decision] — [alternatives considered] — [why this one]

### Scope Notes
- [what changed from original ask]

### Follow-ups
- [what remains or needs verification]
````

## Rules

- Be honest about uncertainty — this is a self-audit, not a sales pitch
- Include assumptions even if you are fairly confident — the user decides what matters
- If nothing significant was assumed, say so briefly and do not pad the report
- The audit is not complete until it is posted to the issue or the user has explicitly declined
- Never auto-post without user confirmation — show the draft and ask first
- After a successful post, leave `./NOTES.md` in place; the next session will read it on resume. Do not delete it automatically.
