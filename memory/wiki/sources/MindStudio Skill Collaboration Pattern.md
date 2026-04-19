---
name: MindStudio Skill Collaboration Pattern
description: MindStudio blog post on Claude Code's skill collaboration pattern — Claude-as-orchestrator, sub-skill pattern, structured I/O contracts, sequential and branching chains
type: source
source_type: blog-post
author: MindStudio
date_published: 2026-03
url: https://www.mindstudio.ai/blog/claude-code-skill-collaboration-pattern
confidence: medium
key_claims:
  - Claude is the coordinator; skills do not call each other directly
  - Structured I/O contracts (JSON schemas) enable reliable composition
  - Sub-skill (parent/child) pattern exists but reduces flexibility and is harder to debug
  - Error handling via structured error objects, not exceptions
tags: [claude-code, skills, orchestration]
status: developing
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[skill-invocation-model]]"
---

# MindStudio — Claude Code Skill Collaboration Pattern

Blog post covering how multiple Claude Code skills compose into workflows. Confidence: medium (single vendor source, no primary documentation citation).

## Key Claims

1. **Claude as coordinator.** "The skills themselves don't call each other directly. Instead, Claude reads the output of each tool, reasons about what to do with it, and decides which skill to invoke next."
2. **Four structural patterns** of composition: linear, branching, loop, parallel. Most production skills are hybrids.
3. **Structured I/O beats free text.** JSON schemas for outputs; structured error objects with codes and retry metadata.
4. **Sub-skill pattern exists but with caveats.** "Some advanced implementations use sub-skill patterns where a 'parent' skill invokes other skills internally. This can make sense for tight, well-defined sub-workflows, but it reduces flexibility and is harder to debug."
5. **Tool descriptions are orchestration instructions.** Claude relies on descriptions to decide next calls — they're not just documentation.

## Example Patterns Given

- Sequential chain: `fetch_article → extract_key_points → generate_summary → send_to_slack`
- Branching: `check_code_quality → [if issues: run_linter → suggest_fixes] or [if clean: run_tests → deploy]`

## What It Contributes

This is the canonical source for the "Claude-as-orchestrator" framing. It also makes the sub-skill tradeoff explicit (flexibility vs. coupling), which is directly relevant to claude-workflow's phase-level sub-skill pattern.

## Caveats

- Single vendor (MindStudio) blog. No citation to official Anthropic docs.
- "Four patterns" framing is plausible but not sourced from Anthropic.
- Structured I/O examples use JSON; claude-workflow uses markdown (five-field handoff block) — different artifact type, same principle.

## Related

- [[multiskill-workflow-patterns]] — the concept that references this source
- [[skill-invocation-model]] — dual invocation model from official docs
