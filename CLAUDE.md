# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Implementation Rules

- **Default to single-agent.** Use `TeamCreate` only for parallelizable work across 3+ independent files or sub-issues. Team overhead (per-agent system prompt, message passing, coordination) costs more than it saves on smaller tasks.
- Respond concisely; no filler, no preamble.
- Use the cheapest viable model. Skills set their own `model:` and `effortLevel:` — trust them.

## Feature Workflow

Choose the right level of process based on task complexity:

- **Trivial fix** (obvious problem + solution) → /implement directly
- **Medium feature** → /discovery then /implement
- **Large feature / epic** → /discovery → /define → /implement

| Phase          | Skill      | What it does                                                                |
| -------------- | ---------- | --------------------------------------------------------------------------- |
| Discovery      | /discovery | Explore problem (/describe) + define requirements (/specify) → GitHub issue |
| Definition     | /define    | Plan architecture (/architecture) + design (/design) → issue comments       |
| Implementation | /implement | /build → /review → /verify loop → PR when passing                           |

Each skill spawns specialist teams and uses /grill-me for interactive decision-making with visualizations.

### Building-block skills (usable standalone)

| Skill         | Purpose                                                                    |
| ------------- | -------------------------------------------------------------------------- |
| /describe     | Explore problem space — visualizations, user stories, comparisons          |
| /specify      | Define acceptance criteria — testable GIVEN/WHEN/THEN scenarios            |
| /architecture | Technical decisions — component diagrams, trade-off tables, code structure |
| /design       | Visual/UX decisions — mockups, interaction flows, prototypes               |
| /build        | Code against issue — worktree, TDD, parallel agent teams                   |
| /review       | Code review — correctness + standards specialists                          |
| /verify       | QA verification — per-criterion pass/fail with evidence                    |
| /grill-me     | Base Q&A engine — relentless interviewing on any topic                     |
| /wrap-up      | End-of-session assumptions audit — surfaces decisions and follow-ups       |
| /prune        | Audit rules and solution docs for staleness                                |

@plugins-reference.md

## Maintenance

- Before ending long sessions, run `/wrap-up` to surface assumptions
- Run `/prune` monthly or after major refactors to audit rules and solution docs

## Scripts CLI

The `scripts` command is globally available (linked from `~/Projects/scripts`). It provides cross-repo utilities for dependencies, file search, git operations, and GitHub label migration. Most commands accept `--all` to operate on all repos in `~/Projects/`.

Run `scripts --help` or `scripts <command> --help` for details on available commands and options.

RTK reference: `~/.claude/RTK.md` (read on demand — RTK is invoked transparently by the `rtk-rewrite.sh` PreToolUse hook).
