---
type: meta
title: "Wiki Index"
updated: 2026-04-20
created: 2026-04-17
tags:
  - meta
  - index
status: evergreen
confidence: EXTRACTED
evidence: []
related:
  - "[[overview]]"
  - "[[log]]"
  - "[[hot]]"
  - "[[dashboard]]"
  - "[[Wiki Map]]"
  - "[[concepts/_index]]"
  - "[[entities/_index]]"
  - "[[sources/_index]]"
  - "[[LLM Wiki Pattern]]"
  - "[[Hot Cache]]"
  - "[[Compounding Knowledge]]"
  - "[[Andrej Karpathy]]"
  - "[[Memex]]"
  - "[[Vannevar Bush]]"
  - "[[qmd]]"
---

# Wiki Index

Last updated: 2026-04-22 | Total pages: 100 | Sources ingested: 27

Navigation: [[overview]] | [[log]] | [[hot]] | [[dashboard]] | [[Wiki Map]] | [[getting-started]]

---

## Concepts

- [[LLM Wiki Pattern]] — the pattern for building persistent, compounding knowledge bases using LLMs (status: mature)
- [[llm-wiki-v2-extensions]] — production extensions: memory lifecycle, typed graph, hybrid search, event-driven automation (status: current)
- [[wiki-memory-lifecycle-tier-implementation]] — implementation pattern for four-tier consolidation lifecycle (tier:/reviewed_at: fields, stale detection, migration bootstrap) (status: current)
- [[wiki-frontmatter-schema-extension]] — six design rules for extending Obsidian wiki frontmatter: flat YAML, collision handling, CLAUDE.md pointer pattern, contradicts semantics, universal field completeness (status: current)
- [[knowledge-compounding-economics]] — arXiv empirical analysis: 84.6% token savings vs RAG; tokens as capital goods (status: current)
- [[llm-wiki-scalability-critique]] — four critiques (1k-file collapse, hallucination compounding, enterprise RAG) with production responses (status: current)
- [[Hot Cache]] — ~500-word session context file, updated after every ingest and session (status: mature)
- [[Compounding Knowledge]] — why wiki knowledge grows more valuable over time, unlike RAG (status: mature)
- [[Memex]] — Bush's 1945 precursor to the LLM wiki pattern; associative trails between documents (status: developing)
- [[cherry-picks]] — prioritized feature backlog from ecosystem research; 13 features to add to claude-obsidian (status: current)
- [[play-assertion-runner-architecture]] — two-system gap (Scenarios has runner, Acceptance Tests is CRUD-only); CPT type gaps; three Phase 1 runner options; IAssertionEvaluator interfaces (status: current)
- [[gcode-lsp-architecture]] — Five-layer Lexer → Parser → AST → Services → Adapters pipeline for LSP extensions (status: current)
- [[multi-root-workspace-per-folder-config]] — Per-folder `getConfiguration` scope, `RelativePattern` findFiles, longest-prefix root matching (status: current)
- [[per-project-knowledge]] — centralized vs. per-project vault strategies for multi-project knowledge management (status: current)
- [[out-of-session-plugin-config-access]] — Pattern for reading plugin config from settings.local.json in cron/external invocations where ${user_config.*} is unavailable (status: current)
- [[claude-skill-anatomy]] — Structure of Claude Code skills: frontmatter, markdown body, supporting files, directory layout (status: evergreen)
- [[skill-invocation-model]] — How Claude Code skills are triggered: user manual invocation vs. automatic Claude invocation (status: evergreen)
- [[skill-creation-patterns]] — 13 patterns and best practices for writing effective, discoverable, maintainable skills (status: evergreen)
- [[skill-frontmatter-reference]] — Complete reference for all valid YAML frontmatter fields in skills (status: evergreen)
- [[VS Code Webview Testing]] — Three frameworks, nested-iframe structure, test pattern for vscode-gcode-extension (status: current)
- [[FrameLocator Chaining for Nested Iframes]] — Playwright pattern for reaching nested iframes like VS Code webviews (status: current)
- [[Electron Headless via Xvfb]] — Why Electron has no real headless mode and the xvfb-run recipe (status: current)
- [[VS Code Screenshot Determinism]] — Five axes to pin for reproducible docs screenshots (status: current)
- [[multiskill-workflow-patterns]] — Four composition shapes (linear, branch, loop, parallel) + Claude-as-orchestrator default (status: current)
- [[agent-handoff-artifact-pattern]] — Durable file/issue-body artifact between phases; fresh session per phase; two-store model (status: current)
- [[seed-brief-pattern]] — Upstream research brief seeds downstream specialists; skip-own-research contract (status: current)
- [[hierarchical-agent-decomposition]] — Parent → feature leads → specialists; TeamCreate unlocks nested teams (status: current)
- [[claude-workflow-phase-shape]] — Applied synthesis: discovery/define/implement phase shape in the claude-workflow plugin (status: current)
- [[claude-workflow-composition-codification]] — Codifying wiki standards into a plugin; template-split strategy; scaffolder question ordering (status: current)
- [[AskUserQuestion-in-skill-interviews]] — AskUserQuestion tool for bounded-choice Q&A in skill interviews; plain prompts for free-text; multiSelect for non-exclusive options (status: current)
- [[allowed-tools-semantics]] — `allowed-tools` pre-approves, does not restrict; SDK ignores the frontmatter; use deny rules or subagent `tools:` for real restriction (status: current)
- [[skill-vs-subagent-tool-fields]] — Skill `allowed-tools` (pre-approve) vs subagent `tools` (restrict) — same-looking fields, opposite semantics (status: current)
- [[allowed-tools-for-multi-agent-plugins]] — Role-based best practice for claude-workflow and similar plugins; default is omission; declare only for side-effect skills (status: current)

---

- [[Plugin Root Variable in Skills]] — where `${CLAUDE_PLUGIN_ROOT}` expands and the fallback pattern for shared protocol references in plugin skills (status: mature)
- [[claude-plugin-userconfig-schema]] — Claude Code plugin `userConfig` fields require `title` + `type` + `description`; install fails without them (status: current)
- [[claude-hook-template-variable-expansion]] — `${user_config.*}` expands in hooks.json command strings only, not in external scripts; pass as `$1` (status: current)
- [[claude-code-system-prompt-composition]] — the stack that fills /context's system-prompt counter; layers and levers (status: current)
- [[tool-search-tool-deferred-loading]] — Claude Code's on-demand MCP schema loader; ENABLE_TOOL_SEARCH tunables; 85% reported savings (status: current)
- [[mcp-tool-overhead]] — per-server token costs; zero-default workflow; CLI-over-MCP preference (status: current)
- [[claude-md-sizing]] — under-200-line target; hierarchical compose; when to move content into skills (status: current)
- [[sessionstart-hook-context-injection]] — hidden per-session token cost from plugin hooks; superpowers injects ~2.5k/session (status: current)
- [[subagent-spawn-mechanics]] — what loads into a Task-tool subagent at spawn; fresh context, prompt-string channel, one-message return (status: current)
- [[teamcreate-architecture]] — lead/teammates/task-list/mailbox; each teammate loads CLAUDE.md + MCP + skills; experimental flag + constraints (status: current)
- [[agent-scaling-empirical-evidence]] — Princeton NLP 64%, Google DeepMind up to −70% on sequential, wall-clock vs critical path, 3-6 agent sweet spot (status: current)
- [[subagent-vs-teamcreate-rubric]] — applied decision framework: communication pivot, file disjointness, classifiable-parallel shape, ≥3× wall-clock payoff threshold (status: current)

## Entities

- [[Andrej Karpathy]] — AI researcher, creator of the LLM Wiki pattern, former Tesla AI director (status: mature)
- [[Vannevar Bush]] — engineer who proposed the Memex (1945); conceptual ancestor of this vault (status: developing)
- [[qmd]] — local hybrid BM25/vector search for markdown files; Karpathy's recommended scaling tool (status: developing)
- [[Graphify]] — LLM Wiki implementation with EXTRACTED/INFERRED/AMBIGUOUS confidence-tagged property graph (status: current)
- [[Ar9av-obsidian-wiki]] — multi-agent compatible LLM Wiki plugin; delta tracking manifest (status: current)
- [[Nexus-claudesidian-mcp]] — native Obsidian plugin + MCP bridge; workspace memory, task management (status: current)
- [[ballred-obsidian-claude-pkm]] — goal cascade PKM; auto-commit hooks, /adopt command (status: current)
- [[rvk7895-llm-knowledge-bases]] — 3-depth query system, Marp slides, parallel deep research (status: current)
- [[kepano-obsidian-skills]] — official skills from Obsidian creator; defuddle, obsidian-bases (status: current)
- [[Claudian-YishenTu]] — native Obsidian plugin embedding Claude Code; plan mode, @mention (status: current)
- [[vscode-gcode-extension]] — VSCode LSP extension for G-code, 4-dialect CNC support, 3D visualizer (status: current)
- [[skill-creator-plugin]] — Official Anthropic plugin for interactive skill creation, testing, evaluation, and optimization (status: evergreen)
- [[wdio-vscode-service]] — WebdriverIO service for VS Code extension E2E testing with workbench page objects (status: current)
- [[vscode-extension-tester]] — Red Hat's Selenium-based VS Code extension UI tester (ExTester) (status: current)
- [[@vscode/test-electron]] — Microsoft's official low-level test runner + @vscode/test-cli config wrapper (status: current)
- [[Playwright]] — Microsoft browser automation; drives Electron for VS Code + cleaner webview-only shots (status: current)
- [[Superpowers Plugin]] — Jesse Vincent's (obra) agentic skills framework; structured dev methodology with TDD gates (status: current)
- [[Microsoft Agent Framework]] — Microsoft's multi-agent orchestration framework; Handoff pattern with typed routing edges (status: current)

---

## Solutions

- [[fs-readdir-dirent-typing]] — pass `encoding: 'utf8'` with `withFileTypes` to fix Dirent generic typing
- [[interface-extraction-import-type]] — use `import type` in interface files to eliminate source-level cycles
- [[variable-formatting-utilities]] — RenameUtils is the single source for variable key formatting
- [[workspace-symbol-architecture]] — four-layer Ctrl+T architecture with client-side enumeration
- [[client-side-enumeration-pattern]] — server asks client to enumerate files via custom LSP request; honors files.exclude
- [[lsp-file-watcher-linux]] — RelativePattern watcher avoids parcel-watcher cold-start flake on Linux
- [[server-provider-wiring-patterns]] — server.ts conventions: .catch() on async, apply at init+change, logger DI
- [[visualizer-variable-resolution-pipeline]] — VisualizerService resolves variables, not callers
- [[token-audit-misiekhardcore]] — concrete P1/P2/P3 plan to cut 9k+11k baseline by ~35-45% (trim CLAUDE.md, hot.md, disable redundant MCP, tune ENABLE_TOOL_SEARCH)

---

## Sources

- [[llm-wiki-karpathy-gist]] — 2026-04-17 | Karpathy's canonical LLM Wiki gist | 4 pages created, 3 updated
- [[llm-wiki-research-2026-04-20]] — 2026-04-20 | autoresearch on Karpathy gist ecosystem | 4 pages created, 1 updated
- [[claude-obsidian-ecosystem-research]] — 2026-04-08 | web research across 16+ repos | 8 wiki pages created
- [[vscode-gcode-extension-architecture]] — 2026-04-17 | codebase docs (CLAUDE.md, AGENTS.md, package.json) | architecture, patterns, rules
- [[claude-code-skills-official-docs]] — 2026-04-17 | Anthropic official documentation (code.claude.com) | skill anatomy, invocation, frontmatter
- [[wdio-vscode-service-docs]] — 2026-04-19 | WebdriverIO official docs + TypeDoc | WebView API, executeWorkbench, capabilities config
- [[vscode-extension-tester-extester]] — 2026-04-19 | Red Hat ExTester repo + wiki | Welcome-page gotcha, WebView page object, v8.23
- [[vscode-test-electron-cli]] — 2026-04-19 | Microsoft official | test-electron vs test-cli, config file, version pairing
- [[playwright-electron-vscode-testing]] — 2026-04-19 | Broadcom Medium + Playwright docs | _electron launch, frameLocator chain, no-headless
- [[hakanson-vscode-actions-xvfb]] — 2026-04-19 | Kevin Hakanson blog 2024 + dev.to 2025 | D-Bus fix, cache .vscode-test, argv.json
- [[MindStudio Skill Collaboration Pattern]] — 2026-04-19 | MindStudio blog 2026-03 | Claude-as-orchestrator; four-pattern taxonomy; sub-skill caveats
- [[Beam Multi-Agent Orchestration Patterns]] — 2026-04-19 | Beam.ai 2026 | Six patterns; infinite-handoff failure mode; framework comparison
- [[Microsoft Agent Framework Handoff Workflows]] — 2026-04-19 | Microsoft Learn 2026 | Official Handoff orchestration docs; HandoffBuilder; typed edges
- [[Addy Osmani Code Agent Orchestra]] — 2026-04-19 | Addy Osmani blog 2026 | Princeton NLP 64% finding; hierarchical decomposition; domain ownership
- [[ClaudeFast Agent Teams Guide]] — 2026-04-19 | ClaudeFast 2026 | Subagents + TeamCreate; CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS; file-based handoff
- [[Superpowers GitHub]] — 2026-04-19 | obra/superpowers 2025-10 | Primary source for Superpowers framework
- [[agent-skills-best-practices-anthropic]] — 2026-04-19 | platform.claude.com official docs | Skill authoring best practices; concision, progressive disclosure, evaluation-driven development
- [[claude-code-costs-docs]] — 2026-04 | code.claude.com/docs/en/costs | official reference for cost tracking + token reduction
- [[claude-code-token-optimization-2026]] — 2026-Q1 | buildtolaunch community guide | <500 token CLAUDE.md, context-rot threshold, March 2026 caching incident
- [[mindstudio-mcp-token-overhead]] — 2026-Q1 | MindStudio blog | per-MCP-server cost ranges, zero-default policy
- [[anthropic-tool-search-docs]] — 2025-11 | platform.claude.com | Tool Search Tool mechanism, defer_loading, 85% savings benchmark
- [[claude-code-agent-teams-docs]] — 2026-04 | code.claude.com/docs/en/agent-teams | official TeamCreate architecture, lead/teammates/mailbox, CLAUDE.md loads per teammate
- [[claude-code-sub-agents-docs]] — 2026-04 | code.claude.com/docs/en/sub-agents | official subagent spec, default types, context inheritance rules
- [[mindstudio-agent-teams-vs-subagents]] — 2026-03 | MindStudio blog | decision-rubric: teams for parallel pipelines, subagents for dynamic chains; 3-5x cheaper for batches
- [[charles-jones-agent-teams-when-beat-subagents]] — 2026-02 | charlesjones.dev | communication bottleneck argument; 3-4x cost; /batch as alternative
- [[google-deepmind-scaling-agent-systems]] — 2025-12 | arXiv 2512.08296 | 180-config study; sequential tasks degrade up to 70%; 87% predictive model

---

## Questions

- [[How does the LLM Wiki pattern work]] — how the pattern works and why it outperforms RAG at human scale (status: developing)
- [[Research VS Code Webview Testing and Screenshots]] — Synthesis: 3 frameworks, 9 deltas from raw plan, gotchas for vscode-gcode-extension (status: developing)
- [[Research: Multiskill Workflow Structure in claude-workflow]] — Synthesis: how claude-workflow composes skills (phase-level sub-skills, seed briefs, two-level team hierarchy, artifact handoff) (status: developing)
- [[Research: allowed-tools best practice for multi-agent workflow plugins]] — Synthesis: omit `allowed-tools` by default; pre-approve (not restrict); declare only for side-effect skills; fix claude-workflow AUTHORING.md (status: developing)
- [[Research Claude Code Token Optimization]] — Synthesis: system-prompt is a stack; trim CLAUDE.md + hot.md + SessionStart hooks; MCP defer by default; 35-45% reduction achievable (status: current)
- [[Research: Subagents vs TeamCreate Decision Rubric]] — Synthesis: verified 7× official multiplier; communication pivot is the primary decision criterion; sequential tasks degrade up to 70% under MAS; input for claude-workflow issue #30 (status: current)
- [[princeton-nlp-64-percent-unverified]] — Open: cannot locate primary Princeton NLP paper for the "64% of benchmarks" figure cited via Osmani's blog; downstream refs softened (status: seed)

---

## Comparisons

- [[Wiki vs RAG]] — when to use a wiki knowledge base versus RAG; verdict: wiki wins at <1000 pages
- [[claude-obsidian-ecosystem]] — feature matrix of 16+ Claude+Obsidian projects; where claude-obsidian wins and gaps

---

## Domains

<!-- Add domain entries here after scaffold -->
