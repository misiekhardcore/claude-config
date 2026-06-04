# CLAUDE.md

## Behavior rules

1. Don’t assume. Don’t hide confusion. Surface tradeoffs.
2. Minimum code that solves the problem. Nothing speculative.
3. Touch only what you must. Clean up only your own mess.
4. Define success criteria. Loop until verified.
5. Never ask permission before creating or updating `.claude/NOTES.md` — write it directly.

## Implementation Rules

- Before editing any file, read it first. Before modifyinf a function, grep for all callers. Research before you edit.
- **Check existing memory.** Auto-memory is loaded by the harness automatically. Access wiki early in any task that might benefit from prior knowledge (prior decisions, research, project state). Skip for pure coding questions with no prior context dependency.
- **Delegate** to subagents - breakdown tasks and dispatch sub-agents to complete them instead of doing everything in main conversation.
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
- Use `NOTES.md` as a live document to track progress, questions, decisions and next steps. Every task should have on or more entries in `NOTES.md`, and clear goals that are updated iteratively.
- For audit or refactor work: enumerate all candidate files matching the criterion before proposing scope; never narrow scope before the full list is in hand. Prefer refactoring a few files well over touching many files lightly. When in doubt, ask for clarification on scope rather than making assumptions.
- Write small, concise files instead of sprawling monoliths. If a file grows beyond ~300 lines, or mixes concerns, break it up.
- When rebasing or migrating, only carry over the files explicitly in scope; flag unrelated files rather than silently including them.

## Documentation Hygiene

- Before editing CLAUDE.md or other docs, grep existing docs to avoid duplication. Prefer extracting long rule/schema blocks into dedicated reference files and linking from CLAUDE.md. Build Claude configuration modularly (no monoblocks).
- Write for external users (no personal paths, internal vault refs, or assumed local plugins). Link official Anthropic docs; one sentence plus a link is enough context.

## Compact instructions

When compacting, preserve: test output, code changes, explicit architectural decisions, open questions, failing assertions. Drop: tool-call transcripts, file-read echoes, intermediate exploration.
