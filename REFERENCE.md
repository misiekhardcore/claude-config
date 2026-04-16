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
| `<project>/memory/wiki/**/*.md` | Per-project Obsidian vault (Karpathy LLM Wiki pattern, via `claude-obsidian` plugin). Checked into git, shared with collaborators | `/compound` or `/save` writes; `/prune` and `wiki-lint` audit | Manual — `memory/wiki/hot.md` → `memory/wiki/index.md` → drill into `concepts/`, `entities/`, `sources/`. Discovered via the "check existing memory first" rule in CLAUDE.md |

Auto memory is opaque to user skills (the harness owns the directory). To capture session findings deterministically, run `/compound` — it writes a structured note into `memory/wiki/concepts/` (or the appropriate subdirectory), deduplicates against existing notes, and is shared via git. To surface in-flight assumptions before context loss, run `/wrap-up` — its output stays in the conversation; persistence is left to auto memory.

The Obsidian vault provides richer structure than a flat solutions directory: a `hot.md` cache, an `index.md` router, an operation `log.md`, typed pages (`concepts/`, `entities/`, `sources/`), and cross-links that compound as new material is ingested. The `claude-obsidian@claude-obsidian-marketplace` plugin adds `/wiki`, `/save`, `/autoresearch`, `/canvas`, `wiki-ingest`, and `wiki-lint`. See `memory/WIKI.md` for the schema and `memory/CLAUDE.md` for vault-scoped instructions.

Disable auto memory with `claude --bare` if you need a clean session.
