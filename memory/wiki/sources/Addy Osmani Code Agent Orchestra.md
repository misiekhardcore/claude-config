---
name: Addy Osmani Code Agent Orchestra
description: Addy Osmani's blog post on what makes multi-agent coding work — hierarchical decomposition, Princeton NLP single-agent study, domain ownership
type: source
source_type: blog-post
author: Addy Osmani
date_published: 2026
url: https://addyosmani.com/blog/code-agent-orchestra/
source_reliability: medium
key_claims:
  - Princeton NLP found single agent matched/beat multi-agent on 64% of tasks
  - Multi-agent adds ~2.1pp accuracy at ~2x cost
  - Hierarchical decomposition via feature leads keeps parent context clean
  - Domain ownership prevents merge conflicts between agents
tags: [orchestration, multi-agent, cost-benefit]
status: developing
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[hierarchical-agent-decomposition]]"
evidence: []
---

# Addy Osmani — The Code Agent Orchestra

Blog post by Google Chrome engineering lead Addy Osmani on multi-agent coding patterns. Confidence: medium (secondary source citing Princeton NLP).

## Key Claims

1. **Single-agent bias**: Princeton NLP benchmarks — "a single agent matched or outperformed multi-agent systems on 64% of benchmarked tasks when given the same tools and context."
2. **Multi-agent cost**: "Multi-agent adds 2.1 percentage points of accuracy at roughly double the cost."
3. **Hierarchical decomposition**: orchestrator spawns 2 feature leads; each lead spawns 2-3 specialists. Parent talks to only two agents.
4. **Feature lead brief shape**: "Build the search feature" → lead decomposes into Data, Logic, API subagents autonomously.
5. **Domain ownership prevents conflicts**: frontend owns `src/components/`, backend owns `src/api/`, QA owns `src/__tests__/`.

## Confidence Notes

> [!gap] The Princeton NLP citation is not directly linked in the post; would need to trace the original paper to verify the 64% / 2.1pp figures.

The domain-ownership and hierarchical decomposition claims are presented as patterns observed in practice, not as empirical results.

## Relevance to claude-workflow

- Supports the CLAUDE.md rule "Default to single-agent. Use TeamCreate only for parallelizable work across 3+ independent files or sub-issues."
- Informs the nested team shape in `/discovery` (two-level hierarchy via TeamCreate).

## Related

- [[multiskill-workflow-patterns]] — single-agent bias section cites this
- [[hierarchical-agent-decomposition]] — concept built on this source's feature-lead model
