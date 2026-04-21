---
type: meta
title: "Operation Log"
updated: 2026-04-20T00:00:00
tags:
  - meta
  - log
status: evergreen
confidence: EXTRACTED
evidence: []
created: 2026-04-17
related:
  - "[[index]]"
  - "[[hot]]"
  - "[[overview]]"
  - "[[sources/_index]]"
---

# Operation Log

## [2026-04-21] save | Play Assertion Runner Architecture — PR1 actuals

- Type: concept (update)
- Location: wiki/concepts/play-assertion-runner-architecture.md
- From: /compound after #23365 PR1 (#23380) implementation cycle
- Changes: fixed stale PR plan (old plan had PR1 = CPT runner via #3498; actual PR1 is standalone scaffolding); added prototype comparison table; added PR1 deliverables detail; added new evidence files for PR1 artifacts

## [2026-04-20] schema-migration | Typed relationships + confidence tagging (issue #11)

- Trigger: `/implement 11`
- Pages created: none
- Pages updated: [[frontmatter]], [[maintenance-rules]], 33 concept pages, 18 entity pages, 17 source pages, 2 comparison pages, 4 question pages
- Contradictions resolved: none
- Key findings: (1) added `confidence: EXTRACTED|INFERRED|AMBIGUOUS` as universal field to all 74 wiki pages; (2) added `evidence:` flat list to all pages; (3) source-type pages renamed `confidence: high|medium|low` to `source_reliability:`; (4) added 7 typed relationship fields (`supersedes`, `contradicts`, `uses`, `depends_on`, `caused`, `fixed`, `implements`) to frontmatter schema; (5) typed relationships applied to 14 pages where semantic is unambiguous

## [2026-04-20] compound | Wiki Memory Lifecycle: Consolidation Tier Implementation Pattern

- New page: [[wiki-memory-lifecycle-tier-implementation]]
- Cross-links: [[llm-wiki-v2-extensions]], [[wiki-frontmatter-schema-extension]]
- Key insights: explicit `tier:` field (not computed), per-skill tables intentionally scoped, migration bootstraps clock from today, canonical callout format lives in one place

## [2026-04-20] save | Wiki Frontmatter Schema Extension Pattern

- Type: concept
- Location: wiki/concepts/wiki-frontmatter-schema-extension.md
- From: implementing issue #11 (typed relationships + confidence tagging across 97 wiki pages)

## [2026-04-20] autoresearch | Karpathy LLM Wiki gist ecosystem (2 rounds)

- Rounds: 2 | Searches: 3 | Fetches: 3
- Trigger: `/autoresearch https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f`
- Prior ingest: [[llm-wiki-karpathy-gist]] (2026-04-17) — this session extends it with post-publication ecosystem
- Pages created: [[llm-wiki-v2-extensions]], [[knowledge-compounding-economics]], [[Graphify]], [[llm-wiki-scalability-critique]], [[llm-wiki-research-2026-04-20]]
- Pages updated: [[LLM Wiki Pattern]] (Scale Limits, Ecosystem, Academic Validation sections), [[index]], [[hot]], [[log]]
- Key findings: (1) LLM Wiki v2 (rohitg00) adds memory lifecycle, typed graph, hybrid search; (2) arXiv:2604.11243 empirically validates 84.6% token savings vs RAG; (3) Graphify implements EXTRACTED/INFERRED/AMBIGUOUS confidence tagging; (4) ~1000-file collapse is the documented production failure mode; (5) Gist now at 4,713 forks, 485+ comments

## [2026-04-19] autoresearch | allowed-tools best practice for multi-agent workflow plugins

- Rounds: 2 | Searches: 4 | Fetches: 3
- Sources found: 2 official (code.claude.com/skills, platform.claude.com best-practices) + anthropics/skills repo confirmation
- Pages created: [[allowed-tools-semantics]], [[skill-vs-subagent-tool-fields]], [[allowed-tools-for-multi-agent-plugins]], [[agent-skills-best-practices-anthropic]]
- Synthesis: [[Research: allowed-tools best practice for multi-agent workflow plugins]]
- Pages updated: [[index]], [[hot]]
- Key finding: `allowed-tools` in SKILL.md pre-approves (not restricts); omit by default for orchestrator/specialist skills; declare only for side-effect skills paired with `disable-model-invocation: true`. claude-workflow's existing 17 skills correctly omit it, but `_templates/AUTHORING.md` describes the field incorrectly as "restricts" — fix needed.

## [2026-04-19] compound | AskUserQuestion in Skill Interviews

- Pages created: [[AskUserQuestion-in-skill-interviews]]
- Pages updated: [[index]], [[hot]]
- From: applying `AskUserQuestion` tool to `/new-skill` and `/grill-me` skill Q&A flows
- Key insights: bounded choices (2-4 options) → AskUserQuestion with header/options/multiSelect; free-text → plain prompt; "Other" auto-added; recommended option first with ` (Recommended)`; 4-option limit means multi-protocol selection splits into two sequential calls; multi-question calls only for independent questions

## [2026-04-19] compound | claude-workflow Composition Codification (issue #13, PR #14)

- Pages created: [[claude-workflow-composition-codification]]
- Pages updated: [[Research: Multiskill Workflow Structure in claude-workflow]] (closed G1 and G2 open questions), [[index]], [[hot]]
- From: `claude-workflow:implement 13` — codifying multi-skill composition standards in the plugin
- Key insights: (1) when wiki standards are not in the repo, add a shared reference file (`_shared/composition.md`) — documentation-only fix; (2) split role-specific templates (orchestrator/specialist/primitive) to eliminate conditional logic in scaffolders; (3) scaffolder question dependency invariant: Description before Role so Role can recommend based on description; (4) `_shared/composition.md` is now canonical for seed-brief field names (supersedes wiki page prose)
- Staleness flag: [[seed-brief-pattern]] field names differ from composition.md — update when next editing that page

## [2026-04-19] autoresearch | Multiskill Workflow Structure in claude-workflow

- Rounds: 1 | Searches: 4 + 2 fetches | Pages created: 12
- Sources: [[MindStudio Skill Collaboration Pattern]], [[Beam Multi-Agent Orchestration Patterns]], [[Microsoft Agent Framework Handoff Workflows]], [[Addy Osmani Code Agent Orchestra]], [[ClaudeFast Agent Teams Guide]], [[Superpowers GitHub]]
- Concepts: [[multiskill-workflow-patterns]], [[agent-handoff-artifact-pattern]], [[seed-brief-pattern]], [[hierarchical-agent-decomposition]], [[claude-workflow-phase-shape]]
- Entities: [[Superpowers Plugin]], [[Microsoft Agent Framework]]
- Synthesis: [[Research: Multiskill Workflow Structure in claude-workflow]]
- Key finding: claude-workflow's structure aligns with the 2026 multi-agent consensus — durable artifact handoff between phases (GitHub issue body), seed briefs within phases (research team → specialists), two-level team hierarchy via TeamCreate, single-agent default (Princeton NLP: single agent beats multi on 64% of tasks). The recent Prior-Art Scout hoisting in `/discovery` matches the seed-brief pattern already used in `/define → /architecture`.
- Open questions: TeamCreate env-var gating (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`) not documented in README; other specialist skills (`/architecture`, `/design`, `/specify`) lack explicit `## Input` sections for seed briefs.

## [2026-04-19] autoresearch | VS Code Webview Testing and Screenshots

- Rounds: 2 | Searches: 8 | Pages created: 10
- Sources: [[wdio-vscode-service-docs]], [[vscode-extension-tester-extester]], [[vscode-test-electron-cli]], [[playwright-electron-vscode-testing]], [[hakanson-vscode-actions-xvfb]]
- Concepts: [[VS Code Webview Testing]], [[FrameLocator Chaining for Nested Iframes]], [[Electron Headless via Xvfb]], [[VS Code Screenshot Determinism]]
- Entities: [[wdio-vscode-service]], [[vscode-extension-tester]], [[@vscode/test-electron]], [[Playwright]]
- Synthesis: [[Research VS Code Webview Testing and Screenshots]]
- Key finding: Raw plan's wdio-vscode-service choice is correct; 9 refinements identified (pin VS Code version, close Welcome editor, fix Xvfb resolution, add D-Bus/GPU workarounds, pin fontFamily, cache .vscode-test, use Playwright for webview-only shots, handle WebGL-in-Xvfb blank-canvas risk).

## [2026-04-18] compound | Progress Reporting Two-Role Model (issue #139, PR #150)

- Pages updated: [[server-provider-wiring-patterns]] (added orchestrator-vs-producer section, LspBoundProgressReporter narrowing, title convention, intra-phase throttling pattern, test-determinism technique), [[hot]]

## [2026-04-18] compound | Multi-Root Workspace Per-Folder Config (issue #141, PR #149)

- Pages created: [[multi-root-workspace-per-folder-config]]
- Pages updated: [[concepts/_index]], [[index]], [[workspace-symbol-architecture]] (superseded "Known Limits" single-dialect-per-scan), [[hot]]
- From: vscode-gcode-extension `/claude-workflow:implement 141` cycle
- Key insights: (1) `vscode.workspace.getConfiguration(undefined, scope)` for folder-scoped reads; (2) `vscode.RelativePattern` scopes `findFiles` per root so per-folder excludes apply; (3) longest-prefix matching (not first-match) when resolving which root owns a file — matters for nested/overlapping roots.

## [2026-04-17] compound | Structured Parse Error Location (issue #146)

- Pages created: [[Structured Parse Error Location]]
- Pages updated: [[G-code LSP Architecture]] (added reference to new errors module), [[hot]]

## [2026-04-17] compound | Plugin Root Variable in Skills

- Pages created: [[Plugin Root Variable in Skills]]
- Pages updated: [[concepts/_index]], [[index]], [[hot]]
- Source: claude-workflow PR #7 (stage #3 of plugin extraction, 17-skill migration)
- Key insight: `${CLAUDE_PLUGIN_ROOT}` is officially guaranteed to expand only in hook commands and MCP server configs. In SKILL.md body text, Claude resolves it contextually — soft resolution, not documented. Pair the variable with a fallback pattern in `CLAUDE.md` pointing at the plugin cache glob so the plugin stays functional across Claude Code versions.

Navigation: [[index]] | [[hot]] | [[overview]]

Append-only. New entries go at the TOP. Never edit past entries.

Entry format: `## [YYYY-MM-DD] operation | Title`

Parse recent entries: `grep "^## \[" wiki/log.md | head -10`

---

## [2026-04-17] research | Claude Code Skills Creation Patterns

- Type: autonomous research loop
- Query: How are Claude Code skills / slash commands created and structured? Authoritative sources, patterns, conventions.
- Sources: 3 search rounds covering official Anthropic docs (code.claude.com), installed skill-creator plugin (31KB), sample skills from ecosystem
- Pages created: [[claude-skill-anatomy]], [[skill-invocation-model]], [[skill-creation-patterns]], [[skill-frontmatter-reference]], [[skill-creator-plugin]]
- Pages updated: [[index]], [[hot]]
- Confidence: High (official Anthropic docs + official skill-creator plugin)
- Key findings: Frontmatter is YAML with `name`, `description` (recommended), `disable-model-invocation`, `user-invocable`, `allowed-tools`, `context`, `agent`, `effort`, `model`, `paths` fields. Descriptions are the sole invocation trigger — must list specific use cases. Claude undertriggers; make descriptions "pushy". Skills follow Agent Skills standard + Claude extensions. skill-creator plugin provides interactive draft → test → improve → optimize loop with eval viewer and benchmark automation.
- Open questions: None; full coverage of creation patterns, anatomy, invocation model, frontmatter reference, and tool.

## [2026-04-17] compound | Wiki Lint False Positives on Non-MD Files

- Pages created: [[Wiki Lint False Positives on Non-MD Files]]
- Pages updated: [[concepts/_index]]
- Key insight: wiki-lint checks only .md targets; .canvas and .base files are valid wikilink targets in Obsidian and must not be removed

## [2026-04-17] research | Per-Project Knowledge Management Strategies

- Type: research
- Query: How should per-project knowledge be managed in Andrej Karpathy's LLM Wiki / claude-obsidian integration pattern?
- Sources: 6 web searches covering Karpathy's original pattern, multi-vault Obsidian architecture, and 16+ ecosystem implementations
- Pages created: [[per-project-knowledge]]
- Pages updated: [[index]], [[log]], [[hot]]
- Key finding: Hybrid pattern (shared reusable patterns + per-project isolated knowledge) recommended for multi-project ecosystems; pure centralization works <500 pages with homogeneous domains; per-project isolation ideal for privacy/proprietary work
- Decision: Hybrid starting point for vscode-gcode-extension (keep shared wiki, add `.claude/wiki/` for project-specific future knowledge)

## [2026-04-17] save | PR Feedback Resolution + Wiki Migration — vscode-gcode-extension #145

- Type: session
- Location: wiki/meta/pr-feedback-resolution-wiki-migration-2026-04-17.md
- From: resolved 10 Copilot threads on PR #145 (parallel agents), migrated solution docs to wiki, discovered GraphQL is required to resolve threads (REST cannot)

## [2026-04-17] ingest | vscode-gcode-extension solution docs

- Source: `.claude/docs/solutions/` (7 files from vscode-gcode-extension project)
- Pages created: [[fs-readdir-dirent-typing]], [[interface-extraction-import-type]], [[variable-formatting-utilities]], [[workspace-symbol-architecture]], [[lsp-file-watcher-linux]], [[server-provider-wiring-patterns]], [[visualizer-variable-resolution-pipeline]], [[vscode-gcode-extension]]
- Pages updated: [[index]], [[hot]]
- Key insight: Seven ADR-style solution docs from a VS Code LSP extension covering TypeScript typing traps, LSP wiring conventions, and a Linux file-watcher flake caused by parcel-watcher cold-start.

## [2026-04-17] ingest | LLM Wiki — Karpathy Gist

- Type: gist (idea file)
- Source: `.raw/articles/llm-wiki-karpathy-2026-04-04.md`
- Summary: [[llm-wiki-karpathy-gist]]
- Pages created: [[llm-wiki-karpathy-gist]], [[Memex]], [[Vannevar Bush]], [[qmd]]
- Pages updated: [[LLM Wiki Pattern]], [[Andrej Karpathy]], [[index]], [[hot]], [[overview]], [[sources/_index]], [[entities/_index]], [[concepts/_index]]
- Key insight: the gist is the canonical upstream for this vault's whole architecture. Adds historical lineage (Bush/Memex) and a concrete scaling tool (qmd) that had been implicit.

## [2026-04-08] save | claude-obsidian v1.4 Release Session

- Type: session
- Location: wiki/meta/claude-obsidian-v1.4-release-session.md
- From: full release cycle covering v1.1 (URL/vision/delta tracking, 3 new skills), v1.4.0 (audit response, multi-agent compat, Bases dashboard, em dash scrub, security history rewrite), and v1.4.1 (plugin install command hotfix)
- Key lessons: plugin install is 2-step (marketplace add then install), allowed-tools is not valid frontmatter, Bases uses filters/views/formulas not Dataview syntax, hook context does not survive compaction, git filter-repo needs 2 passes for full scrub

## [2026-04-08] ingest | Claude + Obsidian Ecosystem Research

- Type: research ingest
- Source: `.raw/claude-obsidian-ecosystem-research.md`
- Queries: 6 parallel web searches + 12 repo deep-reads
- Pages created: [[claude-obsidian-ecosystem]], [[cherry-picks]], [[claude-obsidian-ecosystem-research]], [[Ar9av-obsidian-wiki]], [[Nexus-claudesidian-mcp]], [[ballred-obsidian-claude-pkm]], [[rvk7895-llm-knowledge-bases]], [[kepano-obsidian-skills]], [[Claudian-YishenTu]]
- Key finding: 16+ active Claude+Obsidian projects; 13 cherry-pick features identified for v1.3.0+
- Top gap confirmed: no delta tracking, no URL ingestion, no auto-commit

## [2026-04-07] session | Full Audit, System Setup & Plugin Installation

- Type: session
- Location: wiki/meta/full-audit-and-system-setup-session.md
- From: 12-area repo audit, 3 fixes, plugin installed to local system, folder renamed

## [2026-04-07] session | claude-obsidian v1.2.0 Release Session

- Type: session
- Location: wiki/meta/claude-obsidian-v1.2.0-release-session.md
- From: full build session — v1.2.0 plan execution, cosmic-brain→claude-obsidian rename, legal/security audit, branded GIFs, PDF install guide, dual GitHub repos

- Source: `.raw/` (first ingest)
- Pages updated: [[index]], [[log]], [[hot]], [[overview]]
- Key insight: The wiki pattern turns ephemeral AI chat into compounding knowledge — one user dropped token usage by 95%.

## [2026-04-07] setup | Vault initialized

- Plugin: claude-obsidian v1.1.0
- Structure: seed files + first ingest complete
- Skills: wiki, wiki-ingest, wiki-query, wiki-lint, save, autoresearch
