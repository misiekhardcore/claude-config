# REFERENCE.md

On-demand reference. Not auto-loaded by CLAUDE.md — read only when relevant.

## Maintenance

- Run `/wrap-up` before ending long sessions to surface assumptions.
- Run `/prune` monthly or after major refactors to audit rules and solution docs.

## Scripts CLI

The `scripts` command is globally available (linked from `~/Projects/scripts`). Cross-repo utilities for dependencies, file search, git operations, and GitHub label migration. Most commands accept `--all` to operate on all repos in `~/Projects/`.

```sh
scripts --help
scripts <command> --help
```

## RTK (Rust Token Killer)

Token-optimized CLI proxy invoked transparently by the `rtk-rewrite.sh` PreToolUse hook. Direct usage only for the meta commands:

```sh
rtk gain              # token savings analytics
rtk gain --history    # command history with savings
rtk discover          # analyze Claude Code history for missed opportunities
rtk proxy <cmd>       # raw passthrough (debugging)
```

See `~/.claude/RTK.md` for more.

## Memory layout

Two tiers, both already wired up — don't invent a third:

| Location | Scope | Lifecycle | Loaded |
|---|---|---|---|
| `~/.claude/projects/<project>/memory/MEMORY.md` + topic files | Per-user, per-project. Built-in Claude Code "auto memory" | Claude self-curates; `/prune` audits | First ~200 lines / 25KB at session start; topic files on demand |
| `<project>/.claude/docs/solutions/*.md` | Per-project, checked into git, shared with collaborators | `/compound` writes; `/prune` audits | Manual — discovered via the "check existing memory first" rule in CLAUDE.md |

Auto memory is opaque to user skills (the harness owns the directory). To capture session findings deterministically, run `/compound` — it writes to `.claude/docs/solutions/`, deduplicates against existing docs, and is shared via git. To surface in-flight assumptions before context loss, run `/wrap-up` — its output stays in the conversation; persistence is left to auto memory.

Disable auto memory with `claude --bare` if you need a clean session.
