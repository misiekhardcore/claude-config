---
type: solution
title: "Interface Extraction Import Type Pattern"
project: "[[vscode-gcode-extension]]"
domain: typescript
severity: high
tags:
  - solution
  - typescript
  - imports
  - circular-dependencies
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-17
related:
  - "[[fs-readdir-dirent-typing]]"
---

# Interface Extraction with import type

## Problem

When extracting an `IFoo` interface to its own file, both the interface file and the implementation file may need to import from each other (mutual dependency). With default TypeScript settings (`isolatedModules: true` + no `verbatimModuleSyntax`), tsc elides type-only imports at emit, so the runtime cycle looks resolved.

However, at the source level the cycle still exists and becomes a breaking problem under:
- `verbatimModuleSyntax: true` (tsc refuses to elide any imports)
- Stricter bundlers that analyze source-level dependencies
- Future tooling upgrades

## Solution

Make every import in the interface file `import type`:

```typescript
// IDocumentStateManager.ts
import type { DocumentStateManager } from './DocumentStateManager';

export interface IDocumentStateManager {
  // interface definition
}
```

```typescript
// DocumentStateManager.ts
import { IDocumentStateManager } from './IDocumentStateManager';

export class DocumentStateManager implements IDocumentStateManager {
  // implementation
}
```

Now `IDocumentStateManager.ts` imports `type` only (no runtime dependency on the class), eliminating the source-level cycle entirely. The implementation file can still import the interface normally.

## Example

Fixed in PR #135 for `IDocumentStateManager.ts` extraction.

## Why It Matters

`import type` removes the source cycle completely, making your code resilient to stricter TypeScript and bundler settings. It also makes intent explicit: readers see immediately that the interface file depends on types, not runtime implementations.
