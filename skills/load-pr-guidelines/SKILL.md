---
name: load-pr-guidelines
description: "Load PR description guidelines when creating, opening, drafting, or writing a pull request. Trigger phrases: creating a PR, opening a pull request, drafting a PR, open a PR, create a PR, submit a PR, write a PR, PR description, pull request description, make a pull request."
---

## Pull Request Descriptions

_Overrides the built-in Claude Code default (`## Summary` + `## Test plan`). Project-level `CLAUDE.md` may override further._

- **Check for a PR template first.** Look at `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, root `PULL_REQUEST_TEMPLATE.md`, and any file under `.github/PULL_REQUEST_TEMPLATE/`. Read the file before writing anything.
- **When a template exists**: use it as the literal starting point — copy it verbatim, then fill each section by replacing HTML comment instructions and placeholder text with actual content. Do not add, remove, or rename any heading. Leave checklist items unchecked unless you have explicit confirmation they are satisfied.
- **When no template exists**, use these sections in order: `## Context`, `## Acceptance Criteria`, `## Testing`. Omit `## Testing` when there is nothing meaningful to verify.
- **`## Context`** opens with `Closes #<n>` (or `Relates to #<n>` when the PR doesn't fully close the issue), a blank line, then prose framing.
- **Write for the reviewer**: what changed, which issue it closes/relates to, which AC it satisfies, and how to verify. Do not enumerate modified files or function-level changes.
- Screenshots are welcome for visual changes; placement at your discretion.
