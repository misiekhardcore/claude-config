---
type: meta
title: "Wiki Index"
updated: 2026-04-17
created: 2026-04-17
tags:
  - meta
  - index
status: evergreen
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

Last updated: 2026-04-17 | Total pages: 45 | Sources ingested: 5

Navigation: [[overview]] | [[log]] | [[hot]] | [[dashboard]] | [[Wiki Map]] | [[getting-started]]

---

## Concepts

- [[LLM Wiki Pattern]] — the pattern for building persistent, compounding knowledge bases using LLMs (status: mature)
- [[Hot Cache]] — ~500-word session context file, updated after every ingest and session (status: mature)
- [[Compounding Knowledge]] — why wiki knowledge grows more valuable over time, unlike RAG (status: mature)
- [[Memex]] — Bush's 1945 precursor to the LLM wiki pattern; associative trails between documents (status: developing)
- [[cherry-picks]] — prioritized feature backlog from ecosystem research; 13 features to add to claude-obsidian (status: current)
- [[gcode-lsp-architecture]] — Five-layer Lexer → Parser → AST → Services → Adapters pipeline for LSP extensions (status: current)
- [[per-project-knowledge]] — centralized vs. per-project vault strategies for multi-project knowledge management (status: current)
- [[claude-skill-anatomy]] — Structure of Claude Code skills: frontmatter, markdown body, supporting files, directory layout (status: evergreen)
- [[skill-invocation-model]] — How Claude Code skills are triggered: user manual invocation vs. automatic Claude invocation (status: evergreen)
- [[skill-creation-patterns]] — 13 patterns and best practices for writing effective, discoverable, maintainable skills (status: evergreen)
- [[skill-frontmatter-reference]] — Complete reference for all valid YAML frontmatter fields in skills (status: evergreen)

---

- [[Plugin Root Variable in Skills]] — where `${CLAUDE_PLUGIN_ROOT}` expands and the fallback pattern for shared protocol references in plugin skills (status: mature)

## Entities

- [[Andrej Karpathy]] — AI researcher, creator of the LLM Wiki pattern, former Tesla AI director (status: mature)
- [[Vannevar Bush]] — engineer who proposed the Memex (1945); conceptual ancestor of this vault (status: developing)
- [[qmd]] — local hybrid BM25/vector search for markdown files; Karpathy's recommended scaling tool (status: developing)
- [[Ar9av-obsidian-wiki]] — multi-agent compatible LLM Wiki plugin; delta tracking manifest (status: current)
- [[Nexus-claudesidian-mcp]] — native Obsidian plugin + MCP bridge; workspace memory, task management (status: current)
- [[ballred-obsidian-claude-pkm]] — goal cascade PKM; auto-commit hooks, /adopt command (status: current)
- [[rvk7895-llm-knowledge-bases]] — 3-depth query system, Marp slides, parallel deep research (status: current)
- [[kepano-obsidian-skills]] — official skills from Obsidian creator; defuddle, obsidian-bases (status: current)
- [[Claudian-YishenTu]] — native Obsidian plugin embedding Claude Code; plan mode, @mention (status: current)
- [[vscode-gcode-extension]] — VSCode LSP extension for G-code, 4-dialect CNC support, 3D visualizer (status: current)
- [[skill-creator-plugin]] — Official Anthropic plugin for interactive skill creation, testing, evaluation, and optimization (status: evergreen)

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

---

## Sources

- [[llm-wiki-karpathy-gist]] — 2026-04-17 | Karpathy's canonical LLM Wiki gist | 4 pages created, 3 updated
- [[claude-obsidian-ecosystem-research]] — 2026-04-08 | web research across 16+ repos | 8 wiki pages created
- [[vscode-gcode-extension-architecture]] — 2026-04-17 | codebase docs (CLAUDE.md, AGENTS.md, package.json) | architecture, patterns, rules
- [[claude-code-skills-official-docs]] — 2026-04-17 | Anthropic official documentation (code.claude.com) | skill anatomy, invocation, frontmatter

---

## Questions

- [[How does the LLM Wiki pattern work]] — how the pattern works and why it outperforms RAG at human scale (status: developing)

---

## Comparisons

- [[Wiki vs RAG]] — when to use a wiki knowledge base versus RAG; verdict: wiki wins at <1000 pages
- [[claude-obsidian-ecosystem]] — feature matrix of 16+ Claude+Obsidian projects; where claude-obsidian wins and gaps

---

## Domains

<!-- Add domain entries here after scaffold -->
