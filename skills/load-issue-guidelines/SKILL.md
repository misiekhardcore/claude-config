---
name: load-issue-guidelines
description: Load issue description guidelines when creating, filing, opening, or writing a GitHub issue or bug report.
when_to_use: Use when filing a bug, creating a GitHub issue, or writing issue descriptions. Loads templates and structure rules. Does NOT create the issue itself.
---
## Issue Descriptions

Apply [common rules](../guidelines/common-rules.md). Additional rules specific to issue descriptions:

- **Check for an issue template first.** Look at `.github/ISSUE_TEMPLATE/`, `.github/ISSUE_TEMPLATE.md`, root `ISSUE_TEMPLATE.md`.
- **When no template exists**, use these two sections in order:
  - `## Context` — what the user is trying to do; why the current state is inadequate. Opens with a problem statement, not a solution.
  - `## Acceptance Criteria` — numbered, testable scenarios that define done. Each item must be independently verifiable.
- **Write for the implementer.** Describe what is needed and why, not how to implement it. Do not pre-specify file paths, function names, or class hierarchies unless they are load-bearing constraints that must not change.
