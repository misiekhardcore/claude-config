# CLAUDE.md

## Behavior rules

1. Don’t assume. Don’t hide confusion. Surface tradeoffs.
2. Minimum code that solves the problem. Nothing speculative.
3. Touch only what you must. Clean up only your own mess.
4. Define success criteria. Loop until verified.

## Implementation Rules

- **Always read files before editing.**
- **Check existing memory.** Auto-memory is loaded by the harness automatically. For vault context, use the `/query` skill early in any task that might benefit from prior knowledge (prior decisions, research, project state). Skip for pure coding questions with no prior context dependency.
- **Delegate** to subagents (Task tool) for side tasks that would flood context. `TeamCreate` only when workers need to communicate mid-task — ~7× token cost (per Anthropic /en/costs).
- **Just-in-time over preloading.** Read reference docs only when the task needs them.
- **Use the cheapest viable model.**
- During open-ended exploration: time-box codebase reading to 3–5 tool calls, then ask a focused question.
- When implementing across many files: factor shared content into a single source before writing any file; post-hoc deduplication is the failure mode.

## Conversation Rules

- Avoid ambiguous abbreviations; spell out a term when it may be unclear.
- Sort items alphabetically when producing, editing or working on lists.
- Use information-dense sentences without fillers; no preamble.
- Use plain language that is easy to understand.

## Repository Awareness

- After a `cd`, treat parallel or background Bash calls as having stale CWD — re-pass the path or re-`cd` inside each call.
- At the start of a session or task spanning repos/worktrees, run `pwd && git branch --show-current && git remote -v && git worktree list`; name the target repo/worktree for each upcoming action.
- Verify the target repo before any `gh` mutation: run `git remote -v` and `pwd`, and pass `--repo owner/name` explicitly when working across clones. When the user says "this repo", confirm with the same commands.
- When delegating a worktree task to a sub-agent (Agent tool) or parallel Bash call, pass an absolute target path; the sub-agent's first action is `cd <path> && pwd`, and verified CWD is echoed in its report.
- When dispatching a sub-agent for bulk search, include in the prompt: bulk findings with count > 10 must include ≥3 verbatim sample matches. Reject or re-prompt results that omit them.

## GitHub Authoring

The descriptions should be easy to understand by a reviewer who is not familiar with the topic. Focus on behavior instead of technical details.

## Scope Discipline

- Don't add backwards-compatibility shims, dual-format support, or migration paths unless asked. Do rewrite the affected call sites cleanly when they're already in the diff.
- Don't bump versions, rename credentials, or edit configuration values beyond the literal request. Flag and ask before touching adjacent state.
- Don't ship stretch goals or speculative features in PRs. Do scope PRs to the explicit request only.
- Follow DRY, SOLID and KISS principles.
- Before writing any doc or multi-file deliverable longer than ~30 lines, write a one-line target length and a 3-bullet outline to `NOTES.md` (create it if not present). If the draft exceeds the target by more than 50%, stop and compact before continuing.
- For audit or refactor work: enumerate all candidate files matching the criterion before proposing scope; never narrow scope before the full list is in hand.
- When rebasing or migrating, only carry over the files explicitly in scope; flag unrelated files rather than silently including them.

## Documentation Hygiene

- Before editing CLAUDE.md or other docs, grep existing docs to avoid duplication. Prefer extracting long rule/schema blocks into dedicated reference files and linking from CLAUDE.md. Build Claude configuration modularly (no monoblocks).
- Write for external users (no personal paths, internal vault refs, or assumed local plugins). Link official Anthropic docs; one sentence plus a link is enough context.

## Compact instructions

When compacting, preserve: test output, code changes, explicit architectural decisions, open questions, failing assertions. Drop: tool-call transcripts, file-read echoes, intermediate exploration.
