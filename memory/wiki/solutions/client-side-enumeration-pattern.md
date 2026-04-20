---
type: solution
title: "Client-Side File Enumeration via Custom LSP Request"
project: "[[vscode-gcode-extension]]"
domain: lsp
severity: medium
tags:
  - solution
  - lsp
  - workspace-symbols
  - custom-request
  - cancellation
  - workDoneProgress
status: current
created: 2026-04-17
updated: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[workspace-symbol-architecture]]"
  - "[[lsp-file-watcher-linux]]"
---

# Client-Side File Enumeration via Custom LSP Request

## Problem

Workspace-symbol indexing must honor `files.exclude` and `search.exclude` — settings that live in VS Code's config, not on disk. A server-side `fs.readdir` walker cannot read them.

**Symptoms:**
- Workspace scan finds files the user has hidden via `files.exclude` / `search.exclude`
- Stale scan results overwrite newer ones when config flips mid-scan
- `CancellationTokenSource` disposed twice on scan preemption
- Progress bar shows wrong phase label during file enumeration

**Root cause:** Server-side FS walks cannot see VS Code workspace settings; the client must enumerate and hand back URIs via a custom LSP request.

## Solution

Flip the direction: the **server asks the client** to enumerate files via a custom LSP request, and the client uses `vscode.workspace.findFiles` (which honors the settings) to produce the list.

### Custom Request Type

Declare a VSCode-free `RequestType` in `src/lsp/` (shared layer, imported by both client and server):

```ts
export const GCodeListIndexFilesRequest = new RequestType<
  GCodeListIndexFilesParams,
  GCodeListIndexFilesResult,
  void
>('workspace/gcodeListIndexFiles');

export interface GCodeListIndexFilesParams {
  readonly folders: readonly string[];
  readonly scanGeneration: number;
  readonly includeGlob: string;
  readonly workDoneToken?: ProgressToken;
}

export interface GCodeListIndexFilesResult {
  readonly files: readonly string[];
  readonly scanGeneration: number;
  readonly truncated: boolean;
}
```

### Capability Handshake

Server advertises via `initializationOptions.experimental`; client declares support the same way:

```ts
const flags: ClientFeatureFlags = {
  supportsListIndexFiles:
    params.initializationOptions?.experimental?.gcode?.listIndexFiles?.version === 1,
};
```

### Handler Registration (Client)

Register the handler **before** `await client.start()` — the language client queues pre-start registrations and activates them after handshake.

### CTS Double-Dispose Guard

When Scan B preempts Scan A, `cancelCurrentScan()` disposes A's CTS. A's `finally` block must NOT dispose unconditionally:

```ts
// WRONG — double-disposes when preempted
finally {
  if (this.currentScanCts === cts) {
    this.currentScanCts = undefined;
  }
  cts.dispose(); // always runs — second dispose crashes
}

// RIGHT — dispose only when this scan still owns the field
finally {
  if (this.currentScanCancellationTokenSource === cancellationTokenSource) {
    this.currentScanCancellationTokenSource = undefined;
    cancellationTokenSource.dispose();
  }
}
```

### Two-Phase WorkDoneProgress Handoff

One progress token covers both phases ("Finding G-code files…" client-side, then "Indexing N/M files…" server-side):

1. Server generates UUID, sends `WorkDoneProgressCreateRequest`, then calls `attachWorkDoneProgress(token)`
2. Server puts token on `params.workDoneToken`
3. Client handler emits `begin`/`end` under that token during enumeration
4. Server defers its `progress.begin("Indexing…")` until **after** `collectScanTargets` returns

### Exclude Merge Semantics

Client unions `files.exclude` ∪ `search.exclude`, filters `value !== true` patterns, brace-expands to `{a,b,c}`. Pass `exclude ?? null` to `findFiles` (`null` = disable defaults, `undefined` = apply defaults).

### What NOT to Filter

Do **not** apply `files.exclude`/`search.exclude` to `onDidChangeWatchedFiles` events. The watcher uses `RelativePattern` driven by `files.watcherExclude` — a separate setting. Accept eventual consistency.

## Prevention

- Always test both paths: client-enumeration branch (mock `requestFiles`) and fallback walker (tmpdir fixture)
- Write a unit test forcing preempt-then-settle race; assert CTS disposed exactly once
- When adding new exclude rules, extend `buildExcludeGlob` — never touch the watcher filter path

## See Also

- [[workspace-symbol-architecture]] — consumer of the enumeration pipeline
- [[lsp-file-watcher-linux]] — why the file watcher uses `RelativePattern` and why its exclude settings are separate
