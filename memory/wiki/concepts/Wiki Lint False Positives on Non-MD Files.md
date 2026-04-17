---
type: concept
title: "Wiki Lint False Positives on Non-MD Files"
complexity: basic
domain: wiki-maintenance
aliases:
  - "lint dead link false positive"
  - "canvas wikilink not found"
created: 2026-04-17
updated: 2026-04-17
tags:
  - bug-fix
  - wiki-maintenance
  - wiki-lint
status: mature
related:
  - "[[LLM Wiki Pattern]]"
  - "[[cherry-picks]]"
  - "[[concepts/_index]]"
sources:
  - "claude-config session 2026-04-17"
---

# Wiki Lint False Positives on Non-MD Files

## Problem

The `wiki-lint` agent incorrectly flags wikilinks to `.canvas` and `.base` files as dead links, then removes or unlinks them from pages.

## Symptoms

After a lint run, valid navigation links disappear from `index.md`, `hot.md`, `overview.md`, `getting-started.md`, and `_index` files. Specifically, `[[Wiki Map]]` (resolves to `Wiki Map.canvas`) and `[[dashboard]]` (resolves to `meta/dashboard.base` or `meta/dashboard.md`) were removed.

## What Didn't Work

Trusting the lint agent's "dead link" verdict without verifying the file extension. The agent scanned only `.md` files when checking whether a link target exists.

## Solution

Before accepting any lint agent's dead-link removal, verify the target exists under any extension:

```bash
find memory/ -name "Wiki Map*" -o -name "dashboard*" 2>/dev/null
```

Obsidian resolves wikilinks by **filename only**, regardless of extension. `[[Wiki Map]]` resolves to `Wiki Map.canvas`; `[[dashboard]]` resolves to `dashboard.base` or `dashboard.md` — whichever exists.

## Why It Works

Obsidian's wikilink resolution is extension-agnostic. A link is only truly dead if no file with that basename exists anywhere in the vault, under any extension.

## Prevention

When running or reviewing wiki-lint output:
1. Cross-check flagged dead links against `find memory/ -name "<basename>*"` before removing them.
2. Treat `.canvas`, `.base`, `.pdf`, and `.png` files as valid link targets.
3. The lint agent should check all file extensions — this is a known gap in the current `wiki-lint` skill and is on the v1.5.0 backlog (see [[cherry-picks]]).

## See Also

- [[cherry-picks]] — v1.5.0 backlog item: extend `wiki-lint` dead-link check to all file extensions
- [[LLM Wiki Pattern]] — vault conventions
