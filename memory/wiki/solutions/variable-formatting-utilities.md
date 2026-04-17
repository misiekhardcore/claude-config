---
type: solution
title: "Variable Formatting Utilities Single Source"
project: "[[vscode-gcode-extension]]"
domain: architecture
severity: high
tags:
  - solution
  - architecture
  - utilities
  - duplication
status: current
created: 2026-04-17
updated: 2026-04-17
related:
  - "[[workspace-symbol-architecture]]"
  - "[[visualizer-variable-resolution-pipeline]]"
---

# Variable Formatting Utilities

## Problem

Variable key formatting logic was duplicated across multiple services:
- `VariableAnalysisService`
- `BaseFormatter`
- `GCodePathExtractor`

Each reimplemented the same utilities:
- `formatVariableName()`
- `normalizeVariableKey()`
- `canonicalizeVariableKey()`
- `validateVariableName()`

This duplication caused inconsistencies and made maintenance difficult. Any bug fix or enhancement required updates in multiple places.

## Solution

Consolidate all variable key utilities into a single module: `src/providers/RenameUtils.ts`.

**Rule**: Always import from `RenameUtils`. Never reimplement these utilities.

Example:
```typescript
import { formatVariableName, canonicalizeVariableKey } from './RenameUtils';

const formatted = formatVariableName(rawName);
const canonical = canonicalizeVariableKey(key);
```

## Benefits

- Single source of truth for variable naming logic
- Consistency across all services (analysis, formatting, visualization)
- Simplified maintenance and testing
- Clear intent in code that uses these utilities

## Scope

Applies to all four dialect implementations (LinuxCNC, Fanuc, Haas, Siemens) since variable naming conventions are dialect-independent.
