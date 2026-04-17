---
type: source
title: "LLM Wiki — Karpathy Gist"
created: 2026-04-17
updated: 2026-04-17
tags:
  - source
  - gist
  - pattern
  - knowledge-management
  - karpathy
status: current
related:
  - "[[LLM Wiki Pattern]]"
  - "[[Andrej Karpathy]]"
  - "[[Compounding Knowledge]]"
  - "[[Memex]]"
  - "[[Vannevar Bush]]"
  - "[[Hot Cache]]"
  - "[[Wiki vs RAG]]"
  - "[[qmd]]"
raw_file: ".raw/articles/llm-wiki-karpathy-2026-04-04.md"
source_url: "https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f"
---

# Source: LLM Wiki — Karpathy Gist

**Type**: GitHub Gist (idea file)
**Author**: [[Andrej Karpathy]]
**Published**: 2026-04-04
**Ingested**: 2026-04-17
**Engagement**: 5,000+ stars, 4,360 forks, 60+ comments

## Summary

Karpathy's original public articulation of the [[LLM Wiki Pattern]] — an "idea file" describing how LLMs should incrementally build and maintain a structured, interlinked markdown wiki that *sits between the user and the raw sources*. Explicitly positioned as an alternative to RAG: instead of re-deriving knowledge from chunks on every query, the LLM compiles knowledge once and keeps it current.

The gist itself is the canonical seed for every wiki in this pattern. The `claude-obsidian` plugin is one implementation; the gist discusses general architecture (raw / wiki / schema), core operations (ingest / query / lint), and navigation primitives (`index.md`, `log.md`).

## Pages Touched by This Ingest

- [[LLM Wiki Pattern]] — concept page (updated: added `sources:` link, Tools & extensions section with Marp/Dataview/Web Clipper/qmd)
- [[Andrej Karpathy]] — entity page (updated: linked gist as primary source)
- [[Vannevar Bush]] — entity page (new — gist cites Memex lineage)
- [[Memex]] — concept page (new — historical predecessor)
- [[qmd]] — entity page (new — gist-recommended search tool)
- [[index]], [[hot]], [[log]], [[overview]] — index refresh

## Key Ideas

1. **Three layers, one owner.** Raw sources (immutable), the wiki (LLM-owned), the schema (`CLAUDE.md` or equivalent telling the LLM how to maintain it).
2. **Three operations.** `Ingest` (drop source → LLM updates 8–15 pages), `Query` (LLM reads index, synthesizes, optionally files answer back), `Lint` (periodic health check for orphans, stale claims, missing cross-refs).
3. **Navigation via `index.md` + `log.md`.** Content-oriented index, chronological append-only log. Parseable with `grep "^## \[" log.md | head -10`.
4. **"Maintenance cost near zero."** The value of the pattern comes from LLMs not getting bored of bookkeeping — updating 15 files per ingest is trivial for an LLM, fatal for a human.
5. **Obsidian is the IDE.** Graph view exposes orphans and hubs. Git is the version control. No vector DB, no embeddings required at small scale.
6. **Historical lineage.** Explicitly framed as a [[Memex]] descendant ([[Vannevar Bush]], 1945) — associative trails between documents, but with the maintenance problem finally solved by LLMs.

## Notable Quotes

> "The wiki is a persistent, compounding artifact. Cross-references are already there. Contradictions have been flagged. Synthesis reflects everything read."

> "The wiki stays maintained because the cost of maintenance is near zero."

> "Obsidian becomes the IDE; the LLM becomes the programmer; the wiki becomes the codebase."

## Tooling Mentioned

- **[[qmd]]** — local hybrid BM25/vector search for markdown files; CLI + MCP server
- **Marp** — markdown-based slide decks (useful for query-output artifacts)
- **Dataview** — Obsidian plugin for frontmatter queries
- **Obsidian Web Clipper** — web-article → markdown for fast raw collection
- **Obsidian graph view** — visual check for orphans and hubs

## Reception (from discussion thread)

The gist drew a mix of enthusiastic implementations and substantive critique:

- **Implementations** ranged from 200-line scripts to 5,400+ memory systems (obsidian-skills, ai-memex-cli, SwarmVault, ΩmegaWiki).
- **Critiques** questioned whether markdown-without-collaboration qualifies as a "wiki", flagged hallucination risk in self-referential summaries, and argued the contradiction-detection claim is empirically unvalidated.
- **Extensions** explored multi-agent governance and lifecycle management when the curator departs.

## Relation to Existing Wiki

This source is the upstream origin of the pattern this vault embodies. No contradictions with existing pages — the gist is *less* prescriptive about directory structure than this vault's `memory/WIKI.md`, which is expected: the gist says "everything mentioned is optional and modular."

One clarification the gist makes that wasn't explicit here: the LLM should **discuss takeaways with the user** during ingest ("What should I emphasize? How granular?") unless the user says "just ingest it." That matches the [[wiki-ingest]] skill's single-source flow step 2.

## Raw File

`.raw/articles/llm-wiki-karpathy-2026-04-04.md`
