# claude-obsidian — Claude + Obsidian Wiki Vault

This folder is both a Claude Code plugin and an Obsidian vault.

**Plugin name:** `claude-obsidian`
**Skills:** `/wiki`, `/wiki-ingest`, `/wiki-query`, `/wiki-lint`
**Vault path:** This directory (open in Obsidian directly)

## What This Vault Is For

This vault demonstrates the LLM Wiki pattern — a persistent, compounding knowledge base for Claude + Obsidian. Drop any source, ask any question, and the wiki grows richer with every session.

## Vault Structure

```
.raw/           source documents — immutable, Claude reads but never modifies
wiki/           Claude-generated knowledge base
_templates/     Obsidian Templater templates
_attachments/   images and PDFs referenced by wiki pages
```

## How to Use

Drop a source file into `.raw/`, then tell Claude: "ingest [filename]".

Ask any question. Claude reads the index first, then drills into relevant pages.

Run `/wiki` to scaffold a new vault or check setup status.

Run "lint the wiki" every 10-15 ingests to catch orphans and gaps.

## Cross-Project Access

To reference this wiki from another Claude Code project, add to that project's CLAUDE.md:

```markdown
## Wiki Knowledge Base
Path: /path/to/this/vault

When you need context not already in this project:
1. Read wiki/hot.md first (recent context, ~500 words)
2. If not enough, read wiki/index.md
3. If you need domain specifics, read wiki/<domain>/_index.md
4. Only then read individual wiki pages

Do NOT read the wiki for general coding questions or things already in this project.
```

## Plugin Skills

| Skill | Trigger |
|-------|---------|
| `/wiki` | Setup, scaffold, route to sub-skills |
| `ingest [source]` | Single or batch source ingestion |
| `query: [question]` | Answer from wiki content |
| `lint the wiki` | Health check |
| `/save` | File the current conversation as a structured wiki note |
| `/autoresearch [topic]` | Autonomous research loop: search, fetch, synthesize, file |
| `/canvas` | Visual layer: add images, PDFs, notes to Obsidian canvas |

## MCP (Optional)

If you configured the MCP server, Claude can read and write vault notes directly.
See `skills/wiki/references/mcp-setup.md` for setup instructions.

---

## Schema

This section defines what belongs where so every session makes the same structural decisions.

### Entity Types

| Directory | Type value | What goes here | Naming convention |
|-----------|-----------|----------------|-------------------|
| `wiki/concepts/` | `concept` | Patterns, techniques, ideas, how-things-work explanations | Title Case or kebab-case slug; no "the" prefix |
| `wiki/entities/` | `entity` | Named real-world things: people, tools, products, orgs, repos | Proper noun as named in the source |
| `wiki/sources/` | `source` | One page per ingested source — metadata, key findings, links to derived pages | `<slug>` matching the `.raw/` filename |
| `wiki/solutions/` | `solution` | Concrete recipes: how to accomplish a specific task end-to-end | Verb phrase, e.g. `configure-mcp-server` |
| `wiki/comparisons/` | `comparison` | Side-by-side analysis of 2+ alternatives | `<A>-vs-<B>` or `comparing-<topic>` |
| `wiki/questions/` | `question` | Open questions; closed questions link to the answer | Question as written, e.g. `why-tokens-compound` |
| `wiki/meta/` | `meta` | Index files, log, hot cache, overview — structural pages | Short functional names: `index`, `log`, `hot` |

**Examples:**
- `wiki/concepts/LLM Wiki Pattern.md` — a technique (concept)
- `wiki/entities/Andrej Karpathy.md` — a person (entity)
- `wiki/sources/llm-wiki-karpathy-gist.md` — the ingest record for a specific source
- `wiki/solutions/configure-mcp-server.md` — step-by-step recipe (solution)

### Required Frontmatter Fields

All pages must have these fields:

```yaml
---
type: <type>          # concept | entity | source | solution | comparison | question | meta
title: "Human Title"
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags:
  - <type>            # always include the type as a tag
status: <status>      # see Quality Standards below
related:
  - "[[PageName]]"    # minimum 2 cross-references; 0 = orphan
---
```

Concepts and solutions also include:
```yaml
domain: <domain>      # e.g. knowledge-management, testing, llm, tooling
complexity: beginner | intermediate | advanced
```

Source pages also include:
```yaml
sources:
  - "[[source-slug]]"
```

---

## Ingest Rules

Follow these steps for every new source ingested into the vault.

### Step 1 — Read the source
Read the full source file from `.raw/`. Do not modify it.

### Step 2 — Identify what to create or update
For each source, produce:
1. **One source page** in `wiki/sources/<slug>.md` — always new unless re-ingesting the same source.
2. **One or more concept pages** in `wiki/concepts/` — create new pages for novel concepts; update existing pages if the source adds material detail, a new perspective, or a contradiction.
3. **One or more entity pages** in `wiki/entities/` — create new pages for named people, tools, orgs, or repos that appear substantively in the source. Skip passing mentions.
4. **Zero or more solution pages** in `wiki/solutions/` — only if the source contains a concrete, reusable recipe.

### Step 3 — Write cross-references
Every new or updated page must link to at least 2 related pages via `[[WikiLinks]]`. The source page must link to all derived concept and entity pages. Derived pages must link back to their source page.

### Step 4 — Check for contradictions
Before saving a concept or entity page, compare its claims against any existing page on the same topic. If a contradiction exists, follow the **Contradiction Handling** section below.

### Step 5 — Update index files
After all pages are written:
- Add or update entries in `wiki/index.md` under the appropriate section.
- Add a log entry to `wiki/log.md` following the **Log Format** section below.
- Update `wiki/hot.md` with a one-paragraph summary of the ingest (replace the previous entry for this source if re-ingesting).

### Minimum cross-reference count
- Source pages: link to ≥ 3 derived pages (concept/entity/solution).
- Concept pages: link to ≥ 2 other pages (sources, related concepts, or entities).
- Entity pages: link to ≥ 1 source and ≥ 1 related concept or entity.

---

## Contradiction Handling

When a new source makes a claim that contradicts an existing wiki page:

### Detect
A contradiction exists when:
- A factual claim in the new source directly conflicts with a claim on an existing page (e.g., different numbers, opposite conclusions, a finding the prior source did not have).
- The new source supersedes the prior source (newer version, updated research, corrected data).

Do NOT flag as contradictions: different levels of detail, complementary perspectives, or new information that adds to rather than conflicts with an existing claim.

### Resolve

| Situation | Action |
|-----------|--------|
| New source is newer/authoritative and the old claim is simply wrong | Update the existing page. Add an inline note: `> **Updated [YYYY-MM-DD]:** <new claim>. Prior claim: <old claim>. Source: [[new-source]].` |
| Both claims are defensible but come from different contexts | Add a `## Perspectives` subsection to the concept page listing both claims with their sources. Do not delete either. |
| New source supersedes old source entirely | Mark the old source page with `status: superseded` and add `superseded_by: "[[new-source]]"` to its frontmatter. Update concept pages to use the new source. |
| Contradiction requires more research to resolve | Add an `open_questions` frontmatter field listing the unresolved question. Create a page in `wiki/questions/` if the question is significant. |

### Log contradictions
Include a `Contradictions resolved:` line in the log entry for the ingest session.

---

## Quality Standards

Pages carry a `status` field that reflects how complete and trustworthy the content is. Use the criteria below to set status at creation and to promote/demote on subsequent ingests.

| Status | Criteria | Typical pages |
|--------|----------|---------------|
| `stub` | Placeholder only — title, frontmatter, 1–2 sentence description. No body sections yet. | New entity pages with only a name and source reference |
| `developing` | Has a body with 1–2 sections. Key claims present but not fully sourced or cross-referenced. Missing sections are known and noted. | Early concept pages after first ingest |
| `current` | Complete enough to be useful. All major sections present, cross-references ≥ minimum count, all claims sourced. May be updated as new sources arrive. | Most concept and source pages after a solid ingest |
| `mature` | Stable, well-sourced, multiple sources synthesized. Unlikely to change substantially. Contradictions resolved. Cross-references complete. | Core concept pages like [[LLM Wiki Pattern]] |
| `evergreen` | Structural pages that are always up to date by definition. Updated mechanically after every relevant change. | `index.md`, `log.md`, `hot.md` |
| `superseded` | Replaced by a newer source or page. Content preserved but no longer canonical. | Old source pages after a re-ingest |

### Promotion rules
- `stub` → `developing`: body added with at least one substantive section
- `developing` → `current`: all major sections present, minimum cross-references met
- `current` → `mature`: second independent source confirms or significantly extends the claims
- Any status → `superseded`: a newer source explicitly replaces this one

### Demotion
Demote from `mature` or `current` to `developing` only if a contradiction is found that removes a major section's basis. Do not demote for minor updates.

---

## Log Format

Every ingest, autoresearch, save, or significant update session writes one log entry to `wiki/log.md`.

### Format

```markdown
## [YYYY-MM-DD] <operation> | <description>
- <key metric>: <value> | <key metric>: <value>
- Trigger: <what initiated this session>
- Pages created: [[page1]], [[page2]]
- Pages updated: [[page3]], [[page4]]
- Contradictions resolved: <description or "none">
- Key findings: (1) <finding>; (2) <finding>; (3) <finding>
```

### Field definitions

| Field | Required | Notes |
|-------|----------|-------|
| Date | Yes | ISO 8601: `YYYY-MM-DD` |
| Operation | Yes | `ingest` / `autoresearch` / `compound` / `save` / `query` / `lint` |
| Description | Yes | Short phrase identifying the source or topic |
| Key metrics | Conditional | For autoresearch: `Rounds: N \| Searches: N \| Fetches: N`. For ingest: `Pages created: N`. Omit for save/compound. |
| Trigger | Yes | What command or user action started the session |
| Pages created | Yes | All new pages; use `[[WikiLinks]]`; write "none" if zero |
| Pages updated | Yes | All modified existing pages; use `[[WikiLinks]]`; write "none" if zero |
| Contradictions resolved | Yes | Brief description of any resolved contradiction, or "none" |
| Key findings | Yes | 1–5 numbered findings; each one sentence; most important first |

### Example

```markdown
## [2026-04-20] ingest | Karpathy LLM Wiki gist
- Pages created: 1
- Trigger: user ran `ingest llm-wiki-karpathy-gist.md`
- Pages created: [[llm-wiki-karpathy-gist]], [[LLM Wiki Pattern]], [[Andrej Karpathy]]
- Pages updated: [[index]], [[hot]], [[log]]
- Contradictions resolved: none
- Key findings: (1) wiki pattern originated in 2024 gist with 4,700+ forks; (2) core thesis: schema is the product, not content; (3) hot cache reduces per-session token cost by ~84%
```

Entries are prepended (newest first). Do not edit prior entries except to fix factual errors; if a finding is superseded, add a note inline: `[superseded by [[new-source]]]`.
