---
type: concept
title: "Wiki Memory Lifecycle: Consolidation Tier Implementation Pattern"
created: 2026-04-20
updated: 2026-04-20
tags:
  - concept
  - knowledge-management
  - llm-wiki
  - obsidian
  - frontmatter
  - implementation
status: current
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[llm-wiki-v2-extensions]]"
  - "[[LLM Wiki Pattern]]"
  - "[[wiki-frontmatter-schema-extension]]"
sources:
  - "[[llm-wiki-v2-extensions]]"
---

# Wiki Memory Lifecycle: Consolidation Tier Implementation Pattern

How to implement the four-tier memory lifecycle model in an Obsidian wiki vault, based on issue #12 of claude-obsidian.

---

## The Four Tiers

| Tier | Cadence | Examples |
|------|---------|---------|
| **transient** | 7 days | Bug reports, status updates, session observations, short-lived questions |
| **episodic** | 30 days | Session summaries, source ingestion records, what-was-done notes |
| **semantic** | 90 days | Cross-session facts, patterns, concepts, entities, comparisons |
| **procedural** | 180 days | Workflows, how-to guides, skill references |

Source: rohitg00's LLM Wiki v2 extensions. See [[llm-wiki-v2-extensions]] for the underlying theory (Ebbinghaus forgetting curves, confidence decay).

---

## Key Design Decisions

### Explicit `tier:` field, not computed at runtime

The `tier:` field is stored explicitly in each page's frontmatter. It is NOT computed from `type:` at runtime.

**Why:** Explicit field makes tier visible, editable, and overridable per page. The type→tier mapping is a *default*, not a hard constraint. A rapidly-evolving concept page might warrant `transient` instead of the typical `semantic`.

### Type → Tier Default Table

```
concept    → semantic
entity     → semantic
source     → episodic
comparison → semantic
question   → transient
meta       → semantic
overview   → semantic
domain     → semantic
```

No `procedural` pages exist yet — reserved for future skill/workflow page types.

### Per-skill type→tier tables are intentionally scoped

Each ingest skill (wiki-ingest, save, autoresearch) has its own type→tier table covering only the page types *that skill commonly creates*. These tables differ intentionally:

- `wiki-ingest`: all 8 canonical types
- `save`: concept, synthesis, source, decision, session
- `autoresearch`: concept, synthesis, source, entity

Each table ends with "any unlisted type defaults to `semantic`." This is not an inconsistency — it reflects each skill's distinct page-type vocabulary.

> **Trap to avoid:** During code review, inconsistent tables across skills *look* like a bug. They are not. Document the catch-all default clearly in each table to make intent visible.

### Migration bootstraps the clock, not retroactive review

When backfilling `reviewed_at:` on existing pages during a migration, set it to **today's date** — not the page's `created:` date or `updated:` date.

**Why:** The clock starts from when the lifecycle system was introduced. Setting historical dates would immediately flag every old page as stale before the system is even running.

---

## Implementation Mechanics

### Frontmatter fields added

Both fields are **universal** — required on every page type including solutions, meta, _index, and structural files:

```yaml
tier: <transient|episodic|semantic|procedural>
reviewed_at: YYYY-MM-DD
```

Place them after `status:` in the YAML block. Flat YAML only — no nested objects (Obsidian Properties UI requirement).

### Stale detection by wiki-lint

wiki-lint check #9 reads `tier:` and `reviewed_at:` from frontmatter, computes staleness, and injects/removes a `[!stale]` callout directly into the page body (idempotent):

```
> [!stale]
> This page is overdue for review. Last verified: {{reviewed_at}}. Update `reviewed_at:` in frontmatter when verified.
```

The callout is placed immediately after the frontmatter closing `---` and before the first heading. If the page is no longer stale, the callout is removed.

### Canonical callout format lives in exactly one place

The authoritative `[!stale]` callout format belongs in `wiki-lint/SKILL.md`. Reference files (maintenance-rules.md, etc.) should quote it but label it "exact format injected by wiki-lint." Do not let reference files define a conflicting variant.

### Autonomous tier assignment in ingest skills

No user prompt needed. Each skill assigns `tier:` and `reviewed_at:` automatically when creating new pages, using its type→tier table with `semantic` as the catch-all fallback.

---

## When to Use This Pattern

- Any LLM wiki vault that has grown past ~50 pages and is accumulating stale claims
- When you want to prompt human review on a schedule rather than ad-hoc
- As a precursor to more advanced lifecycle features (Ebbinghaus decay, confidence scores) from LLM Wiki v2

## Out of Scope

- Automated confidence decay (requires infrastructure beyond markdown frontmatter)
- Scheduled cron/ScheduleWakeup to trigger lint automatically (separate concern — issue #13)
- Tier *demotion* (e.g., auto-downgrading semantic → transient over time)
