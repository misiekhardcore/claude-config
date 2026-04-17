---
type: solution
title: "Server Provider Wiring Patterns (server.ts Conventions)"
project: "[[vscode-gcode-extension]]"
domain: lsp
severity: medium
tags:
  - solution
  - lsp
  - server
  - conventions
  - error-handling
  - progress-reporting
status: current
created: 2026-04-17
updated: 2026-04-18
related:
  - "[[workspace-symbol-architecture]]"
  - "[[lsp-file-watcher-linux]]"
---

# Server Provider Wiring Patterns

Conventions for reliable setup and configuration in `server.ts`.

## Pattern 1: Async Config with .catch()

Async configuration functions must use `.catch()` not `void`:

```typescript
// Bad: silently swallows rejection
void connection.onInitialized(() => {
  initializeServices().catch(err => {
    // no logging
  });
});

// Good: .catch() silences rejection explicitly
connection.onInitialized(() => {
  initializeServices().catch(err => {
    connection.console.error(`Init failed: ${err}`);
  });
});
```

This prevents unhandled rejection warnings and makes error handling explicit.

## Pattern 2: Apply Settings at Both onInitialized AND onDidChangeConfiguration

Settings must be applied in two places:

```typescript
connection.onInitialized(async () => {
  const settings = await connection.workspace.getConfiguration('gcode');
  applySettings(settings);
  // Initialize services with settings
});

connection.onDidChangeConfiguration((change) => {
  const settings = change.settings.gcode;
  applySettings(settings);
  // Update running services
});
```

Missing either causes stale defaults. Initialization may happen before configuration is available, and configuration changes must be reflected at runtime.

## Pattern 3: Optional Logger Callback

Services that can fail silently should accept an optional logger callback:

```typescript
interface ServiceOptions {
  logger?: (msg: string) => void;
}

class MyService {
  constructor(private opts: ServiceOptions) {}
  
  private log(msg: string) {
    this.opts.logger?.(msg);
  }
}

// In server.ts, inject connection.console.warn
const service = new MyService({
  logger: (msg: string) => connection.console.warn(msg)
});
```

This decouples services from VSCode's language server connection while enabling opt-in logging for debugging.

## Benefits

- Startup errors are reported reliably
- Configuration changes take effect immediately
- Services remain testable (no hard LSP dependency)
- Debugging is easier with injected logging

---

## Progress Reporting (added #139)

### Two roles: orchestrator vs. producer

**Start here** before writing any progress code. Picking the wrong role is the main failure mode.

| Role | Abstraction | Lifecycle | Example |
|---|---|---|---|
| **Orchestrator** -- owns the progress UI lifecycle | `ProgressReporter` (`src/utils/ProgressReporter.ts`) | stateful: `begin` -> `report` -> `done` | `WorkspaceIndexingService` |
| **Producer** -- emits events from a hot loop, does not own UI | `ExtractorProgressCallback` (`src/visualizer/GCodePathExtractor.ts`) | stateless: per-event `(update) => void` | `GCodePathExtractor.pushSegment()` |

A producer never implements `ProgressReporter` -- it would need a fake `begin`/`done` nobody calls. The orchestrator holds `ProgressReporter` and translates producer events into `report(...)` calls.

### Decision tree

1. Controlling the UI spinner lifecycle? -> Orchestrator, implement `ProgressReporter`.
2. Inside a hot loop emitting events per unit of work? -> Producer, accept `ExtractorProgressCallback`.
3. Orchestrator tier: background op that yields the event loop? -> **Tier A** (`LspBoundProgressReporter`, LSP `$/progress`). Worker-thread message? -> **Tier B** (webview overlay). Synchronous LSP handler (formatter, hover, rename)? -> **Out of scope** (no yield point -- spinner won't animate).

### `ProgressReporter` interface

```ts
// src/utils/ProgressReporter.ts
interface ProgressReporter {
  begin(title: string, percentage?: number, message?: string): void;
  report(percentage: number, message?: string): void;
  done(): void;
}

// Extends with token only for callers that forward it to the client
interface LspBoundProgressReporter extends ProgressReporter {
  readonly token: string | number;
}
```

The generic interface stays clean. Only `WorkspaceIndexingService.enumerateViaClient` narrows to `LspBoundProgressReporter`.

### Title convention

`"<Gerund> <artifact>"` -- no trailing ellipsis, no punctuation. The client and webview both render their own spinner.

- `"Indexing G-code files"` -- server-side indexer (Tier A)
- `"Finding G-code files"` -- client-side file enumeration (Tier A)

### Intra-phase throttling (producer pattern)

```ts
// 100ms: threshold where DOM updates feel smooth on 60 Hz without overloading the event loop
const PROGRESS_INTERVAL_MS = 100;

// inside pushSegment():
const now = Date.now();
if (now - this.lastProgressAt >= PROGRESS_INTERVAL_MS) {
  this.onProgress?.({ phase: VisualizerPhase.EXTRACTING, message: `Extracted ${n} segments` });
  this.lastProgressAt = now;
}
```

No percentage: total segment count is unknown a priori (WHILE-loop expansion). Throttle by wall-clock, not statement count (statement complexity varies wildly).

### Test determinism with throttled `Date.now()`

```ts
jest.spyOn(Date, 'now').mockReturnValue(1000);
// All calls see the same timestamp: first call fires, subsequent ones are throttled
expect(callCount).toBe(1);
jest.restoreAllMocks();
```

Freeze the clock rather than using real timers -- makes throttle assertions stable across CI machines with varying load.
