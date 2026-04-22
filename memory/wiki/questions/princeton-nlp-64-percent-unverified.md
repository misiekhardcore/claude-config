---
type: question
title: "Does Princeton NLP actually publish a 64% single-agent-vs-MAS figure?"
question: "The wiki cites 'Princeton NLP: single agent matches MAS on 64% of benchmarks at half cost' in several pages. Is there a primary Princeton NLP paper reporting this, or is the figure a misattribution?"
answer_quality: open
created: 2026-04-22
updated: 2026-04-22
tags: [question, multi-agent, citations, empirical, open]
status: seed
confidence: AMBIGUOUS
evidence:
  - "[[Addy Osmani Code Agent Orchestra]]"
related:
  - "[[agent-scaling-empirical-evidence]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[multiskill-workflow-patterns]]"
  - "[[claude-workflow-phase-shape]]"
sources:
  - "[[Addy Osmani Code Agent Orchestra]]"
open_questions:
  - "Primary Princeton NLP paper URL and title"
  - "Whether 64.6% is actually PatchPilot's single-agent SWE-bench Verified score, misread as a MAS-vs-single ratio"
---

# Does Princeton NLP actually publish a 64% single-agent-vs-MAS figure?

## The claim as it propagated

Addy Osmani's 2026 "Code Agent Orchestra" blog post states: "a single agent matched or outperformed multi-agent systems on 64% of benchmarked tasks when given the same tools and context." Attributed to "Princeton NLP" with no primary link.

The claim was ingested into [[Addy Osmani Code Agent Orchestra]] with a `[!gap]` callout on 2026-04-19 noting the primary citation was not traceable. Despite that flag, downstream pages ([[agent-scaling-empirical-evidence]], [[subagent-vs-teamcreate-rubric]], [[multiskill-workflow-patterns]], [[claude-workflow-phase-shape]]) cite the 64% figure without the caveat.

## The lead suggesting misattribution

A 2026-04-22 citation audit (from another Claude session) flagged:

> "Not found as a multi-agent figure. 64.6% is a single-agent SWE-bench Verified number (PatchPilot). No Princeton paper reports '64% on multi-agent collaboration' as cited."

If correct, Osmani's blog post has misattributed a benchmark score (what percentage of SWE-bench problems a single agent solves) as a comparative claim (what percentage of tasks a single agent matches MAS on). These are unrelated quantities that happen to share a round number.

## Why it matters

Several wiki pages use the 64% to argue for the "default to single-agent" heuristic. The heuristic itself is independently supported by the Google DeepMind 39–70% sequential degradation finding (arXiv:2512.08296) and Anthropic's own "single session is more cost-effective for routine tasks" guidance. The heuristic does not depend on the Princeton claim, but the claim is cited as if it does.

## Status

**Unresolved.** Until a primary Princeton NLP source is found, the 64% figure should be treated as `AMBIGUOUS` and all downstream references soft-tagged. The associated 2.1pp accuracy gain and 2× cost figures share the same provenance and should be flagged together.

## To resolve

1. Search Princeton NLP publications (Chen, Narasimhan, et al.) for multi-agent vs single-agent benchmark studies from 2024–2026.
2. Inspect PatchPilot's SWE-bench Verified scores (~64.6%) and confirm or rule out the misread hypothesis.
3. If Princeton has no such paper, replace all 64% citations with the Google DeepMind and Anthropic evidence that independently supports the same rule.

## Related

- [[Addy Osmani Code Agent Orchestra]] — secondary source introducing the citation
- [[agent-scaling-empirical-evidence]] — quotes the 64% / 2.1pp / 2× figures
- [[subagent-vs-teamcreate-rubric]] — uses 64% as antipattern justification
