# CLAUDE.md

## Behavior rules

1. Don’t assume. Don’t hide confusion. Surface tradeoffs.
2. Minimum code that solves the problem. Nothing speculative.
3. Touch only what you must. Clean up only your own mess.
4. Define success criteria. Loop until verified.

## Implementation Rules

- **Always read files before editing.**
- **Delegate** to subagents (Task tool) for side tasks that would flood context. `TeamCreate` only when workers need to communicate mid-task — ~7× token cost (per Anthropic /en/costs).
- **Use the cheapest viable model.**
- **Just-in-time over preloading.** Read reference docs only when the task needs them.
- **Check existing memory.** Auto-memory is loaded by the harness automatically; the vault is not. Search `memory/wiki` (from the `claude-obsidian` plugin) and other `memory` docs for data related to the task at hand.

## Conversation Rules

- Avoid ambiguous abbreviations; spell out a term when it may be unclear.
- Sort items alphabetically when producing, editing or working on lists.
- Use information-dense sentences without fillers; no preamble.
- Use plain language that is easy to understand.

## Repository Awareness

- Verify the target repo before any `gh` mutation: run `git remote -v` and `pwd`, and pass `--repo owner/name` explicitly when working across clones. When the user says "this repo", confirm with the same commands.
- After a `cd`, treat parallel or background Bash calls as having stale CWD — re-pass the path or re-`cd` inside each call.

## GitHub Authoring

The descriptions should be easy to understand by a reviewer who is not familiar with the topic. Focus on behavior instead of technical details.

## Scope Discipline

- Don't add backwards-compatibility shims, dual-format support, or migration paths unless asked. Do rewrite the affected call sites cleanly when they're already in the diff.
- Don't ship stretch goals or speculative features in PRs. Do scope PRs to the explicit request only.
- When rebasing or migrating, only carry over the files explicitly in scope; flag unrelated files rather than silently including them.
- Don't bump versions, rename credentials, or edit configuration values beyond the literal request. Flag and ask before touching adjacent state.
- Follow DRY, SOLID and KISS principles.
- Before writing any doc or multi-file deliverable longer than ~30 lines, declare a one-line target length and a 3-bullet outline up front. If the draft exceeds the target by more than 50%, stop and compact before continuing.

## Documentation Hygiene

- Before editing CLAUDE.md or other docs, grep existing docs to avoid duplication. Prefer extracting long rule/schema blocks into dedicated reference files and linking from CLAUDE.md. Build Claude configuration modularly (no monoblocks).

## Compact instructions

When compacting, preserve: test output, code changes, explicit architectural decisions, open questions, failing assertions. Drop: tool-call transcripts, file-read echoes, intermediate exploration.
