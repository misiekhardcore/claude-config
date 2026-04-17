---
type: meta
status: evergreen
title: "Wiki Lint Report — 2026-04-17"
created: 2026-04-17
updated: 2026-04-17
tags:
  - meta
  - lint
  - audit
---

# Wiki Lint Report — 2026-04-17

**Date:** 2026-04-17  
**Scan scope:** Full wiki vault  
**Pages scanned:** 43  
**Total issues found:** 79 (34 critical, 45 warnings, 0 suggestions)

---

## Summary

| Category | Count | Status |
|----------|-------|--------|
| **Critical** | 34 | Must fix: dead links, stale index entries |
| **Warnings** | 45 | Should fix: empty sections, orphans, large pages |
| **Suggestions** | 0 | No missing concept pages detected |
| **Total** | 79 | 8 dimensions audited |

---

## Critical Issues (34)

Dead links and missing pages that break vault integrity.

### Dead Links to Non-Existent Pages (8)

Pages linking to files that don't exist in the vault:

- **[[concepts/_index]]** → `[[Wiki Map]]` — Canvas reference format incorrect
- **[[concepts/cherry-picks]]** → `[[wikilinks]]` — Page doesn't exist (contextual mention)
- **[[concepts/per-project-knowledge]]** → `[[Obsidian MCP Wiring]]` — Missing research page
- **[[concepts/per-project-knowledge]]** → `[[TypeScript Typing Patterns]]` — Missing technical page
- **[[getting-started]]** → `[[Wiki Map]]` — Canvas format issue
- **[[hot]]** → `[[Wiki Map]]` — Canvas format issue
- **[[index]]** → `[[Wiki Map]]` — Canvas format issue
- **[[overview]]** → `[[claude-obsidian-presentation]]` — Missing source page

**Fixes needed:**
- Create `concepts/wikilinks.md` with Obsidian syntax documentation
- Create `concepts/obsidian-mcp-wiring.md` for MCP architecture details
- Create `concepts/typescript-typing-patterns.md` for typing patterns
- Create `sources/claude-obsidian-presentation.md` for presentation source
- Fix canvas links: use `[[Wiki Map.canvas]]` or remove references

### Broken Anchor Links (18)

Pages linking to specific sections within `[[cherry-picks]]` using anchor syntax. The `cherry-picks` page exists but lacks proper heading anchors:

**Affected pages (all linking to `cherry-picks` with anchors):**
- [[entities/Ar9av-obsidian-wiki]] — 4 broken anchors (items 4, 6, 9, 13)
- [[entities/Nexus-claudesidian-mcp]] — 1 broken anchor (item 11)
- [[entities/ballred-obsidian-claude-pkm]] — 3 broken anchors (items 2, 7, 8)
- [[entities/kepano-obsidian-skills]] — 4 broken anchors (items 1, 3, 9, 12)
- [[entities/rvk7895-llm-knowledge-bases]] — 2 broken anchors (items 5, 10)

**Examples:**
- `[[cherry-picks#13. Schema-Emergent Vault Mode]]`
- `[[cherry-picks#4. Delta Tracking Manifest]]`
- `[[cherry-picks#11. obsidian-memory-mcp Integration]]`

**Fix:** Review `concepts/cherry-picks.md` and ensure each item has a matching ## heading (e.g., `## 1. URL Ingestion in /wiki-ingest`), or remove anchor references and link to the page directly.

### Stale Index Entries (2)

The `index.md` file references files/resources that don't exist:

- **[[index]]** → `[[Wiki Map]]` — Ambiguous: is it the canvas file or a page?
- **[[meta/dashboard]]** → `[[dashboard.base]]` — Airtable/Basecamp reference missing

**Fixes:**
- Clarify canvas reference: use `[[Wiki Map.canvas]]` if linking to canvas, or create `concepts/wiki-map.md` for conceptual overview
- Decide if dashboard base is still maintained; if not, remove the reference

### Malformed Wikilinks in Report (6)

The existing lint report contains broken wikilinks:

- **[[meta/lint-report-2026-04-17]]** contains incomplete/invalid links:
  - `[[page]]` — Too generic, ambiguous target
  - `[[page Label]]` — Malformed syntax
  - `[[AI Marketing Hub Cover Images Canvas]]` — Page doesn't exist
  - `[[claude-obsidian-presentation]]` — Doesn't exist (should be source)
  - `[[wikilinks]]` — Doesn't exist

**Fix:** This is a self-referential issue in the report itself. Either recreate the report or clean up these references.

---

## Warnings (45)

Best practice improvements needed.

### Empty Sections (28 pages)

Headings with no or minimal content underneath indicate incomplete pages. Common in newer research pages:

**Pages with 1+ empty sections:**
- [[comparisons/Wiki vs RAG]] — Main heading empty
- [[concepts/Context Hygiene Between Workflow Phases]] — 2 empty sections (main + Examples)
- [[concepts/Hot Cache]] — Recent Context empty
- [[concepts/_index]] — Placeholder text
- [[concepts/cherry-picks]] — 4 tier headings (Tier 1-4)
- [[concepts/gcode-lsp-architecture]] — 3 empty: Design Patterns, Layer Details, Testing Strategy
- [[concepts/per-project-knowledge]] — Three Core Options empty
- [[entities/Ar9av-obsidian-wiki]] — Key Innovations empty
- [[entities/Claudian-YishenTu]] — Key Features empty
- [[entities/_index]] — Placeholder text
- [[entities/ballred-obsidian-claude-pkm]] — Key Innovations empty
- [[entities/rvk7895-llm-knowledge-bases]] — Key Innovations empty
- [[entities/vscode-gcode-extension]] — Core Concepts, Development empty
- [[getting-started]] — Three-Step Quick Start empty
- [[meta/claude-obsidian-v1.2.0-release-session]] — 3 sections empty
- [[meta/full-audit-and-system-setup-session]] — 1 heading empty
- [[meta/pr-feedback-resolution-wiki-migration-2026-04-17]] — Main section empty
- [[solutions/client-side-enumeration-pattern]] — Main heading empty
- [[solutions/fs-readdir-dirent-typing]] — Main heading empty
- [[solutions/interface-extraction-import-type]] — Main heading empty
- [[solutions/lsp-file-watcher-linux]] — Main heading empty
- [[solutions/variable-formatting-utilities]] — Main heading empty
- [[solutions/visualizer-variable-resolution-pipeline]] — Main heading empty
- [[solutions/workspace-symbol-architecture]] — Main heading empty
- [[sources/_index]] — Placeholder text
- [[sources/vscode-gcode-extension-architecture]] — Key Insights empty

**Fix strategy:**
1. Fill with substantive content (preferred)
2. Remove empty headings if section isn't needed
3. Use explicit placeholders like "TBD" or "Coming soon" if actively being developed

### Large Page (1)

- **[[concepts/gcode-lsp-architecture]]** — 397 lines exceeds 300-line readability threshold

**Suggested split:**
- Keep overview in main page
- Extract to: `gcode-lexer-design.md`, `gcode-parser-design.md`, `gcode-ast-design.md`, `gcode-lsp-services.md`

### Orphan Pages (1)

- **[[concepts/Context Hygiene Between Workflow Phases]]** — Not referenced from index or other pages

**Fixes:**
- Add to `concepts/_index.md` related list
- Link from `[[LLM Wiki Pattern]]` or `[[Hot Cache]]` (related topics)
- Or archive if superseded

---

## Suggestions (0)

No frequently-mentioned concepts lacking dedicated pages were detected. Wiki structure is well-proportioned.

---

## Audit Checklist

All 8 dimensions audited:

- [x] **Frontmatter completeness** (type, status, dates, tags) — PASS
- [x] **Dead wikilinks** — 8 critical issues found
- [x] **Broken anchors** — 18 broken references to cherry-picks items
- [x] **Empty sections** — 28 pages with skeleton content
- [x] **Orphan pages** — 1 page with no inbound links
- [x] **Index staleness** — 2 stale/ambiguous entries
- [x] **Large pages** — 1 page over 300 lines
- [x] **Stale seeds** — 0 seed pages >30 days old

---

## Recommended Actions

### Immediate (Unblocks other work)
1. Fix canvas link format across 3 pages (index, hot, getting-started) — use `[[Wiki Map.canvas]]` or remove
2. Create 4 missing concept/source pages (wikilinks, obsidian-mcp-wiring, typescript-typing-patterns, claude-obsidian-presentation)
3. Verify and fix `cherry-picks.md` anchor headings for entity links
4. Clean up malformed wikilinks in this report (or regenerate)

### Short Term (Quality)
1. Fill empty sections in 28 pages — prioritize solving pages first (7 files)
2. Add inbound link to orphan page or archive it
3. Archive stale session notes in `meta/` folder
4. Consider splitting gcode-lsp-architecture

### Long Term (Process)
1. Add "no orphan pages" rule to contributing guidelines
2. Establish stale index cleanup cadence (quarterly)
3. Create page templates with required structures to reduce empty sections
4. Add pre-commit hook to validate frontmatter and dead links

---

## Notes

- **Vault size:** 43 pages across 8 subdirectories (good organization)
- **Status distribution:** Mostly "evergreen" or "current" (healthy)
- **Frontmatter:** All pages have complete required fields — no issues
- **False positives:** The `[[wikilinks]]` reference in cherry-picks is contextual (Markdown explanation), not a broken link

**Report generated:** 2026-04-17 by comprehensive wiki-lint audit  
**Next audit recommended:** 2026-05-15 (30 days)
