---
type: concept
title: "G-code LSP Architecture"
domain: lsp-architecture
created: 2026-04-17
updated: 2026-04-20
tags:
  - concept
  - architecture
  - lsp
  - layered-architecture
  - design-patterns
status: current
confidence: INFERRED
evidence: []
related:
  - "[[vscode-gcode-extension]]"
  - "[[workspace-symbol-architecture]]"
  - "[[lsp-file-watcher-linux]]"
  - "[[server-provider-wiring-patterns]]"
  - "[[visualizer-variable-resolution-pipeline]]"
  - "[[client-side-enumeration-pattern]]"
  - "[[Structured Parse Error Location]]"
---

# G-code LSP Architecture

The vscode-gcode-extension implements a strict five-layer architecture for Language Server Protocol (LSP) integration with VS Code. This design ensures testability, maintainability, and extensibility for a G-code language server.

## The Pipeline: Lexer → Parser → AST → Services → Adapters

Each layer has a single responsibility and may only depend on the layer directly below it. No circular dependencies or layer-skipping allowed.

```
┌─────────────────────────────────────────────┐
│    VS Code Integration (Adapters)           │
│  - Language Server (server.ts)              │
│  - Extension Client (extension.ts)          │
│  - Commands & Webviews                      │
│  (Thin, no business logic)                  │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│         Services Layer                       │
│  - Formatter (BaseFormatter + dialects)     │
│  - Analyzers (variable, AST, error)         │
│  - Visualizer (3D path extraction)          │
│  - File watching & indexing                 │
│  - DocumentStateManager (cache)             │
│  (Consume AST, never mutate it)             │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│           AST Layer                          │
│  - ProgramNode, StatementNode               │
│  - MotionCommandNode, VariableAssignmentNode│
│  - IfStatementNode, WhileStatementNode      │
│  - ErrorNode (for parse recovery)           │
│  (Pure domain, all properties readonly)     │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        Parser Layer                          │
│  - BaseParser (abstract, shared logic)      │
│  - LinuxCNCParser, FanucParser, etc.        │
│  - ParserFactory.create(dialect)            │
│  - AstFactory (node creation)               │
│  - AstTraverser (visitor dispatch)          │
│  (Consumes tokens, produces immutable AST)  │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│        Lexer Layer                           │
│  - GCodeScanner (hand-written, stateful)    │
│  - LexerFactory.create(dialect)             │
│  - TokenCategory & KeywordType enums        │
│  - Case-insensitive keyword lookup table    │
│  (No parsing, no VS Code logic)             │
└─────────────────────────────────────────────┘
```

## Layer Details

### 1. Lexer (`src/lexer/`)

**Responsibility**: Tokenize G-code source into a stream of LexerToken objects.

**Key components**:
- `GCodeScanner` — Hand-written character scanner with lookahead and state tracking
- `LexerFactory.create(dialect)` — Dialect-aware scanner factory
- `TokenCategory` enum — Token types (Keyword, Number, Axis, Comment, etc.)
- `KeywordType` enum — Specific keyword classification (MotionCommand, FlowControl, etc.)

**Constraints**:
- No parsing logic (e.g., no tree building)
- No VS Code dependencies
- Case-insensitive keyword matching
- Dialect-aware keyword tables

**Output**: Stream of `LexerToken` objects with position info.

### 2. Parser (`src/parser/`)

**Responsibility**: Consume token stream, build an immutable Abstract Syntax Tree (AST).

**Key components**:
- `BaseParser` — Abstract base with shared parsing logic (recovery, error handling)
- `LinuxCNCParser`, `FanucParser`, `HaasParser`, `SiemensParser` — Dialect subclasses
- `ParserFactory.create(dialect)` — Selects dialect parser
- `AstFactory` — Creates AST nodes (factory pattern for future extensibility)
- `AstTraverser` — Walks AST tree and dispatches to a visitor

**Constraints**:
- No formatting logic in parser
- No semantic analysis (scoping, type checking) — that's services' job
- All AST nodes immutable after creation
- Parse errors must be recoverable (ErrorNode for recovery)

**Output**: `ProgramNode` (root of immutable AST).

### 3. AST (`src/parser/nodes/`)

**Responsibility**: Pure domain representation of G-code syntax.

**Key node types**:
- `ProgramNode` — Root node, contains all statements
- `StatementNode` — Abstract base for all statement types
- `MotionCommandNode` — G0, G1, G2, G3 motion commands
- `VariableAssignmentNode` — Variable assignments (#100=5.0)
- `IfStatementNode` — Conditional blocks
- `WhileStatementNode` — Loop blocks
- `BlockStatementNode` — Grouped statements
- `ErrorNode` — Parse error recovery; contains offset and expected tokens

**Constraints**:
- All properties `readonly`
- No formatting, traversal, or VS Code logic
- No mutation after creation
- May expose small semantic helpers (e.g., `isConditional()`)
- Serializable for testing and debugging

**Patterns**:
- Composite pattern (ProgramNode → StatementNode → child nodes)
- Visitor pattern support (each node accepts a visitor)

### 4. Services (`src/formatter/`, `src/databases/`, `src/visualizer/`, `src/providers/`)

**Responsibility**: Consume and analyze the immutable AST; produce formatted code, diagnostics, completions, etc.

**Key service types**:

#### Formatter (`src/formatter/`)
- `BaseFormatter` — Extends `BaseAstVisitor<void>`, visitor pattern for traversal
- `LinuxCNCFormatter`, `FanucFormatter`, `HaasFormatter`, `SiemensFormatter` — Dialect formatters
- `FormatterFactory.create(dialect)` — Factory for dialect selection
- `ExpressionFormatter` — Expression pretty-printing

#### Databases (`src/databases/`)
- `CommandDatabase` — G/M-code reference data per dialect
- `FunctionDatabase` — Built-in functions (SIN, COS, etc.)
- `OperatorDatabase` — Arithmetic and logical operators
- `AxisParametersDatabase` — Axis ranges and constraints

#### Visualizer (`src/visualizer/`)
- `GCodePathExtractor` — Converts AST to 3D `PathSegment[]`
- `types.ts` — Pure domain types (Position, Segment, etc.); VS-Code-free for testability

#### Providers / Analysis (`src/providers/`)
- `BaseProvider` — Abstract base; gives all providers access to `DocumentStateManager`
- `DocumentStateManager` — Caches ASTs and analysis results per document URI
- `AstAnalysisService` — Semantic analysis (scopes, definitions, references)
- `VariableAnalysisService` — Variable resolution, typing, range tracking
- `NodeFinder` — Locate nodes by position (for hover, rename, etc.)
- `FormatterService` — Apply formatting options from settings
- `ErrorDetectorVisitor` — Diagnostics and validation
- `IDataProvider` + `DataProviderFactory` — Abstract per-dialect command/function/operator data

**Constraints**:
- Never mutate the AST
- No formatting or hover logic in node classes
- No `instanceof` chains — use visitor/polymorphism
- All analysis is lazy and cached

**Patterns**:
- Visitor pattern (for AST traversal, analysis, formatting)
- Factory pattern (for dialect-specific services)
- Strategy pattern (for dialect implementations)
- Lazy evaluation and caching via `DocumentStateManager`

### 5. Adapters (`src/server/`, `src/client/`)

**Responsibility**: Integrate LSP and VS Code; delegate all logic to services.

#### Server (`src/server/`)
- Language Server Protocol (LSP) request handlers
- Wires LSP handlers to provider instances
- No business logic — all delegation to services

#### Client (`src/client/`)
- Extension entry point (`dist/client/index.js`)
- `extension.ts` — Starts language client
- `GCodeVisualizerPanel` — Manages 3D webview
- `CommandProvider` — Registers VS Code commands

**Constraints**:
- No business logic
- No AST manipulation
- No parsing or analysis
- Thin delegation only

## Design Patterns

### Visitor Pattern

All AST traversal uses the visitor pattern:

```typescript
abstract class AstVisitor<T> {
  abstract visitProgramNode(node: ProgramNode): T;
  abstract visitMotionCommandNode(node: MotionCommandNode): T;
  // ...
}

class BaseAstVisitor<T> extends AstVisitor<T> {
  // Default implementations (often return undefined)
}

class FormatterVisitor extends BaseAstVisitor<void> {
  // Formatting logic
}

class AstTraverser {
  traverseAndVisit(node: AstNode, visitor: AstVisitor<T>): T {
    // Dispatch to visitor method based on node type
  }
}
```

**Benefits**:
- No `instanceof` chains in services
- Clean separation between traversal and logic
- Easy to add new analysis passes

### Factory Pattern

Dialect selection via factories:

```typescript
class ParserFactory {
  static create(dialect: DialectType): BaseParser {
    switch (dialect) {
      case 'linuxcnc': return new LinuxCNCParser();
      case 'fanuc': return new FanucParser();
      // ...
    }
  }
}
```

**Benefits**:
- Centralized dialect strategy selection
- Easy to add new dialects
- No dialect-specific logic scattered across services

### Strategy Pattern

Dialect-specific behavior encapsulated:

```typescript
interface IFormatter {
  format(ast: AstNode, options: FormatterOptions): string;
}

class LinuxCNCFormatter implements IFormatter { ... }
class FanucFormatter implements IFormatter { ... }
```

**Benefits**:
- Dialect logic isolated
- Easy to test each dialect independently
- New dialects can be added without modifying existing code

### Composite Pattern

AST tree structure:

```typescript
abstract class AstNode {
  abstract readonly children: AstNode[];
}

class ProgramNode extends AstNode {
  readonly children: StatementNode[];
}

class BlockStatementNode extends StatementNode {
  readonly children: StatementNode[];
}
```

**Benefits**:
- Uniform tree operations
- Visitor pattern naturally applies
- Recursive traversal

## Dialect System

Four supported dialects: **LinuxCNC** (default), **Fanuc**, **Haas**, **Siemens**.

Dialects affect:
- Keyword syntax (THEN/DO/END variations)
- Formatting conventions
- Completions and hover docs
- Validation rules
- Command reference data

### Adding a New Dialect

1. Create formatter in `src/formatter/dialects/NewDialectFormatter.ts`
2. Create command database in `src/databases/dialects/NewDialectCommandDatabase.ts`
3. Create data provider in `src/providers/dialects/NewDialectDataProvider.ts`
4. Add parser in `src/parser/NewDialectParser.ts` (if syntax differs)
5. Update `DialectType` enum in `src/constants.ts`
6. Update factories: `ParserFactory`, `FormatterFactory`, `DataProviderFactory`
7. Add tests covering all new dialect cases

## Error Handling & Recovery

Parsing errors are **recoverable**:

- `ErrorNode` represents a parse error with offset and expected tokens
- Parser continues tokenizing after error
- `ErrorNode` is a valid AST node (composite pattern)
- Services can analyze partial ASTs and report diagnostics

Benefits:
- AST available even with syntax errors
- Hover, completion, and formatting work on partial programs
- Diagnostics include position info

## Testing Strategy

### Unit Tests (Jest)

Test services in isolation:

```typescript
const ast = new GCodeParser().parse('G0 X10 Y20');
const formatted = new LinuxCNCFormatter().format(ast, options);
expect(formatted).toContain('G00'); // Pretty-print
```

- Construct AST directly via parser
- Test service against AST
- No VS Code dependencies

### E2E Tests (Mocha in Extension Host)

Test full LSP integration:

```typescript
const doc = await vscode.workspace.openTextDocument(uri);
const symbols = await commands.executeCommand('vscode.executeWorkspaceSymbolProvider', 'query');
expect(symbols).toHaveLength(3);
```

- Real VS Code Extension Host
- Test actual LSP protocol
- Verify UI behavior

### TDD Rule

Use TDD for logic-heavy code:
1. Write failing test (derived from spec)
2. Implement minimal code to pass
3. Refactor while tests stay green
4. Repeat

Skip TDD for boilerplate (handler registration, thin adapters).

## Key Rules

1. **Strict layering** — No layer-skipping or circular dependencies
2. **Immutable AST** — Never mutate AST after parsing
3. **No `any` types** — Strict TypeScript throughout
4. **No business logic in adapters** — Delegate to services
5. **No `instanceof` chains** — Use visitor/polymorphism
6. **Domain-specific errors** — Not raw `Error`
7. **Parse recovery** — Errors must include position info
8. **Dialect-aware design** — All four dialects supported, use strategy

## References

- [[vscode-gcode-extension]] — Full entity page with commands and file organization
- [[workspace-symbol-architecture]] — Four-layer workspace symbol architecture
- [[client-side-enumeration-pattern]] — Client-side file enumeration respecting exclusions
- [[lsp-file-watcher-linux]] — Reliable file watching on Linux
- [[server-provider-wiring-patterns]] — Server.ts conventions and DI patterns
- [[visualizer-variable-resolution-pipeline]] — Variable resolution in visualization
- [[Structured Parse Error Location]] — Single factory + adapter pattern for parse error locations (1-based → 0-based LSP conversion, visualizer error card)
