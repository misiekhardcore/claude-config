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

## Notes convention

For multi-cycle implementations, write progress notes to `.claude/notes/<feature>.md`. Each cycle re-reads its own notes instead of carrying state through conversation. Delete the file when the feature is shipped.
