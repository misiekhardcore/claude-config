---
name: Agent Skills Best Practices (Anthropic)
description: Official Anthropic authoring guide for Claude Agent Skills — platform.claude.com docs page on skill structure, progressive disclosure, and evaluation-driven development
type: source
source_type: official-docs
author: Anthropic
date_published: 2025-10
url: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
source_reliability: high
tags: [claude-code, skills, official, best-practices]
status: evergreen
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
created: 2026-04-19
related:
  - "[[claude-code-skills-official-docs]]"
  - "[[allowed-tools-semantics]]"
  - "[[skill-frontmatter-reference]]"
  - "[[skill-creation-patterns]]"
evidence: []
---

# Agent Skills Best Practices (platform.claude.com)

## Source Information

- **URL**: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
- **Organization**: Anthropic (Claude API docs)
- **Confidence**: high (official source)
- **Last fetched**: 2026-04-19

## What It Covers

Companion page to `code.claude.com/docs/en/skills`. Focuses on authoring decisions: concision, degrees of freedom, progressive disclosure, evaluation-driven development, and anti-patterns.

## Key Claims Relevant to `allowed-tools`

- YAML frontmatter requires only `name` (≤64 chars, lowercase/numbers/hyphens, no XML tags, no reserved words `anthropic`/`claude`) and `description` (≤1024 chars, non-empty). All other fields — including `allowed-tools` — are **optional**.
- The official skill-authoring checklist does **not** include `allowed-tools` as a mandatory or recommended field.
- Instruction to test across Haiku, Sonnet, and Opus — supports the broader cross-model portability argument for omitting platform-specific frontmatter like `allowed-tools`.

## Other Load-Bearing Claims

- **Concise is key**: every token in a loaded SKILL.md competes with conversation history. Default assumption: Claude already knows the domain; only add what is non-obvious.
- **Degrees of freedom**: match specificity to task fragility. High (code review), medium (report generation), low (migrations).
- **Progressive disclosure**: SKILL.md stays under 500 lines; detailed material goes into `reference/`, `scripts/`, `assets/`.
- **Avoid nested references**: Claude may preview with `head -100`; keep references one level deep from SKILL.md.
- **Evaluation-driven development**: write three evaluations BEFORE writing extensive documentation. Baseline without skill, then iterate.
- **Claude A / Claude B pattern**: develop the skill with one instance, test with another. Claude A understands skill structure natively — no meta-skill needed.

## What It Contributes

For the research question (best practice for `allowed-tools` in multi-agent plugins), this page confirms:

1. The field is optional with no default recommendation.
2. Omission is the cross-model/cross-platform safe choice.
3. Best-practice checklists don't demand it — the field is for UX optimization, not correctness.

## Limitations

Does not discuss multi-agent orchestration patterns specifically. For that, combine with `code.claude.com/docs/en/skills` (subagent `context: fork`) and `platform.claude.com/docs/en/agent-sdk/skills` (SDK behavior).
