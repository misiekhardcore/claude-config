---
type: solution
title: "Visualizer Variable Resolution Pipeline"
project: "[[vscode-gcode-extension]]"
domain: visualizer
severity: medium
tags:
  - solution
  - visualizer
  - architecture
  - variable-resolution
  - composition-root
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[variable-formatting-utilities]]"
  - "[[workspace-symbol-architecture]]"
---

# Visualizer Variable Resolution Pipeline

## Architecture

`VisualizerService` is the composition root for the tool-path extraction pipeline:

```
VisualizerService
  ↓
GCodePathExtractor
  ↓
GCodeInterpreter
  ↓
GCodeExpressionEvaluator
```

## Key Pattern: Variable Resolution Happens Inside VisualizerService

Variable resolution (raw `VariableDefinitions` → `VariableEnvironment`) occurs inside `VisualizerService.extractToolPath()`, not in callers.

```typescript
// VisualizerService.extractToolPath()
extractToolPath(ast: ProgramNode, vars: VariableDefinitions): PathSegment[] {
  // Resolve variables here, once
  const varEnvironment = VariableResolutionService.resolve(vars);
  
  // Pass resolved environment to extractor
  const extractor = new GCodePathExtractor(varEnvironment);
  return extractor.extract(ast);
}
```

## Why This Matters

1. **Single source of resolution**: Variables are resolved exactly once, not per-caller
2. **No duplicate resolution**: Eliminates redundant resolution calls
3. **Reduced coupling**: Callers never import `VariableResolutionService` directly
4. **Testable**: VisualizerService can be tested with mocked variable environments

## Callers Never Import VariableResolutionService

Examples of where resolution happens:
- Worker thread extraction (async)
- Sync fallback extraction
- Unit tests

All of these call `VisualizerService.extractToolPath()` and receive resolved paths. None of them handle variable resolution directly.

## Future: Full DI

Issue #131 tracks a full dependency injection pattern with a `ProgramInterpreter` interface that encapsulates the entire pipeline. Until then, `VisualizerService` remains the composition root.
