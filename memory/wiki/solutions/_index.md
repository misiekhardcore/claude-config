---
type: meta
title: "Solutions Index"
project: "[[vscode-gcode-extension]]"
created: 2026-04-17
updated: 2026-04-20
tags:
  - meta
  - solutions
  - index
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: EXTRACTED
evidence: []
related:
  - "[[index]]"
  - "[[vscode-gcode-extension]]"
---

# Solutions

Architectural decisions, patterns, and bug fixes from the vscode-gcode-extension project.

## TypeScript & Type Safety

- [[fs-readdir-dirent-typing]] — pass `encoding: 'utf8'` with `withFileTypes` to fix Dirent generic typing
- [[interface-extraction-import-type]] — use `import type` in interface files to eliminate source-level cycles

## Services & Utilities

- [[variable-formatting-utilities]] — RenameUtils is the single source for variable key formatting
- [[visualizer-variable-resolution-pipeline]] — VisualizerService resolves variables, not callers

## Language Server Protocol (LSP)

- [[workspace-symbol-architecture]] — four-layer Ctrl+T architecture with client-side enumeration
- [[client-side-enumeration-pattern]] — server asks client to enumerate files via custom LSP request; honors files.exclude
- [[lsp-file-watcher-linux]] — RelativePattern watcher avoids parcel-watcher cold-start flake on Linux

## Server Integration

- [[server-provider-wiring-patterns]] — server.ts conventions: .catch() on async, apply at init+change, logger DI
