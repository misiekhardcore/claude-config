---
type: entity
title: "qmd"
entity_type: tool
role: "Local search engine for markdown files"
first_mentioned: "[[llm-wiki-karpathy-gist]]"
created: 2026-04-17
updated: 2026-04-17
tags:
  - entity
  - tool
  - search
  - cli
  - mcp
status: developing
related:
  - "[[LLM Wiki Pattern]]"
  - "[[entities/_index]]"
sources:
  - "[[llm-wiki-karpathy-gist]]"
---

# qmd

A local search engine for markdown files, recommended by [[Andrej Karpathy]] in the [[llm-wiki-karpathy-gist|LLM Wiki — Karpathy Gist]] as the next step once an LLM wiki grows past the point where `index.md` alone is sufficient.

## What it does

- **Hybrid search** — combines BM25 (keyword relevance) with vector similarity, plus LLM-based re-ranking for final ordering.
- **On-device** — no cloud, no embeddings sent externally.
- **Two surfaces** — a CLI so the LLM can shell out, and an MCP server so the LLM can use it as a native tool.

## When to reach for it

Per the gist: at small scale (~hundreds of pages), `index.md` is enough — the LLM reads the index, then the pages it lists. Once the wiki grows past that point, keyword/semantic search across pages becomes the bottleneck. qmd is Karpathy's specific recommendation for that jump.

The `claude-obsidian` vault has not wired qmd in; the current retrieval path is `hot.md` → `index.md` → drill into typed pages. If this vault grows into the thousands of pages, qmd (or an equivalent) becomes the natural upgrade.

## Connections

- [[LLM Wiki Pattern]] — qmd is the scaling tool for the pattern
- [[Hot Cache]] — complementary: hot.md handles recency, qmd handles broad semantic retrieval
