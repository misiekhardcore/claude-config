---
type: meta
title: "Hot Cache"
updated: 2026-04-20T00:00:00
created: 2026-04-17
tags:
  - meta
  - hot-cache
status: evergreen
confidence: EXTRACTED
evidence: []
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
  - "[[llm-wiki-karpathy-gist]]"
  - "[[llm-wiki-v2-extensions]]"
  - "[[knowledge-compounding-economics]]"
  - "[[Graphify]]"
  - "[[llm-wiki-scalability-critique]]"
  - "[[LLM Wiki Pattern]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

## Last Updated

2026-04-21: **#23365 PR1 scaffolding delivered** — [[play-assertion-runner-architecture]] updated with actuals. PR plan corrected: PR1 (#23380) is standalone (no #3498 dependency), delivers `IAssertionEvaluator` types + `splitInstructions` + `assembleExecutionState` + `replay()` refactor with placeholder evaluator. Prototype comparison: prototype had the interface but never wired it — all integration pieces are greenfield. PR2 owns `ClientAssertionEvaluator` (~50% prototype port + ~50% greenfield for plural-aggregate and incident branches). Draft PR open at camunda-hub#23380.

2026-04-21: **Epic 3496 pre-define briefings filed** in [[3496-sub-issue-breakdown-plan]]. Four /define candidates: 1a (evaluation engine — IAssertionEvaluator interface + CPT-parity contract), 1c (element instance editor — non-det agent warning detection algorithm + canvas overlay UX), 3a (validation pipeline — ValidationResult shape + recovery-action taxonomy), 3b (graphical repair view — Phase 1 editor reuse pattern + broken-assertion pre-fill semantics). Each briefing includes decisions already made (do not re-litigate), open decisions for /define/design, key constraints, and prototype reference. Start each session by loading that page section + the solution proposal at https://github.com/camunda/product-epics-pilot/blob/main/initiatives/testing-camunda-agents/3496-low-code-test-assertions.solution-proposal.md

2026-04-21: **Epic 3496 sub-issues created in camunda-hub** (12 issues). Phase 1 #23375 with children 1a #23365, 1b #23366, 1c #23367, 1d #23368, 1e #23369. Phase 2 #23370 (flat). Phase 3 #23376 with children 3a #23371, 3b #23372, 3c #23373, 3d #23374. Native sub-issue relationships wired via GraphQL `addSubIssue` for same-repo parent/child. Cross-repo link to product-hub#3496 is by URL reference in each body (not modified in #3496 body — snippet prepared for DRI to paste). Dependencies in body text: 1b-e depend on 1a, 3b-d depend on 3a, Phase 3 depends on Phase 1. `/define` candidates: 1a (evaluator interface + CPT parity), 1c (non-det agent warning UX), 3a (validation pipeline + ValidationResult shape), 3b (inline repair editor reuse). Labels: `feature/play`, `component/frontend`, plus `kind/epic` on the two phase parents. See [[3496-sub-issue-breakdown-plan]].

2026-04-20: **Schema migration: typed relationships + confidence tagging** (issue #11). Added two new schema features: (1) **Confidence tagging** - every wiki page now has `confidence: EXTRACTED|INFERRED|AMBIGUOUS` (Graphify-style) and `evidence:` list. Source pages default to EXTRACTED; concept/entity/question/comparison pages default to INFERRED. Source-type pages had existing `confidence: high|medium|low` renamed to `source_reliability:` to avoid collision. (2) **Typed relationships** - seven new optional flat-list fields alongside `related:`: `supersedes`, `contradicts`, `uses`, `depends_on`, `caused`, `fixed`, `implements`. All 74 wiki pages migrated. See [[frontmatter]], [[maintenance-rules]]. 13 pages received typed relationships where semantics were unambiguous (e.g., `llm-wiki-v2-extensions` implements `LLM Wiki Pattern`; `Graphify` implements `[[llm-wiki-v2-extensions]]`; `allowed-tools-semantics` uses `[[skill-invocation-model]]`).

2026-04-20: **Wiki Memory Lifecycle: Consolidation Tier Implementation Pattern** (compound from issue #12). Four design decisions for implementing consolidation tiers in an Obsidian wiki: (1) `tier:` is explicit in frontmatter, not computed from `type:` at runtime — allows per-page overrides; (2) type→tier tables are _intentionally scoped per skill_ (wiki-ingest has 8 types, save has 5, autoresearch has 4) — not a bug, each reflects that skill's page vocabulary; (3) migration sets `reviewed_at:` to _today_, not the page's created date — bootstraps the clock from the system introduction date; (4) canonical `[!stale]` callout format lives exclusively in wiki-lint — reference docs must quote it, not redefine it. wiki-lint check #9 injects/removes callout idempotently. See [[wiki-memory-lifecycle-tier-implementation]], [[llm-wiki-v2-extensions]].

2026-04-20: **Wiki Frontmatter Schema Extension Pattern** (compound from issue #11). Six rules for extending Obsidian wiki frontmatter safely: (1) flat YAML only — nested `relationships:` blocks break Obsidian Properties UI; (2) rename field collisions before migrating — e.g. `confidence: high|medium|low` renamed to `source_reliability:` before adding universal `confidence: EXTRACTED|INFERRED|AMBIGUOUS`; (3) CLAUDE.md is a pointer — add brief required-fields section there, keep full spec in frontmatter.md; (4) `contradicts:` requires direct factual conflict, not critique; (5) universal fields apply to ALL page types including solutions, meta, \_index, structural files — grep for missing fields after migration; (6) use underscore over hyphen in YAML keys. See [[wiki-frontmatter-schema-extension]].

2026-04-20: **LLM Wiki ecosystem post-publication research** (autoresearch on Karpathy gist). Four key findings not in the April 17 ingest: (1) **LLM Wiki v2** (rohitg00) extends the base pattern with memory lifecycle (confidence decay, Ebbinghaus forgetting curves, supersession), typed knowledge graph (EXTRACTED/INFERRED/AMBIGUOUS edges), hybrid search (BM25 + vector + graph traversal), and event-driven automation -- schema is now "the real product." (2) **arXiv:2604.11243** provides empirical economics: 84.6% token savings (47K vs 305K tokens) on a 4-query test vs RAG; 53.7-81.3% savings over 30 days depending on topic concentration; reframes tokens from consumables to capital goods. (3) **Graphify** implements the pattern with three confidence tiers: EXTRACTED (deterministic, conf=1.0), INFERRED (variable 0-1.0), AMBIGUOUS (triggers HITL review). (4) **Scalability critiques** quantified: ~1000-file collapse for flat index; hallucination compounding is a genuine failure mode; enterprise RAG (95K+ docs) still wins for full-corpus retrieval. Pattern best fits personal/small-team use (<1000 pages). Gist updated metrics: 4,713 forks (up from 4,360), 485+ comments. See [[llm-wiki-v2-extensions]], [[knowledge-compounding-economics]], [[Graphify]], [[llm-wiki-scalability-critique]].

2026-04-19: **`allowed-tools` best practice for multi-agent workflow plugins** (autoresearch). The SKILL.md `allowed-tools` field **pre-approves** tools during skill execution, it does NOT restrict them — every tool remains callable and falls through to normal permission settings. To actually block tools, use deny rules in `.claude/settings.json` or put the restriction on a subagent's `tools:` field (different field, opposite semantics). The Agent SDK ignores frontmatter `allowed-tools` entirely — use `allowedTools` query option + `permissionMode: "dontAsk"` for hard restriction there. Best practice for plugins like `claude-workflow`: (1) default to omission on orchestrator/specialist skills — respect user's permission config; (2) declare narrow list + `disable-model-invocation: true` only for side-effect skills (`/commit`, `/deploy`); (3) primitive skills with truly fixed surface (`/grill-me` → Read/Grep/Glob) may pre-approve for ergonomics. Current claude-workflow state: all 17 skills correctly omit the field. But `_templates/AUTHORING.md` and `SKILL.primitive.template.md` describe it as "restricts" — factually wrong per official docs. Fix needed: replace "restrict" with "pre-approve" and add pointer to deny rules / subagent `tools:` for real restriction. See [[Research: allowed-tools best practice for multi-agent workflow plugins]], [[allowed-tools-semantics]], [[skill-vs-subagent-tool-fields]], [[allowed-tools-for-multi-agent-plugins]].

2026-04-19: **AskUserQuestion in skill interviews** (applied to `/new-skill` and `/grill-me`). Pattern: bounded choices (2-4 options) use `AskUserQuestion` with `header` (max 12 chars), `question`, `options` (label + description), `multiSelect: true` when non-exclusive. "Other" is auto-added. Recommended option goes first with ` (Recommended)` in label. Free-text questions (name, description) stay as plain prompts. 4-option cap per call: split protocols question into two sequential AskUserQuestion calls. Multi-question calls only when answers are independent. Applied to `_shared/interviewing-rules.md` (rule added), `skills/new-skill/SKILL.md` (steps c-h specified as AskUserQuestion), `skills/grill-me/SKILL.md` (guidance added). See [[AskUserQuestion-in-skill-interviews]], [[skill-creation-patterns]].

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
