---
type: entity
title: "vscode-gcode-extension"
kind: repo
created: 2026-04-17
updated: 2026-04-20
tags:
  - entity
  - vscode
  - lsp
  - typescript
  - g-code
  - cnc
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[workspace-symbol-architecture]]"
  - "[[lsp-file-watcher-linux]]"
  - "[[solutions/_index]]"
---

# vscode-gcode-extension

VSCode Language Server Protocol (LSP) extension for G-code / CNC machine code.

## Overview

Provides full language support for G-code programming:
- Syntax highlighting for four G-code dialects
- Code formatting with dialect-specific conventions
- Hover documentation for commands
- Autocomplete for G/M-codes
- Diagnostics and error reporting
- Symbol navigation (Ctrl+T workspace symbol)
- Rename refactoring for variables
- 3D tool-path visualizer (webview)
- Code folding

Published under "QuickBoyz" on VSCode Marketplace.

## Architecture

Strict layered architecture following Lexer → Parser → AST → Services → VSCode Adapters:

1. **Lexer** — Hand-written token scanner with case-insensitive keyword lookup
2. **Parser** — Consumes tokens, produces immutable AST; dialect-specific subclasses
3. **AST** — Pure domain classes (ProgramNode, StatementNode, MotionCommandNode, etc.)
4. **Services** — Formatter, variable analysis, AST analysis, file watching, visualization
5. **Adapters** — LSP server and VSCode extension client (thin, no business logic)

## Dialect Support

Four G-code dialects:
- LinuxCNC (default)
- Fanuc
- Haas
- Siemens

Formatters, command databases, and data providers are strategy-selected per dialect via factory pattern.

## Tech Stack

- **Language**: TypeScript (strict typing, no `any`)
- **Build**: tsc with `tsconfig.build.json`
- **Tests**: Jest (unit), Mocha (e2e in VS Code Extension Host)
- **Testing CLI**: @vscode/test-cli
- **Package Manager**: npm
- **Linting**: ESLint (flat config)

## Key Patterns

- **Visitor pattern** for AST traversal (formatting, semantic analysis, diagnostics)
- **Factory pattern** for dialect selection (LexerFactory, ParserFactory, FormatterFactory, DataProviderFactory)
- **Strategy pattern** for dialect-specific implementations (formatters, command databases, data providers)
- **Composite pattern** for AST tree structure (ProgramNode → StatementNode → child nodes)
- **Adapter pattern** for VS Code LSP integration

## Core Concepts

### Layered Pipeline
The extension follows a strict five-layer architecture. Each layer depends only on the layer directly below it:

1. **Lexer** (`src/lexer/GCodeScanner`) — Hand-written character scanner, no parsing logic
2. **Parser** (`src/parser/BaseParser`, dialect subclasses) — Token consumer, produces immutable AST
3. **AST** (`src/parser/nodes/`) — Pure domain classes, all properties readonly
4. **Services** (formatters, analyzers, visualizer) — Consume AST, never mutate it
5. **Adapters** (`src/server/`, `src/client/`) — Thin LSP/VSCode integration, no business logic

See [[gcode-lsp-architecture]] for detailed pipeline design.

### Dialect System
Four supported G-code dialects (LinuxCNC, Fanuc, Haas, Siemens) configured via `gcode.dialect` setting. Each dialect has:
- Formatter (`src/formatter/dialects/`)
- Command database (`src/databases/dialects/`)
- Data provider (`src/providers/dialects/`)

Dialect selection uses factory pattern; all four dialects must be considered when adding dialect-sensitive features.

### Key Services

| Service | Purpose | Layer |
|---------|---------|-------|
| **GCodeLexer** | Tokenize source code | Lexer |
| **BaseParser** / dialect subclasses | Build AST from tokens | Parser |
| **AstTraverser** | Walk AST and dispatch to visitor | Services |
| **FormatterService** | Apply dialect-specific formatting | Services |
| **DocumentStateManager** | Cache ASTs per document URI | Services |
| **AstAnalysisService** | Semantic analysis (scopes, types) | Services |
| **VariableAnalysisService** | Variable resolution and tracking | Services |
| **NodeFinder** | Locate nodes by position | Services |
| **GCodePathExtractor** | Convert AST to 3D tool-path segments | Services |
| **WorkspaceIndexingService** | Workspace symbol cache and sync | Services |

## Development

### Commands

| Command | Purpose |
|---------|---------|
| `npm run build` | Clean, compile with tsc |
| `npm run build:e2e` | Build + compile e2e tests |
| `npm test` | Jest unit tests |
| `npm run test:e2e` | Mocha tests in VS Code Extension Host |
| `npm run test:all` | Unit + E2E tests |
| `npm run lint` | ESLint check |
| `npm run typecheck` | Type check only |
| `npm run package` | Build + package .vsix |

### Test Strategy

- **Unit tests** (Jest): `src/test/` — test services in isolation by constructing ASTs directly
- **E2E tests** (Mocha): `src/e2e/suite/` — test LSP handlers in real VS Code Extension Host
- **TDD rule**: Use TDD for all logic-heavy code (parsers, visitors, analyzers, formatters, services)

### File Organization

```
src/
  lexer/         → GCodeScanner, Lexer, Token definitions
  parser/        → BaseParser, dialect subclasses, AstFactory, AstTraverser
  parser/nodes/  → ProgramNode, StatementNode, MotionCommandNode, etc.
  formatter/     → BaseFormatter, dialect subclasses, FormatterFactory
  databases/     → Command reference data per dialect
  visualizer/    → GCodePathExtractor, 3D segment types
  providers/     → LSP service layer, BaseProvider, DocumentStateManager
  server/        → LSP server entry point
  client/        → VSCode extension entry point
```

## Design Principles

- **No `any` types** — strict typing enforced
- **No AST mutation** — AST is immutable after parsing, services only read it
- **No business logic in adapters** — VS Code handlers delegate to services
- **Parseability first** — parsing errors must be recoverable with token position info
- **Dialect-aware design** — all four dialects must be supported, use strategy pattern

## Architecture Documentation

Full architectural details at [[gcode-lsp-architecture]]. Solution patterns and design decisions documented in:

- [[workspace-symbol-architecture]] — Ctrl+T symbol navigation (four-layer design)
- [[client-side-enumeration-pattern]] — File enumeration respecting files.exclude/search.exclude
- [[lsp-file-watcher-linux]] — Reliable file watching on Linux
- [[server-provider-wiring-patterns]] — Server.ts conventions and error handling
- [[visualizer-variable-resolution-pipeline]] — Variable resolution in 3D visualization

## Repository

- **Source**: https://github.com/QuickBoyz/vscode-gcode-extension
- **VSCode Marketplace**: Published under "QuickBoyz"
- **Version**: 2.4.0
- **Minimum VSCode**: 1.85.0
- **License**: MIT
