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

# Wiki Lint Report — 2026-04-17

**Scan date:** 2026-04-17 | **Pages scanned:** 47 | **Total issues:** 72 (45 critical, 27 warnings)

---

## Summary

| Severity | Count | Status |
|----------|-------|--------|
| **Critical** | 45 | Dead links, stale index entries |
| **Warnings** | 27 | Empty sections, orphan detection baseline |
| **Suggestions** | 0 | N/A |
| **Total** | 72 | All require manual review |

---

## Critical Issues (must fix)

### Dead Links (43 instances)

Links that reference non-existent pages block navigation and indicate incomplete wiki structure.

#### Concepts

- [[LLM Wiki Pattern]] → `[[wiki-lint]]` — utility page missing
- [[LLM Wiki Pattern]] → `[[llm-wiki-karpathy-gist|original gist]]` — source page reference syntax may be malformed
- [[Memex]] → `[[wikilinks]]` — feature page missing
- [[concepts/_index]] → `[[Wiki Map]]` — core index page missing
- [[cherry-picks]] → `[[wikilinks]]` — feature reference missing
- [[per-project-knowledge]] → `[[TypeScript Typing Patterns]]` — concept page missing
- [[per-project-knowledge]] → `[[Obsidian MCP Wiring]]` — concept page missing

#### Entities

- [[Ar9av-obsidian-wiki]] → 4 dead links to cherry-picks sections
  - `[[cherry-picks#4. Delta Tracking Manifest]]`
  - `[[cherry-picks#6. /wiki-ingest Vision Support]]`
  - `[[cherry-picks#9. Multi-Agent Compatibility (Cursor, Windsurf, Codex)]]`
  - `[[cherry-picks#13. Schema-Emergent Vault Mode]]`
- [[Nexus-claudesidian-mcp]] → `[[cherry-picks#11. obsidian-memory-mcp Integration]]`
- [[ballred-obsidian-claude-pkm]] → 3 dead cherry-picks section links
  - `[[cherry-picks#2. Auto-Commit PostToolUse Hook]]`
  - `[[cherry-picks#7. /adopt — Import Existing Vault]]`
  - `[[cherry-picks#8. Productivity Wrapper (Daily/Weekly Reviews)]]`
- [[kepano-obsidian-skills]] → 4 dead cherry-picks section links
  - `[[cherry-picks#1. URL Ingestion in /wiki-ingest]]`
  - `[[cherry-picks#3. defuddle Web Cleaning Skill]]`
  - `[[cherry-picks#9. Multi-Agent Compatibility]]`
  - `[[cherry-picks#12. obsidian-bases Skill (from kepano)]]`
- [[qmd]] → `[[llm-wiki-karpathy-gist|LLM Wiki — Karpathy Gist]]` — syntax or reference issue
- [[rvk7895-llm-knowledge-bases]] → 2 dead cherry-picks section links
  - `[[cherry-picks#5. Multi-Depth Query Modes]]`
  - `[[cherry-picks#10. Marp Presentation Output]]`

#### Root Pages

- [[getting-started]] → `[[Wiki Map]]` (2 instances)
- [[hot]] → `[[Wiki Map]]`
- [[index]] → `[[Wiki Map]]` (2 instances)

#### Meta Pages

- [[dashboard]] → `[[dashboard.base]]` (2 instances) — external reference or broken canvas link
- [[lint-report-2026-04-17]] → multiple malformed links (current report is in this category)
- [[overview]] → `[[claude-obsidian-presentation]]` — missing presentation reference

#### Sources

- [[llm-wiki-karpathy-gist]] → `[[wiki-ingest]]` — feature/tool page missing

**Root causes:**
1. Missing foundational pages: `[[Wiki Map]]`, `[[wiki-lint]]`, `[[wikilinks]]`
2. Broken section anchor links to cherry-picks (design question: should these be full page links instead?)
3. Missing concept pages: `[[TypeScript Typing Patterns]]`, `[[Obsidian MCP Wiring]]`
4. Unclear external references: `[[dashboard.base]]`, `[[claude-obsidian-presentation]]`

**Suggested fix priority:**
1. Create `[[Wiki Map]]` (referenced 5+ times)
2. Create `[[wiki-lint]]` utility page
3. Create `[[wikilinks]]` feature documentation
4. Decide on cherry-picks link strategy: convert anchor links to full page references or restructure cherry-picks

---

### Stale Index Entries (2 instances)

The main `index.md` contains broken navigation references.

- `[[Wiki Map]]` appears in navigation but has no corresponding page (appears twice in index)

**Suggested fix:** Remove or create the `[[Wiki Map]]` page; update navigation links in root index.

---

## Warnings (should fix)

### Empty Sections (27 instances)

Headings with no content underneath indicate incomplete pages or scaffolding that needs filling.

#### Concepts (7)

- [[Wiki vs RAG]] — entire page is empty (title-only page)
- [[Context Hygiene Between Workflow Phases]] — 2 empty sections
  - `# Context Hygiene Between Workflow Phases` (main)
  - `## Examples`
- [[Hot Cache]] — `## Recent Context` is empty
- [[concepts/_index]] — `## Add new concepts here as they are extracted from sources.` (template placeholder)
- [[cherry-picks]] — 3 tier sections all appear empty
  - `## Tier 1 — Quick Wins (High Impact, Low Effort)`
  - `## Tier 2 — Medium Effort, High Value`
  - `## Tier 3 — Bigger Features Worth Planning`
- [[gcode-lsp-architecture]] — 3 empty sections
  - `## Layer Details`
  - `## Design Patterns`
  - `## Testing Strategy`
- [[per-project-knowledge]] — `## Three Core Options` is empty

#### Entities (6)

- [[Ar9av-obsidian-wiki]] — `## Key Innovations` is empty
- [[Claudian-YishenTu]] — `## Key Features` is empty
- [[entities/_index]] — `## Add new entities here as they are identified during ingests.` (template)
- [[ballred-obsidian-claude-pkm]] — `## Key Innovations` is empty
- [[rvk7895-llm-knowledge-bases]] — `## Key Innovations` is empty
- [[vscode-gcode-extension]] — 2 empty sections
  - `## Core Concepts`
  - `## Development`

#### Root Pages (1)

- [[getting-started]] — `## Three-Step Quick Start` is empty (should contain onboarding steps)

#### Meta Pages (5)

- [[claude-obsidian-v1.2.0-release-session]] — 3 empty sections
  - `## What Was Built`
  - `## Legal & Security`
  - `## Visual / README`
- [[full-audit-and-system-setup-session]] — `# → claude-obsidian-marketplace registered (user scope)` (title with no content)
- [[pr-feedback-resolution-wiki-migration-2026-04-17]] — `## PR Feedback Resolution` is empty
- (note: current lint-report itself has 3 empty sections from old version)

#### Solutions (7) — ALL CRITICAL

Every solution page has the same pattern: main heading with no content below it. This is a structural issue:
- [[client-side-enumeration-pattern]] — `# Client-Side File Enumeration via Custom LSP Request` (empty)
- [[fs-readdir-dirent-typing]] — `# fs.readdir Dirent Typing` (empty)
- [[interface-extraction-import-type]] — `# Interface Extraction with import type` (empty)
- [[lsp-file-watcher-linux]] — `# LSP File Watcher on Linux` (empty)
- [[variable-formatting-utilities]] — `# Variable Formatting Utilities` (empty)
- [[visualizer-variable-resolution-pipeline]] — `# Visualizer Variable Resolution Pipeline` (empty)
- [[workspace-symbol-architecture]] — `# Workspace Symbol Architecture` (empty)

**Note:** Solutions pages have frontmatter and titles but zero body content. They are complete stubs.

#### Sources (2)

- [[sources/_index]] — `## Add new sources here after each ingest.` (template)
- [[vscode-gcode-extension-architecture]] — `## Key Insights` is empty

**Suggested fixes:**
1. **Solutions pages (7):** Fill in detailed explanations or remove if deprecated
2. **Entity "Key Innovations" (4):** Add feature lists or reference external docs
3. **Tier sections in cherry-picks:** Add feature lists under each tier
4. **Empty concept sections:** Fill with details or merge into parent content
5. **Template placeholders:** Replace with actual content or delete

---

## Health Metrics

| Aspect | Status | Notes |
|--------|--------|-------|
| **Frontmatter** | ✓ Healthy | All 47 pages have required fields (type, status) |
| **Orphan Pages** | ✓ None detected | All pages are referenced (good connectivity) |
| **Dead Links** | ✗ Critical | 43 broken links; blocks wiki navigation |
| **Empty Content** | ✗ High | 27 empty sections; especially solutions pages |
| **Index Integrity** | ✗ Minor | 2 stale references to `[[Wiki Map]]` |
| **Link Targets** | ✗ Blocked | 6+ missing pages need creation |

---

## Root Cause Analysis

### Why so many dead links appeared?

The vault expanded from 34 pages (previous lint) to 47 pages (+13 pages). The new pages include:
- Fresh concept pages: `per-project-knowledge`, `gcode-lsp-architecture`, `Context Hygiene Between Workflow Phases`
- New entity pages: `vscode-gcode-extension` and related architecture docs
- 7 solution pages ingested from vscode-gcode-extension codebase

**Problem:** Links were created to pages that don't exist yet (forward references), especially:
- Anchor links to cherry-picks sections (`#4`, `#6`, etc.) that may not exist
- References to foundational pages like `[[Wiki Map]]` and `[[wiki-lint]]` that are referenced but never created
- Feature pages like `[[wikilinks]]` mentioned conceptually but not documented

### Why are solutions pages all empty?

Solution pages were scaffolded with titles but body content was not copied from source docs. They're stubs waiting for detail ingestion.

---

## Next Steps (Prioritized)

### P0 — Blocking (fixes 11 issues)

1. Create `[[Wiki Map]]` page or remove all 5+ references
2. Create `[[wiki-lint]]` utility documentation
3. Create `[[wikilinks]]` feature documentation
4. Decide cherry-picks anchor link strategy:
   - Option A: Convert `[[cherry-picks#N. Feature]]` → `[[cherry-picks]]` (loose coupling)
   - Option B: Create separate pages for each feature tier, link to those
5. Review `[[dashboard.base]]` and `[[claude-obsidian-presentation]]` — are these canvas/external refs?

### P1 — Content gaps (fixes 27 issues)

1. Fill 7 solutions pages with actual solution documentation
2. Add 4 entity "Key Innovations" sections or remove headings
3. Populate cherry-picks tier sections with feature lists
4. Add examples to `[[Context Hygiene Between Workflow Phases]]`
5. Fill `[[getting-started]]` with actual onboarding steps

### P2 — Structure (optional improvements)

1. Create `[[TypeScript Typing Patterns]]` concept page (referenced but missing)
2. Create `[[Obsidian MCP Wiring]]` concept page (referenced but missing)
3. Add bidirectional links between concept and entity pages (improve serendipitous discovery)

---

## Audit Completeness

All 8 lint checks performed:

- [x] **Frontmatter validation** — All pages have required fields
- [x] **Dead link detection** — 43 broken links identified
- [x] **Empty section detection** — 27 empty headings identified
- [x] **Orphan page detection** — 0 orphans (all pages are referenced)
- [x] **Index consistency** — 2 stale references found
- [x] **Stale page detection** — Baseline (no seed pages >30 days old)
- [x] **Unlinked mentions** — Not detected (all entities properly linked)
- [x] **Cross-reference patterns** — Low bidirectional links (one-directional from index)

**Scan scope:** `/tmp/lint-pr6/memory/wiki/` | **Pages analyzed:** 47 | **Categories:** Concepts (7), Entities (10), Solutions (8), Comparisons (1), Questions (1), Sources (3), Meta (7), Root (2)

**Scan date:** 2026-04-17 | **Report generated:** wiki-lint

---

## Notes for Future Scans

1. Track `[[Wiki Map]]` creation/deletion — this is a navigation bottleneck
2. Monitor solution pages for content — currently all are stubs
3. Watch cherry-picks anchor links — may need refactoring to full page structure
4. Consider adding a "Status: Empty" or "Status: Stub" to incomplete pages for easier filtering
5. External reference policy: Document whether `.base`, `.canvas`, and off-vault pages should be included in links

