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
status: current
created: 2026-04-17
updated: 2026-04-17
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
