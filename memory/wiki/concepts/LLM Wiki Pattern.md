---
type: concept
title: "LLM Wiki Pattern"
complexity: intermediate
domain: knowledge-management
aliases:
  - "LLM Knowledge Base"
  - "Karpathy Wiki"
  - "Persistent Wiki"
created: 2026-04-07
updated: 2026-04-20
tags:
  - concept
  - knowledge-management
  - llm
  - obsidian
status: mature
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[Hot Cache]]"
  - "[[Compounding Knowledge]]"
  - "[[Andrej Karpathy]]"
  - "[[Memex]]"
  - "[[Vannevar Bush]]"
  - "[[qmd]]"
  - "[[index]]"
  - "[[concepts/_index]]"
sources:
  - "[[llm-wiki-karpathy-gist]]"
  - "[[llm-wiki-research-2026-04-20]]"
---

# LLM Wiki Pattern

A pattern for building persistent, compounding knowledge bases using LLMs. Originated by [[Andrej Karpathy]]. The key insight: instead of re-deriving knowledge from raw documents on every query (RAG), the LLM incrementally builds and maintains a structured wiki that gets richer with every source added.

---

## The Core Idea

Most AI knowledge tools work like RAG: index raw documents, retrieve chunks at query time, generate an answer. Nothing accumulates. Ask a question that needs five documents and the LLM reassembles fragments every time.

The wiki pattern is different. When a new source arrives, the LLM reads it, extracts what matters, and integrates it into the wiki: updating entity pages, noting contradictions, strengthening the synthesis. The cross-references are already there. The knowledge is compiled once and kept current.

**The wiki is a persistent, compounding artifact.** The human curates sources and asks questions. The LLM writes and maintains everything.

---

## Three Layers

```
.raw/       Layer 1 — immutable source documents
wiki/       Layer 2 — LLM-generated knowledge base
CLAUDE.md   Layer 3 — schema that tells the LLM how to maintain it
```

The LLM owns Layer 2 entirely. It creates pages, updates them when new sources arrive, maintains cross-references, and keeps everything consistent. The human reads; the LLM writes.

---

## Operations

**Ingest** — drop a source into `.raw/`, tell the LLM to process it. The LLM reads the source, discusses key takeaways, writes a summary page, updates entity and concept pages, and logs the operation. One source typically touches 8-15 wiki pages.

**Query** — ask a question. The LLM reads the index to find relevant pages, synthesizes an answer with citations. Good answers get filed back into the wiki.

**Lint** — periodic health check. Find orphan pages, dead links, stale claims, missing cross-references.

---

## Index and Log

**index.md** — content-oriented. A catalog of all pages with one-line summaries, organized by category. The LLM reads this first on every query to find relevant pages.

**log.md** — chronological. Append-only record of every ingest, query, and lint pass. Parseable: `grep "^## \[" log.md | head -10`

---

## Why It Works

The tedious part of maintaining a knowledge base is bookkeeping: updating cross-references, noting when new data contradicts old claims, keeping summaries current. Humans abandon wikis because the maintenance burden grows faster than the value. LLMs don't get bored. The wiki stays maintained because the cost of maintenance is near zero.

At small scale (~100 sources, ~hundreds of pages), the index file is sufficient. No vector database, no embeddings, no infrastructure. Just markdown files.

---

## Comparison to RAG

| Dimension | LLM Wiki | Semantic RAG |
|-----------|----------|-------------|
| Finding | Reads index, follows links | Similarity search over embeddings |
| Infrastructure | Just markdown files | Embedding model + vector DB |
| Cost | Tokens only | Ongoing compute + storage |
| Maintenance | Run a lint | Re-embed when content changes |
| Scale limit | Hundreds of pages | Millions of documents |

---

## Scale Limits

The flat `index.md` approach works well to ~200 pages. Past ~1,000 files the index becomes too large and the pattern requires hybrid search. Production responses:

- **[[qmd]]** — local BM25/vector search for markdown. Karpathy's recommended upgrade path.
- **[[llm-wiki-v2-extensions]]** — full production architecture: confidence scoring, typed graph, hybrid search (BM25 + vector + graph traversal), event-driven automation.

See [[llm-wiki-scalability-critique]] for the full failure-mode analysis.

---

## Academic Validation

arXiv:2604.11243 (April 2026) provides empirical economics evidence: **84.6% token savings** (47K vs 305K tokens for a four-query test) vs. RAG baseline. The paper reframes LLM tokens as capital goods rather than consumables. See [[knowledge-compounding-economics]].

---

## Ecosystem (April 2026)

The gist accumulated 5,000+ stars, 4,713 forks, 485+ comments within weeks of publication. Notable implementations and extensions:

- **[[llm-wiki-v2-extensions]]** (rohitg00) — production memory lifecycle, typed graph, hybrid search
- **[[Graphify]]** — confidence-tagged property graph (EXTRACTED/INFERRED/AMBIGUOUS)
- **graphiti** (getzep) — real-time knowledge graph library for AI agents
- **awesome-llm-wiki** (tjiahen) — curated list of tools and implementations

---

## Tools and Extensions

The gist calls out a few tools that fit cleanly into the pattern:

- **[[qmd]]** — local hybrid BM25/vector search for markdown files. The recommended upgrade path when `index.md` alone is no longer enough to locate pages. Available as both CLI and MCP server.
- **Marp** — markdown-based slide decks. A handy output format for query answers that deserve a presentation shape.
- **Dataview** — Obsidian plugin that queries page frontmatter. If the LLM adds typed YAML to every page (this vault does), Dataview generates dynamic tables and indexes for free.
- **Obsidian Web Clipper** — converts web articles to markdown, streamlining the raw-ingest pipeline.
- **Obsidian graph view** — visual health check: hubs, orphans, and clusters at a glance. Complements vault-lint capabilities.

None of these are required. The pattern runs on plain markdown files and `grep`.

---

## Historical Lineage

The pattern is framed — in the [[llm-wiki-karpathy-gist|original gist]] — as a modern realization of [[Vannevar Bush]]'s [[Memex]] (1945). Bush had the intuition that *associations between documents* matter as much as the documents themselves, but human-maintained knowledge stores always rot because bookkeeping burden grows faster than value. LLMs collapse the bookkeeping cost, which is what makes the Memex finally buildable.

---

## Connections

See [[Compounding Knowledge]] for why the pattern produces more value over time.
See [[Hot Cache]] for the session context optimization.
See [[Andrej Karpathy]] for the pattern's origin.
See [[Memex]] and [[Vannevar Bush]] for the intellectual lineage.
See [[llm-wiki-karpathy-gist]] for the canonical source.
