---
type: concept
title: "Multi-Root Workspace Per-Folder Config"
project: "[[vscode-gcode-extension]]"
domain: vscode
tags:
  - concept
  - pattern
  - vscode
  - multi-root
  - workspace
  - lsp
status: current
created: 2026-04-18
updated: 2026-04-18
related:
  - "[[client-side-enumeration-pattern]]"
  - "[[workspace-symbol-architecture]]"
  - "[[gcode-lsp-architecture]]"
  - "[[vscode-gcode-extension]]"
---

# Multi-Root Workspace Per-Folder Config

## Context

VSCode extensions that read workspace configuration (dialect, excludes, etc.) and index workspace files. In a multi-root workspace, each folder has its own `.vscode/settings.json` and the naive approach of reading `vscode.workspace.getConfiguration()` globally returns the wrong value for all but the first folder.

Applies to: LSP extensions with workspace-wide indexing, any extension that needs per-folder settings or per-folder file enumeration.

## Guidance

### 1. Per-folder configuration reads

Use `vscode.workspace.getConfiguration(undefined, scope)` where `scope` is the folder URI:

```ts
const scope = vscode.Uri.parse(folderUri);
const config = vscode.workspace.getConfiguration(undefined, scope);
const dialect = config.get<string>('gcode.dialect', 'linuxcnc');
```

Never use the global `getConfiguration()` for settings that can differ per folder.

### 2. Per-folder file enumeration with excludes

Use `vscode.RelativePattern` to scope `findFiles` to each root, and read excludes from the folder-scoped config:

```ts
const excludes = buildGlobFromExcludes(
  vscode.workspace.getConfiguration(undefined, folderUri).get<Record<string, boolean>>('files.exclude', {}),
  vscode.workspace.getConfiguration(undefined, folderUri).get<Record<string, boolean>>('search.exclude', {})
);
const files = await vscode.workspace.findFiles(
  new vscode.RelativePattern(vscode.Uri.parse(folderUri), '**/*.nc'),
  excludes
);
```

### 3. Longest-prefix matching for overlapping/nested roots

When resolving which root owns a file (to look up its dialect), use longest-prefix matching, not first-match. This matters when roots are nested (e.g. `/project` and `/project/sub`): a file under `/project/sub/foo.nc` belongs to the more-specific root.

```ts
function findLongestMatchingRoot(filePath: string, roots: string[]): string | undefined {
  let best: string | undefined;
  for (const root of roots) {
    if (pathIsUnder(filePath, root) &&
        (best === undefined || root.length > best.length)) {
      best = root;
    }
  }
  return best;
}
```

Applies to both initial indexing (resolving dialect per file) and file-watcher events (resolving dialect for a changed file).

### 4. Indexing pipeline shape

```
scanRoots()
  for each WorkspaceFolder:
    dialect = getDialect(folder.uri)      // folder-scoped config
    request.folders.push(folder.uri)
  files = enumerateFiles(request)         // per-folder findFiles

indexFromList(files)
  for each file:
    root = findLongestMatchingRoot(file, roots)
    dialect = folderDialects.get(root)
    parseAndIndex(file, dialect)

processChange(uri)
  root = findLongestMatchingRoot(uri, roots)
  dialect = getDialect(root)             // re-read on change events
  reindex(uri, dialect)
```

## Why

- `getConfiguration()` without a scope returns workspace-level config, which collapses all folder overrides. The first folder's settings win globally.
- `findFiles` without `RelativePattern` scans the entire workspace and cannot apply per-folder excludes.
- First-match root resolution silently uses the wrong dialect for files under nested roots.

## When to Use

Any time a VSCode extension:

- Reads settings that can differ per workspace folder
- Enumerates files and needs to respect per-folder excludes
- Maintains a map of "which folder does this file belong to"

## Examples (vscode-gcode-extension)

- `src/providers/WorkspaceIndexingService.ts`: `scanRoots()`, `resolveDialectForUri()`, `resolveFolderUriForChangedFile()`, `findLongestMatchingRoot()`
- `src/client/WorkspaceFileEnumerator.ts`: `handle()` iterating `params.folders`
- `src/client/extension.ts`: `findFiles` with `RelativePattern`, `getExcludes` with folder-scoped `getConfiguration`
- E2E fixture: `src/e2e/fixtures-multiroot/`: two-folder workspace with differing dialects (folder-a fanuc, folder-b linuxcnc)

## See Also

- [[client-side-enumeration-pattern]]: the client-side `findFiles` enumeration pipeline that this pattern extends to multi-root
- [[workspace-symbol-architecture]]: "Known Limits" section (single-dialect-per-scan) is superseded by this pattern
- Origin: `vscode-gcode-extension` PR #149, issue #141
