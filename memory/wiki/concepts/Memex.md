---
type: concept
title: "Memex"
complexity: basic
domain: knowledge-management
aliases:
  - "memory extender"
created: 2026-04-17
updated: 2026-04-20
tags:
  - concept
  - knowledge-management
  - historical
  - precursor
status: developing
confidence: INFERRED
evidence:
  - "[[llm-wiki-karpathy-gist]]"
related:
  - "[[Vannevar Bush]]"
  - "[[LLM Wiki Pattern]]"
  - "[[Compounding Knowledge]]"
  - "[[concepts/_index]]"
sources:
  - "[[llm-wiki-karpathy-gist]]"
---

# Memex

A conceptual personal knowledge device proposed by [[Vannevar Bush]] in the 1945 essay *As We May Think*. The name contracts "memory extender." Bush imagined a desk-sized machine on which an individual could store books, records, and communications, consult them with speed and flexibility, and — crucially — build **associative trails** between documents that the user (or later readers) could retrace.

## Why it matters here

The Memex is the explicit intellectual ancestor of the [[LLM Wiki Pattern]]. Both share three commitments:

1. **Private and individual.** Curated by one person, for their own thinking. Not a public encyclopedia, not a shared knowledge graph.
2. **Associations are first-class.** The trails between documents are as valuable as the documents. In Memex: mechanical links. In an LLM wiki: wikilinks, concept pages, and cross-references.
3. **Actively maintained.** The system is useful only because someone keeps it curated. Bush assumed a disciplined human. The LLM wiki assumes a patient agent.

## The part Bush couldn't solve

Human-maintained wikis rot. Bookkeeping is tedious: every new source requires touching multiple pages, updating cross-references, and revisiting stale claims. Maintenance burden grows faster than value, so humans abandon the system.

Karpathy's framing of the LLM wiki as a Memex revival rests entirely on this point: LLMs don't get bored of bookkeeping, so the maintenance problem that killed Memex-style systems is finally tractable.

## What differs

- **Trails vs. graph.** Bush imagined linear trails through documents; modern wikis use a graph of typed pages.
- **Mechanical vs. linguistic.** Memex was physical microfilm with levers. LLM wikis are markdown files and natural-language prompts.
- **Static vs. regenerating.** Memex trails were recorded once; LLM wikis are rewritten continuously as new sources arrive.

## Connections

- [[Vannevar Bush]] — the author
- [[LLM Wiki Pattern]] — the modern realization
- [[Compounding Knowledge]] — why the pattern gets richer over time, something the Memex could only promise
