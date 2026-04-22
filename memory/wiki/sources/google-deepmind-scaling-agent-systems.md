---
type: source
title: "Towards a Science of Scaling Agent Systems"
source_type: paper
author: Google DeepMind Research
date_published: 2025-12
url: https://arxiv.org/html/2512.08296v1
source_reliability: high
accessed: 2026-04-22
tags:
  - multi-agent
  - scaling
  - empirical
  - research
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "180 agent configurations evaluated; a predictive model identifies the optimal architecture for 87% of unseen tasks"
  - "For sequential reasoning tasks, every multi-agent variant tested degraded performance by up to 70%"
  - "Multi-agent coordination dramatically improves performance on parallelizable tasks but degrades it on sequential ones"
  - "Anthropic models reveal higher variance and occasional MAS underperformance, reflecting sensitivity to coordination overhead"
related:
  - "[[agent-scaling-empirical-evidence]]"
  - "[[subagent-vs-teamcreate-rubric]]"
---

# Google DeepMind — Scaling Agent Systems

Controlled empirical study of when and why multi-agent systems (MAS) outperform single-agent.

## Summary

Paper (arXiv 2512.08296, late 2025) runs 180 agent configurations across a benchmark spanning parallelizable and sequential task types. Derives quantitative scaling principles and a predictive model that picks the right architecture for 87% of unseen tasks.

## Key Findings

1. **Task-type conditions everything.** MAS helps on parallelizable tasks; MAS hurts on sequential ones. Up to **70% performance degradation** on sequential reasoning when adding agents.
2. **Model-family sensitivity.** Google models show marginal MAS gains and efficiency plateau; Anthropic models show higher variance with occasional underperformance — interpreted as coordination-overhead sensitivity.
3. **Critical path ≠ total tokens.** Wall-clock latency in parallel MAS is governed by the critical path, not aggregate compute. Token-based proxies (CP length) are recommended over wall-clock measurement because of noise from queuing/rate-limits.
4. **Predictive selection works.** The paper's model recommends the right architecture 87% of the time given task features — suggesting practitioners can automate the choice rather than guess.

## Relevance to claude-workflow

The finding that MAS degrades sequential tasks by up to 70% is a direct empirical basis for the "Default to single-agent" rule in claude-workflow's CLAUDE.md. TeamCreate should be reserved for task types the paper classifies as parallelizable — otherwise the team actively harms output quality on top of the 7× token cost.

## Caveats

- Benchmark-driven; real-world coding tasks may differ in distribution.
- "MAS" in the paper encompasses a range of orchestration patterns, not only TeamCreate-style mailbox coordination.
