---
type: concept
title: "Structured Parse Error Location"
complexity: intermediate
domain: gcode-lsp
aliases:
  - "parse error factory"
  - "ParseError.createParseError"
  - "error range propagation"
created: 2026-04-17
updated: 2026-04-20
tags:
  - pattern
  - architecture
  - error-handling
  - coordinate-system
status: mature
confidence: INFERRED
evidence: []
related:
  - "[[G-code LSP Architecture]]"
  - "[[concepts/_index]]"
sources:
  - "GitHub issue #146 — visualizer: parser errors should report file:line consistently"
  - "/home/michal/Projects/vscode-gcode-extension/src/errors/"
  - "/home/michal/Projects/vscode-gcode-extension/src/parser/nodes/Range.ts"
---

# Structured Parse Error Location

Pattern for propagating a structured parse-error `Range` from parser raise sites through the LSP diagnostic path and the visualizer webview error card. Uses the project's canonical 0-based `Range` class (which implements LSP `Range`) end-to-end — no parallel coordinate type, no adapter layer.

## Context

Applies to the vscode-gcode-extension (`src/errors/`, `src/parser/`, `src/visualizer/`, `src/webview/`). Two consumer paths share the same `Range` value:

1. **LSP path**: `ParseError.range → ErrorNode.range → Diagnostic.range`
2. **Visualizer path**: `ParseError.range → VisualizerFailure.range → WorkerErrorResponse.range → WebviewMessage.range → DocumentStatus.ERROR.range → EmptyMessage (clickable link)`

Both paths consume the same `Range | null` — the webview side converts to 1-based only at display time (`range.start.line + 1`), and posts the 0-based `line` directly back to the VS Code cursor API.

## Guidance

### Single factory — the only entry point for ParseError construction

```typescript
// src/errors/ParseError.ts
ParseError.createParseError({
  message: "Unexpected token",
  token,          // derives a 0-based Range via token.line-1 / token.col-1 / +value.length
  code,           // optional ParserDiagnosticCode
  range,          // optional explicit Range (wins over token)
});
```

Every raise site in `BaseParser`, `TokenStream`, and all dialect parsers calls `ParseError.createParseError`. No raise site calls `new ParseError(...)` directly (except inside the factory itself). No `"at line N"` suffix in any message string.

### Coordinate conventions

- **`LexerToken.line` / `LexerToken.col`**: 1-based (matches user-facing display and historical scanner output).
- **`Range`** (`src/parser/nodes/Range.ts`, implements LSP `Range`): 0-based `line`, 0-based `character`.
- Conversion happens in one place — `ParseError.rangeFromToken(token)` inside `ParseError.ts`.
- Webview display converts back to 1-based at the edge: `line ${range.start.line + 1}:${range.start.character + 1}`.
- Webview navigation uses the 0-based `line` directly — the VS Code `Position` / cursor API is already 0-based.

### Token → Range span (critical invariant)

```typescript
// src/errors/ParseError.ts (private static)
private static rangeFromToken(token: LexerToken): Range {
  return Range.create(
    token.line - 1,
    token.col - 1,
    token.line - 1,
    token.col - 1 + token.value.length,  // <-- end character MUST include value.length
  );
}
```

Without `token.value.length`, the Range collapses to zero width and the LSP squiggle becomes invisible.

### LSP wiring — errorFromParseError

`AstFactory.errorFromParseError(err, originalText?, parent?)` bridges the parser catch path to `ErrorNode`:

```typescript
// src/parser/AstFactory.ts
errorFromParseError(err: ParseError, originalText?: string, parent?: AstNode): ErrorNode {
  const range = err.range ?? {
    start: { line: 0, character: 0 },
    end: { line: 0, character: 0 },
  };
  return new ErrorNode(range, err.message, originalText, parent, DiagnosticCategory.Error, err.code);
}
```

`BaseParser.parseStatementSafe` and `parseVariableAssignment` catch paths call this. `ErrorNode.getRange()` feeds `DiagnosticsProvider` → LSP `Diagnostic.range`.

### Visualizer error card

`VisualizerFailure.range: Range | null` (always present, never `undefined`). Forced `null` for `WORKER_CRASH` / `UNKNOWN` error kinds — only `PARSE_FAILURE` populates it. `documentReducer` enforces this invariant:

```typescript
range: action.errorKind === VisualizerErrorKind.PARSE_FAILURE ? action.range : null;
```

`EmptyMessage` renders `line ${range.start.line + 1}:${range.start.character + 1}` and posts `{ type: 'navigateToLine', line: range.start.line }` (0-based, consumed directly by the VS Code cursor API).

## Why

- **Single factory** guarantees uniform formatting across 23+ raise sites in 6 files. Previously each site built its own message/location independently.
- **Single coordinate type (`Range`) end-to-end** eliminates a parallel 1-based struct plus its adapter layer. The only 1-based → 0-based conversion is `rangeFromToken` inside the factory. Display-layer `+1` is a trivial local concern in `EmptyMessage`.
- **Mandatory `token.col - 1 + token.value.length` end**: LSP needs a non-zero-width range for the squiggle.

## When to Use

- Adding a new raise site in any parser or lexer file → always call `ParseError.createParseError`.
- Adding a new consumer of `ParseError.range` (new UI, new provider) → consume the `Range` directly. Do not introduce a parallel 1-based struct.
- Testing parse-error diagnostics → assert `range.end.character > range.start.character` to catch zero-width regressions.

## Examples

```typescript
// Raise site (BaseParser.ts)
throw ParseError.createParseError({
  message: "Expected THEN keyword",
  token: this.tokens.peek(),
  code: ParserDiagnosticCode.EXPECTED_TOKEN,
});

// Catch path (BaseParser.parseStatementSafe)
if (err instanceof ParseError) {
  return this.factory.errorFromParseError(err, originalText);
}

// Webview display (EmptyMessage.tsx)
const locationLabel =
  range !== null
    ? `line ${range.start.line + 1}:${range.start.character + 1}`
    : null;

vscode.postMessage({ type: 'navigateToLine', line: range.start.line });
```

## Historical Note

An earlier design (cycles 1–3 of #146) used a 1-based `ErrorLocation` struct plus `src/errors/adapters.ts#locationToRange()` to convert to LSP `Range` at the consumer edge. Cycle 4 eliminated both: `locationToPayload` was dead code, and `locationToRange` was a single-call-site helper that reimplemented what `Range.create(line-1, col-1, ...)` already does inside `rangeFromToken`. Keeping a parallel coordinate type only added conversion churn without buying anything — `Range` was already the canonical LSP-compatible type throughout AST/services/providers.

## See Also

- `[[G-code LSP Architecture]]` — full layered pipeline; `src/errors/` is a shared module below the parser layer
- `src/errors/ParseError.ts` — the factory and its `rangeFromToken` helper
- `src/parser/nodes/Range.ts` — the canonical 0-based Range class (implements LSP `Range`)
- `src/parser/AstFactory.ts#errorFromParseError` — LSP bridge
- `src/test/createParseError.test.ts` — factory unit coverage including token → Range derivation
