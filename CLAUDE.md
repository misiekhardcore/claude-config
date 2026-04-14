# CLAUDE.md

Guidance for Claude Code in this repository.

## Implementation Rules

- **Default to single-agent.** Use `TeamCreate` only for parallelizable work across 3+ independent files or sub-issues.
- **Use the cheapest viable model.** Skills set their own `model:` and `effortLevel:` — trust them.
- **Just-in-time over preloading.** Read reference docs (`~/.claude/REFERENCE.md`, `~/.claude/RTK.md`, `~/.claude/plugins-reference.md`) only when the task needs them.
- **Externalize state on long sessions.** For multi-cycle implementations, write progress notes to `.claude/notes/<feature>.md` instead of carrying them in conversation; re-read on resumption.
- Respond concisely; no filler, no preamble.

## Feature Workflow

Pick the lightest path that fits the task:

- Trivial fix → `/implement` directly.
- Medium feature → `/discovery` → `/implement`.
- Large feature / epic → `/discovery` → `/define` → `/implement`.

### Canonical example — medium feature

> User: "Add a CSV export button to the reports page."
> 1. `/discovery` — interview the user, write the issue with acceptance criteria, get explicit approval.
> 2. `/implement` — `/build` codes against the issue with TDD, `/review` runs specialist reviewers, `/verify` checks each criterion, then PR.

Skill descriptions (loaded with the skills themselves) cover the building blocks: `/describe`, `/specify`, `/architecture`, `/design`, `/build`, `/review`, `/verify`, `/grill-me`, `/wrap-up`, `/prune`, `/compound`.

@plugins-reference.md
