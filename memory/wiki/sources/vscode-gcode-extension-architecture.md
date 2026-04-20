---
type: source
title: "VSCode G-Code Extension Architecture & Development"
created: 2026-04-17
updated: 2026-04-20
tags:
  - architecture
  - lsp
  - vscode-extension
  - typescript
status: current
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
source_repo: "https://github.com/QuickBoyz/vscode-gcode-extension"
source_files:
  - ".claude/CLAUDE.md"
  - "AGENTS.md"
  - "package.json"
related:
  - "[[vscode-gcode-extension]]"
  - "[[gcode-lsp-architecture]]"
  - "[[workspace-symbol-architecture]]"
evidence: []
---

# Source: VSCode G-Code Extension Architecture & Development

**Type**: Codebase documentation (CLAUDE.md, AGENTS.md, package.json)
**Date**: 2026-04-17
**Source Repo**: https://github.com/QuickBoyz/vscode-gcode-extension (branch: main)
**Version**: 2.4.0

## Summary

Complete architectural overview of the vscode-gcode-extension, a production Language Server Protocol (LSP) extension for G-code / CNC machine code. Provides strict layered architecture documentation, mandatory engineering rules, development workflow, and test strategy.

## Pages Created from This Source

1. **[[gcode-lsp-architecture]]** — Complete five-layer pipeline (Lexer → Parser → AST → Services → Adapters), design patterns, dialect system, error recovery, testing strategy
2. **Updated [[vscode-gcode-extension]]** — Full entity page with architecture overview, core concepts, services table, development commands, file organization, design principles

## Key Insights

### 1. Strict Layered Architecture

Five immovable layers with strict dependency rules:

| Layer | Responsibility | Key Classes |
|-------|-----------------|-------------|
| Lexer | Tokenize source | GCodeScanner, LexerFactory |
| Parser | Build AST | BaseParser + dialect subclasses, ParserFactory |
| AST | Domain model | ProgramNode, StatementNode, MotionCommandNode, etc. |
| Services | Analyze & transform | Formatter, Analyzers, Visualizer, DocumentStateManager |
| Adapters | LSP/VSCode integration | Language server, extension client |

**Rule**: Each layer depends only on the layer below. No circular dependencies. No layer-skipping.

### 2. Design Patterns (Required)

- **Visitor pattern** — All AST traversal (formatter, analyzers, services) uses `AstVisitor<T>` + `BaseAstVisitor<T>` + `AstTraverser`
- **Factory pattern** — Dialect selection: `ParserFactory.create(dialect)`, `FormatterFactory`, `DataProviderFactory`
- **Strategy pattern** — Dialect-specific implementations (LinuxCNC, Fanuc, Haas, Siemens formatters and databases)
- **Composite pattern** — AST tree structure (ProgramNode → StatementNode → child nodes)
- **Adapter pattern** — VS Code API integration (thin, no business logic)

### 3. Dialect System

Four supported G-code dialects:
- **LinuxCNC** (default) — Extended G-code with named variables
- **Fanuc** — Industry standard for mills/lathes
- **Haas** — Mill-specific extended features
- **Siemens** — Sinumerik extended range

Each dialect requires:
- Formatter in `src/formatter/dialects/`
- Command database in `src/databases/dialects/`
- Data provider in `src/providers/dialects/`

All four dialects must be considered when adding dialect-sensitive features.

### 4. Immutable AST Principle

The AST is the single source of truth. All properties are `readonly`. No mutation after parsing. Parse errors are recoverable via `ErrorNode` (not exceptions).

Benefits:
- Services can safely process partial/errored programs
- Hover, completion, and formatting work even with syntax errors
- Position info included in error nodes for diagnostics

### 5. Mandatory Engineering Rules

**TypeScript**:
- Strict: true (no `any` types)
- Prefer `readonly`, `private`, composition over inheritance
- Enums over union types for fixed sets
- Named constants for all magic values
- Declare variables separately (no comma syntax)

**Architecture**:
- No business logic in VS Code providers — delegate to services
- No AST mutation after parsing
- No `instanceof` chains — use visitor/polymorphism
- No circular dependencies
- Domain-specific error types (not raw `Error`)

**Testing**:
- TDD for all logic-heavy code (parsers, visitors, formatters, services)
- Skip TDD for pure boilerplate (handler registration, thin adapters)
- Unit tests construct AST directly, test services in isolation
- E2E tests run in real VS Code Extension Host

### 6. Development Commands

```bash
npm run build              # Clean & compile
npm run build:e2e          # Build + compile E2E tests
npm test                   # Jest unit tests
npm run test:e2e           # Mocha in Extension Host
npm run test:all           # Unit + E2E
npm run lint / lint:fix    # ESLint
npm run typecheck          # Type check only
npm run package            # Build + vsce package (.vsix)
```

Run single test: `npx jest --config jest.config.ts src/test/GCodeParser.test.ts`
Run tests by name: `npx jest --config jest.config.ts -t "parses a simple variable"`

### 7. File Organization

```
src/
  lexer/            → GCodeScanner, token definitions
  parser/           → BaseParser + dialect subclasses, AstFactory, AstTraverser
  parser/nodes/     → Pure domain classes (ProgramNode, etc.)
  formatter/        → BaseFormatter + dialect implementations, FormatterFactory
  databases/        → Command reference data per dialect
  visualizer/       → GCodePathExtractor, 3D types
  providers/        → LSP service layer, DocumentStateManager
  server/           → LSP server entry point
  client/           → VS Code extension entry point
  test/             → Jest unit tests
  e2e/suite/        → Mocha E2E tests
```

### 8. Core Services

| Service | Purpose |
|---------|---------|
| **GCodeLexer** | Tokenize source |
| **BaseParser** / dialect subclasses | Build AST |
| **FormatterService** | Apply formatting |
| **DocumentStateManager** | Cache ASTs per URI |
| **AstAnalysisService** | Semantic analysis |
| **VariableAnalysisService** | Variable resolution |
| **NodeFinder** | Locate nodes by position |
| **GCodePathExtractor** | 3D tool-path segments |
| **WorkspaceIndexingService** | Workspace symbol cache |

### 9. Development Principles (Key)

1. **Always do full, proper refactors** — Never partial solutions or synthetic workarounds. If a change reveals a deeper abstraction is needed, do it properly.
2. **Reuse existing infrastructure** — Use existing lexer/parser for syntax features instead of introducing duplicate regex logic. Build on established patterns (visitor, factory, strategy).
3. **Dialect-aware design** — All four dialects must be supported. Use strategy pattern with abstract base classes and per-dialect implementations.

### 10. Configuration Options (User-Facing)

Extension settings:
- `gcode.dialect` — Select dialect (linuxcnc, fanuc, haas, siemens)
- `gcode.formatter.*` — Line numbers, pretty-printing, indentation, compactness
- `gcode.visualizer.*` — Colors, line thickness, grid, projection, playback speeds
- `gcode.variables` — Pre-loaded variable values (for visualization)
- `gcode.workspace.indexingEnabled` — Symbol indexing for Ctrl+T search

## Related Solutions

The codebase references these documented solution patterns:

- [[workspace-symbol-architecture]] — Ctrl+T four-layer architecture with client-side file enumeration
- [[client-side-enumeration-pattern]] — File enumeration respecting files.exclude/search.exclude
- [[lsp-file-watcher-linux]] — Reliable file watching on Linux
- [[server-provider-wiring-patterns]] — Server.ts conventions and error handling
- [[visualizer-variable-resolution-pipeline]] — Variable resolution in 3D visualization
- [[fs-readdir-dirent-typing]] — TypeScript Dirent generic disambiguation
- [[interface-extraction-import-type]] — Avoiding import cycles in interface files
- [[variable-formatting-utilities]] — Centralized variable key formatting

## Technology Stack

- **Language**: TypeScript 5.9.3 (strict)
- **Runtime**: Node.js
- **Package Manager**: npm
- **Build**: tsc + esbuild (webview)
- **Test**: Jest (unit) + Mocha (E2E)
- **Linting**: ESLint (flat config)
- **VS Code**: 1.85.0+
- **LSP**: Version 9.0.1

## Marketplace & Distribution

- **Published**: "G-Code Language Support" under publisher "QuickBoyz"
- **Marketplace ID**: vscode-gcode-extension
- **License**: MIT
- **Repository**: https://github.com/QuickBoyz/vscode-gcode-extension
- **Version**: 2.4.0

## Key Files Referenced

1. `.claude/CLAUDE.md` — Architecture overview, layer rules, patterns, solution docs reference
2. `AGENTS.md` — Mandatory engineering rules (77 rules across 8 sections)
3. `package.json` — Dependencies, scripts, VSCode contributions (language, grammar, commands, menus, settings, semantic tokens)
4. `README.md` / `CONTRIBUTING.md` — Not read; assume standard patterns
