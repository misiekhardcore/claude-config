---
type: meta
title: "Dashboard"
updated: 2026-04-17
created: 2026-04-17
tags:
  - meta
  - dashboard
status: evergreen
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[index]]"
  - "[[overview]]"
  - "[[log]]"
  - "[[concepts/_index]]"
  - "[[Compounding Knowledge]]"
  - "[[lint-report-2026-04-17]]"
---

# Wiki Dashboard

Navigation: [[index]] | [[overview]] | [[log]] | [[hot]]

The dashboard uses **Obsidian Bases**. A core Obsidian feature shipped in v1.9.10 (August 2025). No plugin install required.

> [!tip] Embedded Bases view
> The interactive dashboard lives in [[dashboard.base]]. Open that file directly, or use the embed below.

![[dashboard.base]]

---

## Health Status (2026-04-17)

**Lint audit completed.** Full report: [[lint-report-2026-04-17]]

| Metric | Value | Status |
|--------|-------|--------|
| Pages scanned | 34 | ✓ Good |
| Critical issues | 8 | ⚠ Fix wikilinks |
| Warning issues | 15 | ⚠ Review empty sections |
| Frontmatter complete | 100% | ✓ All pages OK |
| Orphan pages | 1 | ⚠ Link or remove |

**Action items:**
1. Fix malformed wikilinks in index pages (pipe `|` syntax)
2. Add content to empty entity "Key Innovations" sections
3. Remove canvas reference that doesn't exist

---

## Legacy Dataview Dashboard (Optional)

If you are on Obsidian < 1.9.10 or prefer Dataview, the queries below still work. Just install the Dataview community plugin.

### Recent Activity

```dataview
TABLE type, status, updated FROM "wiki" SORT updated DESC LIMIT 15
```

### Seed Pages (Need Development)

```dataview
LIST FROM "wiki" WHERE status = "seed" SORT updated ASC
```

### Entities Missing Sources

```dataview
LIST FROM "wiki/entities" WHERE !sources OR length(sources) = 0
```

### Open Questions

```dataview
LIST FROM "wiki/questions" WHERE status = "developing" OR status = "seed" SORT updated DESC
```

### Comparisons

```dataview
TABLE verdict FROM "wiki/comparisons" SORT updated DESC
```

### Sources

```dataview
TABLE author, date_published, updated FROM "wiki/sources" WHERE type = "source" SORT updated DESC LIMIT 10
```
