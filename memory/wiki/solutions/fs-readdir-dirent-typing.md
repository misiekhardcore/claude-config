---
type: solution
title: "fs.readdir Dirent Typing Pattern"
project: "[[vscode-gcode-extension]]"
domain: typescript
severity: medium
tags:
  - solution
  - typescript
  - types
  - fs-api
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-17
related:
  - "[[interface-extraction-import-type]]"
---

# fs.readdir Dirent Typing

## Problem

When using `fs.promises.readdir` with `withFileTypes: true`, modern `@types/node` makes `Dirent` generic. Omitting the `encoding` parameter picks an implementation-defined overload, resulting in `Dirent<NonSharedBuffer>[]` instead of the cleaner `Dirent<string>[]`. This creates confusing type mismatches.

Anti-pattern: casting with `as unknown as Dirent[]` hides type information.

## Solution

Pass `encoding: 'utf8'` alongside `withFileTypes: true`:

```typescript
const entries = await fs.promises.readdir(dirPath, {
  encoding: 'utf8',
  withFileTypes: true
});
// entries is now Dirent<string>[]
```

## Why It Works

The `encoding: 'utf8'` parameter disambiguates the overload resolution. TypeScript picks the correct generic instantiation, giving you `Dirent<string>[]` instead of the buffer variant. This is especially important when downstream code expects string paths or filenames.

## Context

Used in file enumeration code that reads directory contents for workspace symbol indexing. Clean typing avoids casting and makes intent explicit to type checkers and future maintainers.
