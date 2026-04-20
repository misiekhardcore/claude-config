---
type: concept
title: "Wiki Frontmatter Schema Extension Pattern"
created: 2026-04-20
updated: 2026-04-20
tags:
  - concept
  - knowledge-management
  - obsidian
  - schema
  - pattern
status: current
confidence: INFERRED
evidence:
  - "[[llm-wiki-v2-extensions]]"
related:
  - "[[LLM Wiki Pattern]]"
  - "[[llm-wiki-v2-extensions]]"
  - "[[Graphify]]"
  - "[[skill-frontmatter-reference]]"
sources: []
---

# Wiki Frontmatter Schema Extension Pattern

A set of design decisions and pitfalls for extending an Obsidian-backed [[LLM Wiki Pattern]] vault with new universal frontmatter fields. Derived from implementing typed relationships and confidence tagging (EXTRACTED/INFERRED/AMBIGUOUS) across a 97-page vault.

---

## Context

Applies when adding new fields to all wiki pages in an Obsidian vault, particularly:
- Universal fields that must appear on every page type
- Fields that may already exist on some page types with different semantics
- Fields inspired by external schema patterns (e.g. [[Graphify]], [[llm-wiki-v2-extensions]])

---

## Guidance

### 1. Obsidian requires flat YAML — never nest objects

Obsidian's Properties UI breaks on nested YAML objects. The [[llm-wiki-v2-extensions]] pattern proposes typed `relationships:` blocks:

```yaml
# BAD — breaks Obsidian Properties panel
relationships:
  supersedes: ["[[old-page]]"]
  contradicts: ["[[conflicting-page]]"]
```

The correct approach: flat optional lists alongside `related:`:

```yaml
# GOOD — flat, Obsidian-compatible
supersedes:
  - "[[old-page]]"
contradicts:
  - "[[conflicting-page]]"
related:
  - "[[general-link]]"
```

### 2. Handle field name collisions before adding universal fields

When a new universal field name already exists on a subset of pages with different semantics, rename the old field first.

Example: source pages had `confidence: high|medium|low` (source reliability). Adding `confidence: EXTRACTED|INFERRED|AMBIGUOUS` (claim derivation) to all pages created a collision. Resolution: rename the existing field to `source_reliability:` before adding the universal `confidence:` field.

Pattern: **inspect all page types for the new field name before migrating; rename collisions, don't overwrite**.

### 3. CLAUDE.md is a pointer, not the schema — update both

When an issue says "update `memory/CLAUDE.md`", check whether CLAUDE.md is the actual schema file or a pointer to it. In this vault, CLAUDE.md delegates schema detail to `skills/wiki/references/frontmatter.md`. The correct approach is:

- Add a brief "Required Frontmatter Fields" and "Allowed Relationship Types" section to CLAUDE.md (the entry point agents read first)
- Put the full field spec in `frontmatter.md`

**Do not** put the full schema in CLAUDE.md — it will drift out of sync with frontmatter.md.

### 4. `contradicts:` requires direct factual conflict — not criticism

`contradicts:` is semantically precise: the page's claims directly and factually conflict with the listed page's claims. A page that documents *limitations*, *tradeoffs*, or *critiques* of a concept does NOT contradict it. Use `related:` for critique pages.

Example: `llm-wiki-scalability-critique.md` documents engineering constraints on the LLM Wiki Pattern. It does not contradict the pattern — it contextualizes it. Using `contradicts: [[LLM Wiki Pattern]]` was wrong.

### 5. "Universal fields" means ALL page types — don't stop at the issue's migration list

When an issue says "migrate concept pages and source pages", the migration applies to universal fields on ALL page types including:
- Solution pages (`wiki/solutions/`)
- Meta pages (`wiki/meta/`)
- Directory index files (`_index.md`)
- Top-level structural files (index.md, log.md, hot.md, overview.md, getting-started.md)

Missing these causes schema violations flagged by `wiki-lint`. Always grep for pages missing the new field after the main migration pass.

### 6. YAML key naming: underscore over hyphen

YAML keys with hyphens (`depends-on`) work but are less idiomatic than underscores (`depends_on`). When translating issue-spec names to YAML keys, prefer underscore. Document the deviation explicitly in frontmatter.md and CLAUDE.md so future sessions don't "fix" it back.

---

## Why

These constraints emerge from three sources:
- **Obsidian's Properties panel** enforces flat YAML — nested objects silently fail to display
- **Schema collision** is a silent data corruption risk — old field values get overwritten by the new field's migration if the names collide
- **Semantic precision** in typed relationships is the core value proposition — imprecise `contradicts:` tags make graph traversal queries unreliable

---

## When to Use

- Adding any new frontmatter field intended to appear on all or most wiki pages
- Extending the schema to implement patterns from [[llm-wiki-v2-extensions]] or similar
- Bulk-migrating existing pages to a new schema version

---

## Examples

**Field collision resolution:**
```yaml
# Before
confidence: high    # source_type pages only

# After migration
source_reliability: high   # renamed old field
confidence: EXTRACTED      # new universal field
```

**Flat typed relationships:**
```yaml
# concept or entity page
confidence: INFERRED
evidence:
  - "[[source-page]]"
implements:
  - "[[LLM Wiki Pattern]]"
uses:
  - "[[dependency-concept]]"
related:
  - "[[general-link]]"   # kept for Obsidian graph view
```
