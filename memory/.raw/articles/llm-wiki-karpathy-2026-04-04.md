---
source_url: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
source_type: gist
author: Andrej Karpathy
fetched: 2026-04-17
original_date: 2026-04-04
engagement: "5,000+ stars, 4,360 forks"
---

# LLM Wiki

A pattern for building personal knowledge bases using LLMs.

This is an idea file, designed to be copied to your own LLM Agent (e.g. OpenAI Codex, Claude Code, OpenCode / Pi). Its goal communicates the high-level idea, with agents building specifics collaboratively.

## The core idea

Most people's experience with LLMs and documents follows RAG: upload files, the LLM retrieves relevant chunks at query time, and generates an answer. This works, but the LLM rediscovers knowledge from scratch on every question. There's no accumulation.

Instead of just retrieving from raw documents at query time, the LLM should "incrementally build and maintain a persistent wiki — a structured, interlinked collection of markdown files that sits between you and the raw sources." When adding a new source, the LLM doesn't just index it for later retrieval. It reads it, extracts key information, integrates it into the existing wiki — updating entity pages, revising topic summaries, noting contradictions, strengthening synthesis. Knowledge gets compiled once and kept current, not re-derived every query.

**Key difference**: "The wiki is a persistent, compounding artifact." Cross-references are already there. Contradictions have been flagged. Synthesis reflects everything read. The wiki gets richer with each source and question.

You source and explore; the LLM maintains the wiki. The agent does "the summarizing, cross-referencing, filing, and bookkeeping that makes a knowledge base actually useful over time." Obsidian becomes the IDE; the LLM becomes the programmer; the wiki becomes the codebase.

## Application contexts

- Personal: tracking goals, health, psychology through journal entries and articles
- Research: building comprehensive wikis over weeks or months
- Reading: filing chapters, building pages for characters, themes, plot threads
- Business/team: internal wikis fed by Slack, meeting transcripts, documents
- Competitive analysis, due diligence, trip planning, hobby deep-dives

## Architecture

Three layers exist:

**Raw sources** — curated collection of source documents (articles, papers, images, data). Immutable; the LLM reads but never modifies.

**The wiki** — directory of LLM-generated markdown files. Summaries, entity pages, concept pages, comparisons, overview, synthesis. The LLM owns this layer entirely.

**The schema** — document (e.g., CLAUDE.md for Claude Code) telling the LLM how the wiki is structured, conventions, and workflows for ingesting sources, answering questions, maintaining wiki. This configuration makes the LLM a disciplined maintainer rather than generic chatbot.

## Operations

**Ingest**: Drop new source into raw collection; tell LLM to process it. The LLM reads the source, discusses takeaways, writes a summary page, updates the index, refreshes relevant entity and concept pages, appends an entry to the log.

**Query**: Ask questions against the wiki. The LLM searches for relevant pages, reads them, synthesizes an answer with citations. Answers can take different forms — markdown page, comparison table, slide deck (Marp), chart (matplotlib). Good answers can be filed back into the wiki as new pages.

**Lint**: Periodically, ask the LLM to health-check the wiki. Look for: contradictions between pages, stale claims superseded by newer sources, orphan pages with no inbound links, important concepts lacking their own page, missing cross-references, data gaps fillable with web search.

## Indexing and logging

Two special files help navigation:

**index.md** is content-oriented. Catalog of everything in the wiki — each page listed with link, one-line summary, optionally metadata like date or source count. Organized by category. The LLM updates it on every ingest. When answering queries, the LLM reads the index first to find relevant pages.

**log.md** is chronological. Append-only record of what happened and when — ingests, queries, lint passes. If each entry starts with consistent prefix (e.g., `## [2026-04-02] ingest | Article Title`), the log becomes parseable with simple unix tools.

## Optional: CLI tools

A search engine over wiki pages is obvious — at small scale the index file suffices, but as the wiki grows, proper search helps. qmd is a good option: local search engine for markdown files with hybrid BM25/vector search and LLM re-ranking, all on-device. It has both CLI (so the LLM can shell out) and MCP server (so the LLM can use as native tool).

## Tips and tricks

- Obsidian Web Clipper converts web articles to markdown — useful for quickly getting sources into raw collection
- Download images locally via Obsidian Settings → Files and links, set "Attachment folder path" to fixed directory (e.g., `raw/assets/`). This lets the LLM view and reference images directly
- Obsidian's graph view shows the shape of your wiki — what's connected to what, which pages are hubs, which are orphans
- Marp is markdown-based slide deck format. Obsidian has a plugin for it. Useful for generating presentations from wiki content
- Dataview is an Obsidian plugin that runs queries over page frontmatter. If your LLM adds YAML frontmatter to wiki pages, Dataview can generate dynamic tables and lists
- The wiki is just a git repo of markdown files. You get version history, branching, and collaboration for free

## Why this works

The tedious part of maintaining a knowledge base isn't reading or thinking — it's bookkeeping. Updating cross-references, keeping summaries current, noting when new data contradicts old claims, maintaining consistency across dozens of pages. Humans abandon wikis because maintenance burden grows faster than value. LLMs don't get bored, don't forget cross-references, and can touch 15 files in one pass. "The wiki stays maintained because the cost of maintenance is near zero."

The human curates sources, directs analysis, asks good questions, and thinks about meaning. The LLM handles everything else.

The idea relates in spirit to Vannevar Bush's Memex (1945) — a personal, curated knowledge store with associative trails between documents. Bush's vision was closer to this than what the web became: private, actively curated, with connections between documents as valuable as documents themselves. The part he couldn't solve was maintenance. "The LLM handles that."

## Note

This document is intentionally abstract. It describes the idea, not a specific implementation. Directory structure, schema conventions, page formats, tooling — all depend on domain, preferences, and LLM choice. Everything mentioned is optional and modular. Your LLM can figure out the rest based on the pattern communicated here.

---

## Discussion Thread Summary

The gist generated extensive commentary (60+ comments) with significant debate:

**Critical perspectives** challenged whether markdown-based systems qualify as "wikis" without collaborative editing features, questioned LLM reliability at scale, and noted that maintaining consistency without human supervision remains an open problem.

**Implementation reports** documented working systems ranging from 200-line codebases to 5,400+ memories, with tools like obsidian-skills, ai-memex-cli, SwarmVault, and ΩmegaWiki adding automation layers.

**Theoretical extensions** explored substrate asymmetries between human and agent participants, lifecycle management when knowledge creators depart, and governance models for multi-agent coordination.

**Skepticism** included concerns about hallucination compounding through self-referential summaries, the contradiction-detection claim lacking empirical validation, and whether the pattern offers advantages over existing graph databases and knowledge management systems.
