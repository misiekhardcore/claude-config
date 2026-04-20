---
type: meta
title: "Concepts Index"
updated: 2026-04-17
created: 2026-04-17
tags:
  - meta
  - index
  - concept
domain: knowledge-management
status: evergreen
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[index]]"
  - "[[dashboard]]"
  - "[[Wiki Map]]"
  - "[[Hot Cache]]"
  - "[[LLM Wiki Pattern]]"
  - "[[Compounding Knowledge]]"
  - "[[Memex]]"
---

# Concepts Index

Navigation: [[index]] | [[entities/_index]] | [[sources/_index]]

All concept pages — ideas, patterns, and frameworks extracted from sources.

---

## Knowledge Management

- [[LLM Wiki Pattern]] — the core architecture for persistent, compounding knowledge bases
- [[Hot Cache]] — ~500-word session context file, updated after every ingest
- [[Compounding Knowledge]] — why the wiki grows more valuable over time, unlike RAG
- [[Memex]] — Vannevar Bush's 1945 precursor; intellectual lineage for the LLM wiki pattern

---

## Workflow & Context

Context-hygiene guidance for the multi-phase `/discovery → /define → /implement` workflow now lives inside the `claude-workflow` plugin — see `${CLAUDE_PLUGIN_ROOT}/docs/context-hygiene.md` (reachable via `claude plugin` installs).

---

## Claude Code Plugins & Skills

- [[claude-skill-anatomy]] — skill file structure, frontmatter fields, directory layout
- [[skill-invocation-model]] — manual vs automatic invocation, description field mechanics
- [[skill-creation-patterns]] — 13 best practices for writing effective skills
- [[skill-frontmatter-reference]] — complete YAML frontmatter field reference
- [[Plugin Root Variable in Skills]] — where `${CLAUDE_PLUGIN_ROOT}` expands (hook/MCP vs skill body) and the fallback pattern for shared protocol references

## LSP & Language Tools

- [[gcode-lsp-architecture]] — Strict five-layer Lexer → Parser → AST → Services → Adapters pipeline; visitor/factory/strategy patterns
- [[multi-root-workspace-per-folder-config]] — Reading VSCode settings and enumerating files per workspace folder; longest-prefix matching for overlapping roots

---

## TypeScript & Typing

- [[TypeScript Typing Patterns]] — Advanced patterns for generic disambiguation, interface import cycles, and file-type utilities

---

## Integration & Tooling

- [[Obsidian MCP Wiring]] — Integrating Obsidian vaults with Model Context Protocol servers
- [[per-project-knowledge]] — Centralized vs. per-project vault strategies for multi-project knowledge management

---

## Wiki Maintenance

- [[Wiki Lint False Positives on Non-MD Files]] — lint agent incorrectly flags .canvas/.base links as dead; check all extensions before removing

---

## Add new concepts here as they are extracted from sources.
