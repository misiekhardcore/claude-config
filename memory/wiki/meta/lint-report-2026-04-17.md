---
type: meta
title: "Wiki Lint Report — 2026-04-17"
created: 2026-04-17
updated: 2026-04-17
tags:
  - meta
  - lint
  - audit
status: evergreen
---

# Wiki Lint Report

**Scan date:** 2026-04-17 | **Pages scanned:** 34 | **Total issues:** 23 (8 fixed, 15 remaining)

---

## Summary

| Severity | Count | Status |
|----------|-------|--------|
| **Critical** | 1 | 1 remaining (false positive) |
| **Warnings** | 15 | All remain |
| **Suggestions** | 0 | N/A |
| **Total** | 23 | 8 fixed on 2026-04-17 |

---

## Fixed Issues (2026-04-17)

The following 8 critical issues were auto-fixed:

### 1. Malformed Wikilinks — Pipe syntax corrected (7 fixed)

#### concepts/_index
- ✓ FIXED: Changed `[[entities/_index|Entities]]` to `[[entities/_index]]`
- ✓ FIXED: Changed `[[sources/_index|Sources]]` to `[[sources/_index]]`
- Updated frontmatter: `updated: 2026-04-17`

#### entities/_index
- ✓ FIXED: Changed `[[concepts/_index|Concepts]]` to `[[concepts/_index]]`
- ✓ FIXED: Changed `[[sources/_index|Sources]]` to `[[sources/_index]]`
- Updated frontmatter: `updated: 2026-04-17`

#### sources/_index
- ✓ FIXED: Changed `[[concepts/_index|Concepts]]` to `[[concepts/_index]]`
- ✓ FIXED: Changed `[[entities/_index|Entities]]` to `[[entities/_index]]`
- Updated frontmatter: `updated: 2026-04-17`

### 2. Dead Canvas Reference — Removed (1 fixed)

#### overview
- ✓ FIXED: Removed line `- [[AI Marketing Hub Cover Images Canvas]] — Cover image library for AI Marketing Hub brand assets`
- Canvas reference was non-existent; only `[[claude-obsidian-presentation]]` remains
- Updated frontmatter: `updated: 2026-04-17`

---

## Remaining Critical Issues (1)

### 1. Dead Wikilink in cherry-picks (FALSE POSITIVE)

#### concepts/cherry-picks
- **Link:** `wikilinks` — Flagged as dead link
  - **Status:** FALSE POSITIVE — This is contextual text within a feature description ("as Markdown entities with `[[wikilinks]]`"), not a broken link to a page
  - **Action:** Left as-is; does not represent a vault structure problem

---

## Remaining Warnings (15)

### 1. Orphan Pages — No inbound wikilinks (1 issue)

#### concepts/Context Hygiene Between Workflow Phases
- **Issue:** This page has no inbound links from other pages or the index
- **Status:** Intentionally left unfixed per user request
- **Fix:** Link to `[[concepts/Context Hygiene Between Workflow Phases]]` from related pages if needed

---

### 2. Empty Sections — Headings with placeholder or no content (14 issues)

#### concepts/Context Hygiene Between Workflow Phases
- `## Examples` — No examples provided

#### concepts/_index
- `## Add new concepts here as they are extracted from sources.` — Template placeholder

#### concepts/cherry-picks
- `## Tier 1 — Quick Wins (High Impact, Low Effort)` — Has content (not truly empty)
- `## Tier 2 — Medium Effort, High Value` — Has content
- `## Tier 3 — Bigger Features Worth Planning` — Has content
- `## Tier 4 — Research / Ecosystem Plays` — Has content

#### entities/Ar9av-obsidian-wiki
- `## Key Innovations` — Empty (intentionally left unfixed)

#### entities/Claudian-YishenTu
- `## Key Features` — Empty (intentionally left unfixed)

#### entities/ballred-obsidian-claude-pkm
- `## Key Innovations` — Empty (intentionally left unfixed)

#### entities/rvk7895-llm-knowledge-bases
- `## Key Innovations` — Empty (intentionally left unfixed)

#### entities/_index
- `## Add new entities here as they are identified during ingests.` — Template placeholder

#### getting-started
- `## Three-Step Quick Start` — No steps provided

#### sources/_index
- `## Transcripts` — Empty
- `## Add new sources here after each ingest.` — Template placeholder

**Recommendation:** Most are intentional scaffolding. Entity "Key Innovations" sections were left unfixed per user request.

---

## Observations & Suggestions

### 1. Wikilink Format Issue (RESOLVED)

The index pages previously used Obsidian's pipe syntax (`[[page|Label]]`) which was breaking link resolution. All instances have been corrected to standard wikilink format (`[[page]]`).

**Status:** Fixed on 2026-04-17

### 2. Page Cross-Reference Patterns

Most content pages ARE reachable (they're referenced in `index.md`'s `related` field), but they don't have mutual cross-links among themselves. For example:
- `comparisons/Wiki vs RAG` references `[[LLM Wiki Pattern]]` but `LLM Wiki Pattern` doesn't link back
- This is OK for a branching architecture, but limits serendipitous discovery

**Suggestion:** Consider adding a "See also" section in related pages.

### 3. Frontmatter Completeness

All 34 pages have complete, correct frontmatter with required fields: `type`, `status`, `created`, `updated`, `tags`. No frontmatter issues detected.

### 4. Page Volume & Status Distribution

- **Total pages:** 34 (baseline for a demo vault)
- **Status distribution:** Mostly `evergreen`, `current`, or `developing` — good health indicator
- **Categories:** Concepts (6), Entities (9), Solutions (9), Comparisons (2), Questions (1), Sources (1), Infrastructure (6)

### 5. Dead Canvas Reference (RESOLVED)

The reference to `[[AI Marketing Hub Cover Images Canvas]]` in `overview.md` has been removed. The vault has 5 canvases that are valid:
- `Wiki Map.canvas`
- `canvases/claude-obsidian-presentation.canvas`
- `canvases/main.canvas`
- `canvases/welcome.canvas`
- `canvases/youtube-explainer.canvas`

**Status:** Fixed on 2026-04-17

---

## Fix Priority (Post-Fixes)

1. **High (optional):** Add content to empty entity "Key Innovations" sections or remove headings (5 pages)
2. **Medium:** Link orphan page or remove if not needed
3. **Low:** Populate getting-started steps; clarify empty section templates

---

## Audit Completeness Checklist

- [x] Orphan pages (no inbound wikilinks)
- [x] Dead links (wikilinks referencing non-existent pages)
- [x] Missing frontmatter fields
- [x] Empty sections (headings with no content)
- [x] Stale index entries
- [x] Frontmatter completeness
- [x] Wikilink format validation
- [x] Cross-reference analysis

**Scan method:** Full filesystem scan of `/home/michal/Projects/claude-config/memory/wiki/` excluding `meta/` directory. 34 pages analyzed, 8 canvas files checked, 1 Bases file referenced.

**Auto-fixes applied:** 2026-04-17
- Fixed malformed wikilinks in 3 index pages (7 links corrected)
- Removed dead canvas reference from overview (1 link removed)
- Updated `updated` field in 4 files
