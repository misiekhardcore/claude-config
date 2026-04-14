# Proactive Compaction Protocol — Shared

Used by `/build` (and any other long-running phase skill) to compact in-place before context pressure causes silent losses. The rule is: compact **early**, **with a preservation note**, **then verify**.

This file is reference material — read it on demand when the skill reaches a compaction step. Do not preload.

## When to trigger

Compact proactively at any of these thresholds — whichever comes first:

- **~60% context utilization.** Not the auto-compact threshold (~95%). Proactive means you still have headroom for the preservation note and the verification step.
- **Before starting a new sub-issue or task-list item.** Natural boundary, easy to resume from.
- **Before reading 2+ large files.** Large tool outputs bloat context faster than the model's own reasoning.
- **Before spawning a reviewer/verifier/explorer sub-agent.** Sub-agents get a brief, not the transcript — so fresh context for the lead afterward is cheap.
- **When the auto-compact warning appears.** Stop immediately, run this protocol, then continue. Never let auto-compact run unattended.

## The preservation note

Always emit this before running `/compact`. Format:

```
/compact

Keep: <architectural decisions>; <current task and files in scope>;
<unresolved bugs or failing tests>; <open questions from the issue>.

Drop: <rejected alternatives>; <tool outputs already acted on>;
<API docs already internalized>; <exploration that led nowhere>.
```

**Keep** what the model can't reconstruct from the issue or `NOTES.md`. **Drop** anything large and replayable.

## Verification step

After compaction, run: `Summarize where we are and what the next step is.`

Check the summary against your Keep list. If anything from Keep is missing, **restate it explicitly before the next tool call**. If the summary looks hollow, abort and re-read the issue + `./NOTES.md` before continuing.

## Prefer context editing when appropriate

If the pressure is from large tool outputs (not conversation), prefer [context editing](https://platform.claude.com/docs/en/build-with-claude/context-editing) — clear the stale tool results verbatim — over re-summarization. Anthropic reports 84% token reduction in long-running workflows when context editing is used instead of summarization. Re-summarization forces the model to paraphrase its own reasoning, which is where silent detail loss happens.

## Rules

- **Compact before it's urgent.** 60% is the target, not the ceiling.
- **Never compact blindly.** Always emit the Keep/Drop note.
- **Always verify after compacting.** One extra turn is cheap; silent detail loss is expensive.
- **`./NOTES.md` is your backstop.** Flush the working set into it *before* compacting. If the compacted context comes back hollow, NOTES.md is how you recover.
- **Compaction is a build-time responsibility.** Do not defer it to `/wrap-up` — by then it's too late.

## Why

In-place summarization can silently drop architectural decisions that only matter three steps later. A reset with a preservation note preserves the surviving content exact. See `.claude/docs/solutions/workflow-context-compacting.md` for the full Anthropic/OpenAI guidance.
