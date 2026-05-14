---
name: load-pr-guidelines
description: Load PR description guidelines when creating, opening, drafting, or writing a pull request.
when_to_use: Use when creating or drafting a GitHub PR. Loads templates and structure rules. Does NOT create the PR itself.
---
## Pull Request Descriptions

_Overrides the built-in Claude Code default (`## Summary` + `## Test plan`). Project-level `CLAUDE.md` may override further._

Apply [common rules](../guidelines/common-rules.md). Additional rules specific to PR descriptions:

- **Check for a PR template first.** Look at `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, root `PULL_REQUEST_TEMPLATE.md`, and any file under `.github/PULL_REQUEST_TEMPLATE/`.
- **When no template exists**, use these sections in order: `## Context`, `## Acceptance Criteria`, `## Testing`. Omit `## Testing` when there is nothing meaningful to verify.
- **`## Context`** opens with `Closes #<n>` (or `Relates to #<n>` when the PR doesn't fully close the issue), a blank line, then prose framing.
- **Write for the reviewer**: what changed, which issue it closes/relates to, which AC it satisfies, and how to verify.
