---
name: load-issue-guidelines
description: "Load issue description guidelines when creating, filing, opening, or writing a GitHub issue or bug report. Trigger phrases: creating an issue, filing a bug, opening a ticket, open an issue, create an issue, file a bug, write an issue, issue description, new issue, report a bug, add an issue."
---

## Issue Descriptions

- **Check for an issue template first.** Look at `.github/ISSUE_TEMPLATE/`, `.github/ISSUE_TEMPLATE.md`, root `ISSUE_TEMPLATE.md`. When a template exists, follow its structure and add no extra headings.
- **When no template exists**, use these two sections in order:
  - `## Context` — what the user is trying to do; why the current state is inadequate. Opens with a problem statement, not a solution.
  - `## Acceptance Criteria` — numbered, testable scenarios that define done. Each item must be independently verifiable.
- **Human-readable headings.** Use section names that describe content (e.g. `## Acceptance Criteria`, `## Implementation plan`). Never use slash-command names as headings (e.g. not `## /specify`).
- **Write for the implementer.** Describe what is needed and why, not how to implement it. Do not pre-specify file paths, function names, or class hierarchies unless they are load-bearing constraints that must not change.
- Screenshots are welcome for visual changes; placement at your discretion.
