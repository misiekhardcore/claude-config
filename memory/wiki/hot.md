---
type: meta
title: "Hot Cache"
updated: 2026-04-19T00:00:00
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
2026-04-19: **claude-workflow composition codification** (issue #13, PR #14). Closed documented gaps G1-G5. `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` is now documented in README.md, CLAUDE.md, and `_shared/composition.md`. `skills/specify/SKILL.md` and `skills/design/SKILL.md` now document optional seed briefs. `_shared/composition.md` is the canonical in-repo reference for four composition patterns, three skill roles (orchestrator/specialist/primitive), three brief types (research/prior-art/fix) with field contracts, hierarchical decomposition rules, and failure modes. `SKILL.template.md` split into three role-specific templates (45/33/30 lines). `new-skill` now asks role before routing to template (Description before Role to enable recommendation). See [[claude-workflow-composition-codification]], [[claude-workflow-phase-shape]]. Staleness: [[seed-brief-pattern]] brief field names differ from composition.md.

2026-04-19: **Multiskill Workflow Structure in claude-workflow** (autoresearch after hoisting Prior-Art Scout to `/discovery`). Research converges: claude-workflow's shape aligns with 2026 multi-agent consensus. Four composition patterns (linear/branch/loop/parallel) combine into hybrids; claude-workflow is linear at phase level (`/discovery → /define → /implement`), parallel within phases. Durable artifact handoffs (GitHub issue body = five-field handoff block) between phases with fresh sessions. Seed-brief pattern within phases: upstream research feeds multiple specialists who skip own research. Two-level team hierarchy (phase team → specialist's nested team) only possible via TeamCreate (subagents can't spawn subagents). Single-agent default aligns with Princeton NLP finding (single agent matches multi-agent on 64% of tasks at half cost). Failure modes to avoid: infinite handoff loops, context loss at transfer, hand-off-too-early, fragmented-agent ROI drop. See [[Research: Multiskill Workflow Structure in claude-workflow]], [[multiskill-workflow-patterns]], [[seed-brief-pattern]], [[claude-workflow-phase-shape]].

2026-04-19: **VS Code Webview Testing and Screenshots** (autoresearch for vscode-gcode-extension docs pipeline). User has a raw plan at `~/Downloads/vscode-webview-testing.md` proposing `wdio-vscode-service` for screenshot automation. Research validates that choice and surfaces 9 refinements: (1) pin exact `browserVersion` not `'stable'` — minor VS Code updates shift chrome; (2) Xvfb default is 1280×1024 — use `--server-args='-screen 0 1920x1080x24'`; (3) add D-Bus session + `disable-hardware-acceleration` in `argv.json` to preempt `ubuntu-latest` GPU/bus errors; (4) Welcome page is itself a webview — close all editors before `getAllWebviews()` or first hit binds to Welcome; (5) pin `editor.fontFamily` and install font as CI asset; (6) cache `.vscode-test` via `actions/cache@v4`; (7) for webview-only (chrome-free) shots, render webview HTML in plain Playwright via chained `frameLocator('iframe.webview').frameLocator('iframe[name="active-frame"]')` — cleaner than switching context inside wdio; (8) Electron has no true headless mode on Linux, Xvfb is mandatory; (9) WebGL (Three.js visualizer) may blank under Xvfb software GL — use `--use-gl=swiftshader` or render the webview in plain Playwright. See [[Research VS Code Webview Testing and Screenshots]].

2026-04-18: **Progress Reporting Two-Role Model** (issue #139, PR #150). Two distinct roles exist for progress code: **orchestrator** (`ProgressReporter` -- stateful begin/report/done, owns the UI spinner) vs. **producer** (`ExtractorProgressCallback` -- stateless per-event callback from a hot loop). Producers must NOT implement `ProgressReporter` (fake begin/done). `LspBoundProgressReporter` extends the generic interface with `token` only for the one caller that forwards it (no interface widening). Intra-phase throttle: `Date.now()` per segment, 100ms wall-clock gate, segment-count message, no percentage (total unknown). CI test-determinism: freeze `Date.now()` with `mockReturnValue` rather than real timers. See [[server-provider-wiring-patterns]] (updated with full progress section).

2026-04-18: **Multi-Root Workspace Per-Folder Config** (issue #141, PR #149). Three patterns: (1) `vscode.workspace.getConfiguration(undefined, scope)` with folder URI for per-folder reads; (2) `vscode.RelativePattern` + folder-scoped excludes so `findFiles` applies per-folder ignore rules; (3) **longest-prefix matching** (not first-match) when resolving which root owns a file — critical for nested/overlapping roots. Supersedes the "Known Limits: single dialect per scan" entry on [[workspace-symbol-architecture]]. E2E coverage via `src/e2e/fixtures-multiroot/` (folder-a fanuc, folder-b linuxcnc). See [[multi-root-workspace-per-folder-config]].

2026-04-17: **Structured Parse Error Location** (issue #146). Single `createParseError` factory wires 23+ parser raise sites to a 1-based `ErrorLocation`. `locationToRange` adapter converts to 0-based LSP Range at one site. Critical invariant: token-derived location must set `endColumn: token.col + token.value.length` — omitting it collapses diagnostic squiggles to zero-width. Visualizer error card propagates `location: ErrorLocation | null` through worker → reducer → EmptyMessage; forced `null` for non-PARSE_FAILURE kinds. See [[Structured Parse Error Location]].

2026-04-17: **Plugin Root Variable in Skills** — captured from claude-workflow stage #3 (PR #7, 17-skill migration). Context7 docs confirm `${CLAUDE_PLUGIN_ROOT}` is officially expanded only in hook commands and MCP server configs; SKILL.md body references rely on Claude's contextual resolution, not documented guarantee. Fallback pattern (glob against `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/`) documented in the plugin's `CLAUDE.md` so skills remain functional across Claude Code versions. See [[Plugin Root Variable in Skills]].

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
