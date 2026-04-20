---
type: entity
title: "Graphify"
entity_type: tool
role: "LLM Wiki implementation with typed knowledge graph"
created: 2026-04-20
updated: 2026-04-20
tags:
  - entity
  - tool
  - knowledge-graph
  - llm-wiki
status: current
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[LLM Wiki Pattern]]"
  - "[[llm-wiki-v2-extensions]]"
  - "[[entities/_index]]"
sources:
  - "[[llm-wiki-research-2026-04-20]]"
---

# Graphify

A direct implementation of [[LLM Wiki Pattern]] that adds a typed property-graph layer to the standard markdown wiki. Surfaced in April 2026 community coverage of the Karpathy pattern. Covered by Analytics Vidhya and Medium (Mehul Gupta).

---

## Key Differentiator: Confidence Tagging

Every relationship in the graph is tagged with one of three confidence levels:

| Tag | Meaning | Confidence |
|-----|---------|------------|
| `EXTRACTED` | Found directly in source code/documents | 1.0 (deterministic) |
| `INFERRED` | Reasonable inference from docs/transcripts | Variable (0.0-1.0) |
| `AMBIGUOUS` | Conflicting signals; needs human review | Triggers HITL queue |

`AMBIGUOUS` edges are flagged for human review, making it the only confidence tier that triggers a human-in-the-loop workflow. This allows teams to operate on the extracted/inferred graph while explicitly managing uncertainty.

---

## Architecture

Builds on standard LLM Wiki three-layer structure, extending Layer 2 (the wiki) with:
- Typed entity extraction (people, projects, libraries, files, decisions)
- Typed relationship edges with confidence scores
- Graph traversal queries alongside keyword search

Aligns with [[llm-wiki-v2-extensions]] pattern (confidence decay, typed relationships), implemented as a standalone tool rather than a schema convention.

---

## Status

Tool details sparse as of 2026-04-20. Not to be confused with **graphiti** (getzep/graphiti), a separate real-time knowledge graph library for AI agents.

> [!gap] No GitHub repo or official documentation found yet. Coverage from secondary sources only.

---

## Connections

- [[LLM Wiki Pattern]] — the pattern it implements
- [[llm-wiki-v2-extensions]] — shares confidence scoring and typed graph concepts
- [[llm-wiki-scalability-critique]] — addresses the hallucination compounding critique via explicit AMBIGUOUS tagging
