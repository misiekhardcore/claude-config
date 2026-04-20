---
type: concept
title: "LLM Wiki v2 Extensions"
complexity: advanced
domain: knowledge-management
created: 2026-04-20
updated: 2026-04-20
tags:
  - concept
  - knowledge-management
  - llm
  - memory
  - knowledge-graph
status: current
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[LLM Wiki Pattern]]"
  - "[[Compounding Knowledge]]"
  - "[[knowledge-compounding-economics]]"
  - "[[llm-wiki-scalability-critique]]"
sources:
  - "[[llm-wiki-research-2026-04-20]]"
---

# LLM Wiki v2 Extensions

Production-grade extensions to [[LLM Wiki Pattern]], documented by rohitg00 based on lessons from building **agentmemory**. Where v1 treats all wiki content as equally valid flat markdown, v2 adds lifecycle management, typed graph structure, and event-driven automation.

Source: [LLM Wiki v2 gist](https://gist.github.com/rohitg00/2067ab416f7bbe447c1977edaaa681e2)

---

## Memory Lifecycle Management

### Confidence Decay and Supersession

Facts carry metadata about supporting sources, recency, and contradiction status. Confidence **decays with time** and **strengthens with reinforcement**. New information explicitly supersedes old claims: linked, timestamped, with stale versions preserved but marked.

### Forgetting Curves (Ebbinghaus)

Retention follows Ebbinghaus-style decay curves calibrated to knowledge type:
- Transient (bug reports, status updates): decay fast
- Procedural (workflows, patterns): decay slowly
- Semantic (cross-session facts): decay at medium rate

### Consolidation Tiers

Information moves through four stages:

| Tier | Contents |
|------|----------|
| Working memory | Recent observations (current session) |
| Episodic memory | Session summaries |
| Semantic memory | Cross-session facts |
| Procedural memory | Workflows and patterns |

---

## Typed Knowledge Graph

### Entity Extraction

On ingest, the LLM identifies typed entities: people, projects, libraries, files, decisions. Each entity gets attributes and relationships to other entities, not just prose descriptions.

### Typed Relationships

Connections carry semantics rather than generic links:

- `uses`, `depends-on` — dependency relationships
- `contradicts` — explicit conflict tracking
- `caused`, `fixed` — causal chains
- `supersedes` — versioning

A link that reads "A caused B, confidence 0.9, confirmed by 3 sources" is qualitatively different from "A relates to B."

### Graph Traversal Queries

Queries walk relationships rather than keyword-matching, surfacing downstream impacts automatically.

---

## Hybrid Search Strategy

Replaces single `index.md` (effective to ~200 pages) with three parallel streams fused via Reciprocal Rank Fusion:

1. **BM25** — keyword matching with stemming
2. **Vector search** — semantic embeddings
3. **Graph traversal** — relationship-aware discovery

Each stream catches what the others miss.

---

## Event-Driven Automation

Hooks replace manual operations:

| Event | Action |
|-------|--------|
| Source ingest | Auto-extract, update graph, refresh index |
| Session end | Compress into observations, file insights ("crystallization") |
| Memory write | Detect contradictions, trigger supersession |
| Schedule | Lint, consolidate, decay stale facts |

---

## Schema as Product

The schema document (`CLAUDE.md` or equivalent) encodes entity types, relationships, ingest rules, quality standards, contradiction handling, and consolidation schedules. In v2, **the schema is the real product** — not the content, but the rules that keep content healthy.

---

## Multi-Agent Patterns

For parallel agent use:
- Mesh sync for parallel agent observations
- Shared vs. private knowledge scoping
- Lightweight work coordination to prevent duplication

---

## Progressive Adoption

V2 is modular. Entry points in order of complexity:

1. Minimal viable wiki (v1 baseline)
2. Add lifecycle (confidence scoring, supersession)
3. Add structure (typed entities + relationships)
4. Add automation (event hooks)
5. Add scale (hybrid search)
6. Add collaboration (multi-agent mesh)

---

## Connections

- [[LLM Wiki Pattern]] — the v1 baseline this extends
- [[llm-wiki-scalability-critique]] — the failure modes v2 addresses
- [[knowledge-compounding-economics]] — empirical ROI evidence for the approach
- [[Graphify]] — a direct implementation using EXTRACTED/INFERRED/AMBIGUOUS confidence tagging
