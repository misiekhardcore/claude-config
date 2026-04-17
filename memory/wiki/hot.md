---
type: meta
title: "Hot Cache"
updated: 2026-04-17T19:00:00
created: 2026-04-17
tags:
  - meta
  - hot-cache
status: evergreen
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
  - "[[llm-wiki-karpathy-gist]]"
  - "[[LLM Wiki Pattern]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

## Last Updated
2026-04-17: **Autonomous research loop on Claude Code skills/slash commands creation.** Searched official Anthropic docs (code.claude.com/docs/en/slash-commands), reviewed installed skill-creator plugin (31KB SKILL.md), examined sample skills (brainstorming, verification-before-completion). Created 5 wiki pages: [[claude-skill-anatomy]] (file structure, directory locations, progressive disclosure), [[skill-invocation-model]] (manual vs. automatic triggering, description field mechanics, undertriggering bias), [[skill-creation-patterns]] (13 best practices: pushy descriptions, progressive disclosure, explain the why, bundle repeated work, etc.), [[skill-frontmatter-reference]] (complete YAML field reference), [[skill-creator-plugin]] (official plugin for interactive skill creation/evaluation). Key findings: Frontmatter fields are `name`, `description` (recommended), `disable-model-invocation`, `user-invocable`, `allowed-tools`, `context`, `agent`, `effort`, `model`, `paths`. Skill descriptions are the sole mechanism driving automatic invocation — must be explicit about trigger phrases and contexts. Claude tends to undertrigger; combat with "pushy" descriptions listing specific use cases. Skills follow Agent Skills open standard extended with Claude-specific lifecycle features.

2026-04-17: Researched per-project knowledge management in LLM Wiki ecosystems. Created [[per-project-knowledge]] concept page analyzing three options (centralized, per-project, hybrid). Recommendation: hybrid pattern (shared reusable patterns in `~/Projects/claude-config/memory/wiki/`, project-specific knowledge in `.claude/wiki/` per repo) balances network effects with isolation. Implementation: keep current shared wiki structure, prepare for per-project vaults as projects grow.
2026-04-17: Ingested vscode-gcode-extension full architecture into wiki. Created [[gcode-lsp-architecture]] concept page, updated [[vscode-gcode-extension]] entity with full architecture details, created [[vscode-gcode-extension-architecture]] source summary.
2026-04-08: v1.4.1 hotfix shipped, plugin confirmed installed and enabled

## Last Ingest
- Source: `.raw/articles/llm-wiki-karpathy-2026-04-04.md` ([[llm-wiki-karpathy-gist]])
- New pages: [[Memex]], [[Vannevar Bush]], [[qmd]], [[llm-wiki-karpathy-gist]]
- Updated: [[LLM Wiki Pattern]] (added Tools & Extensions + Historical Lineage), [[Andrej Karpathy]] (linked gist as primary source)
- Key takeaway: the gist explicitly frames the pattern as a Memex revival — LLMs finally solve the bookkeeping cost that killed human-maintained wikis.

## Plugin State
- **Version**: 1.4.1 (installed, enabled, user scope)
- **Install ID**: `claude-obsidian@claude-obsidian-marketplace`
- **Releases**: v1.1, v1.4.0, v1.4.1 on GitHub
- **Skills**: 10 (wiki, wiki-ingest, wiki-query, wiki-lint, save, autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown)
- **Hooks**: 4 (SessionStart, PostCompact, PostToolUse, Stop)
- **Multi-agent**: bootstrap files for Codex, OpenCode, Gemini, Cursor, Windsurf, GitHub Copilot

## Install Command (Correct Two-Step Flow)
```bash
claude plugin marketplace add AgriciDaniel/claude-obsidian
claude plugin install claude-obsidian@claude-obsidian-marketplace
```

There is no `claude plugin install github:owner/repo` shortcut. Both steps are required. Full session note: [[pr-feedback-resolution-wiki-migration-2026-04-17]].

## Recent Release Cycle (v1.1 → v1.4.1)
- **v1.1**: URL ingestion, vision ingestion, delta tracking manifest, 3 new skills (defuddle, obsidian-bases, obsidian-markdown), multi-depth query modes, PostToolUse auto-commit, removed invalid `allowed-tools` frontmatter field
- **v1.4.0**: Dataview to Bases migration (new `wiki/meta/dashboard.base`), Canvas JSON 1.0 spec completeness, PostCompact hook, Obsidian CLI MCP option, 6 multi-agent bootstrap files, 249 em dashes scrubbed, security git history rewrite to remove placeholder email
- **v1.4.1**: hotfix for wrong plugin install command syntax in README and install-guide.md

## Key Lessons (Recent)
1. Plugin install is always two-step: `marketplace add` then `install plugin@marketplace`
2. `allowed-tools` is NOT valid in **Obsidian/kepano** skill frontmatter (only `name` + `description`). For **Claude Code** CLI skills, the full frontmatter spec applies: `name`, `description`, `allowed-tools`, `model`, `effort`, `context`, `agent`, `hooks`, etc.
3. Obsidian Bases uses `filters/views/formulas`, not Dataview `from/where`
4. Canvas edges have asymmetric defaults: `fromEnd="none"`, `toEnd="arrow"`
5. Hook-injected context does not survive compaction. PostCompact hook is required to restore hot cache.
6. `git filter-repo` needs two passes: `--replace-text` for blobs, `--replace-message` for commit messages

## Style Preferences (Saved to Memory)
- **No em dashes** (U+2014) or `--` as punctuation anywhere. Use periods, commas, colons, or parentheses. Hyphens in compound words are fine (auto-commit, multi-agent).
- Keep responses short and direct. No trailing "here's what I did" summaries.
- Parallel tool calls when independent.

## Ecosystem Research (Done 2026-04-08)
16+ Claude + Obsidian projects mapped. Full feature matrix at [[claude-obsidian-ecosystem]]. Prioritized backlog at [[cherry-picks]]. Top competitors: [[Ar9av-obsidian-wiki]] (multi-agent + delta tracking), [[rvk7895-llm-knowledge-bases]] (multi-depth query), [[ballred-obsidian-claude-pkm]] (goal cascade + auto-commit), [[kepano-obsidian-skills]] (authoritative Obsidian skills from Obsidian's own creator).

## Active Threads
- v1.5.0 backlog: `/adopt` command, vault graph analysis in wiki-lint, semantic search via qmd, Marp output
- `community` remote (`avalonreset-pro/claude-obsidian`) still has pre-rewrite history. Force-push needed next time that remote is configured.

## Recent Ingest (2026-04-17)

Ingested 7 solution docs from vscode-gcode-extension project (a VSCode LSP extension for G-code/CNC). Covers TypeScript typing patterns (Dirent generic disambiguation, interface import cycles), LSP infrastructure (file watching on Linux, workspace symbol architecture with client-side enumeration), server wiring conventions, and visualizer composition patterns.

## Repo Locations
- Working: `~/Desktop/claude-obsidian/`
- Public: https://github.com/AgriciDaniel/claude-obsidian
- Community (private): https://github.com/avalonreset-pro/claude-obsidian
- vscode-gcode-extension: `/home/michal/Projects/vscode-gcode-extension.feat-client-side-enumeration-138`
