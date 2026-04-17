---
type: entity
title: "vscode-gcode-extension"
kind: repo
created: 2026-04-17
updated: 2026-04-17
tags:
  - entity
  - vscode
  - lsp
  - typescript
  - g-code
  - cnc
status: current
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

- Visitor pattern for AST traversal (formatting, semantic analysis)
- Factory pattern for dialect selection
- Strategy pattern for dialect implementations
- Composition root pattern for service initialization

## Repository

Source: `.claude/docs/solutions/` directory contains 7 solution docs covering TypeScript typing, LSP conventions, and architecture patterns.
