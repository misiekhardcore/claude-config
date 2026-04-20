---
type: solution
title: "Workspace Symbol Architecture (Ctrl+T)"
project: "[[vscode-gcode-extension]]"
domain: lsp
severity: high
tags:
  - solution
  - lsp
  - architecture
  - client-side-enumeration
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-18
related:
  - "[[variable-formatting-utilities]]"
  - "[[lsp-file-watcher-linux]]"
  - "[[server-provider-wiring-patterns]]"
  - "[[multi-root-workspace-per-folder-config]]"
---

# Workspace Symbol Architecture

## Overview

The workspace symbol feature (VSCode Ctrl+T) has four architectural layers:

1. **WorkspaceSymbolVisitor** — AST visitor that extracts symbols from parsed programs
2. **WorkspaceSymbolIndex** — in-memory symbol storage and search
3. **WorkspaceIndexingService** — manages index lifecycle (startup scan, file-change reactions)
4. **WorkspaceSymbolProvider** — LSP handler that answers `workspace/symbol` requests

## Symbol Kinds

Three symbol categories extracted from G-code AST:

| Kind | Node Type | LSP Kind | Use Case |
|------|-----------|----------|----------|
| SubroutineDefinition | Function definition | `SymbolKind.Function` | Ctrl+T navigation |
| SubroutineLabel | Label/entry point | `SymbolKind.Module` | Jump targets |
| LineNumber | Numbered line (N-word) | `SymbolKind.Constant` | Step identification |
| VariableAssignment | Variable assignment | `SymbolKind.Variable` | First occurrence only |

## Index File Paths

Three events populate the index:

1. **onDidOpen** — When document opens, extract symbols and add to index
2. **onDidChangeContent** — When document edits occur, update symbols for that URI
3. **scanRoots** — On startup, recursively scan workspace roots and index all files

## Client-Side Enumeration (Issue #138)

The server advertises capability `supportsListIndexFiles`. The client's `WorkspaceFileEnumerator`:
- Reads `files.exclude` and `search.exclude` workspace settings
- Applies strict `=== true` matching (ignores glob patterns)
- Builds exclude glob from matched keys
- Calls `vscode.workspace.findFiles()` with the exclude pattern
- Passes file list to server for indexing

### Generation Counter & Cancellation

To prevent stale or orphan responses:
- Server maintains a generation counter (incremented on each scan)
- Client-side enumerator uses `CancellationTokenSource` per enumeration request
- Responses include generation ID; stale responses are discarded

## Watcher Model (Section 8, Q4)

Eventual-consistency model: watcher events unfiltered, next full rescan reconciles differences. This handles edge cases where file-change events may be missed or delayed.

## Known Limits

- No `files.watcherExclude` support (only `files.exclude` and `search.exclude`)

### Superseded

- ~~Single dialect per scan (no mixed-dialect workspace)~~ — resolved by #141 (PR #149). Multi-root workspaces now index each folder with its own `gcode.dialect` and per-folder excludes. See [[multi-root-workspace-per-folder-config]] for the pattern.
