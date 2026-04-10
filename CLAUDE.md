# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Implementation Rules

- **Always use agent teams** for non-trivial implementation. Use `TeamCreate` to spawn teammates — assign each a separate sub-issue or file group to avoid conflicts. Only fall back to single-agent for trivial single-file fixes. When dispatching subagents, explicitly instruct them to use teams.
- Respond concisely; no filler, no preamble

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

@RTK.md
