---
type: solution
title: "LSP File Watcher on Linux (parcel-watcher Cold-Start)"
project: "[[vscode-gcode-extension]]"
domain: lsp
severity: high
tags:
  - solution
  - lsp
  - file-watcher
  - linux
  - performance
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[workspace-symbol-architecture]]"
  - "[[server-provider-wiring-patterns]]"
---

# LSP File Watcher on Linux

## Problem

On Linux, registering a dynamic `workspace/didChangeWatchedFiles` handler with a bare-string `globPattern` routes through VSCode's global parcel-watcher backend. This backend has a multi-second cold-start during which short-lived files' events are silently dropped.

Impact: File events are missed for files created and deleted quickly (common in build systems, test runners, temp files).

## Solution

Register per-folder using a `RelativePattern`-shaped object instead of a bare string:

```typescript
// Bad: bare string routes through parcel-watcher with cold-start
connection.workspace.onDidChangeWatchedFiles(({ changes }) => {
  // may miss events
});

// Good: per-folder RelativePattern avoids cold-start
const workspaceFolders = await connection.workspace.getWorkspaceFolders();
for (const folder of workspaceFolders || []) {
  connection.workspace.onDidChangeWatchedFiles(
    ({ changes }) => {
      // handle changes
    },
    {
      globPattern: {
        baseUri: folder.uri,
        pattern: '**/*.{nc,ngc,gcode}'
      }
    }
  );
}
```

## Key Detail

`RelativePattern` is a plain object from `vscode-languageserver-protocol`, not the VSCode API type. It is safe to use server-side. This object shape routes through VSCode's per-workspace watcher with no cold-start penalty.

## Benefits

- Eliminates multi-second startup delay on Linux
- All file events are captured reliably
- Cross-platform consistency (Windows, macOS, Linux)
