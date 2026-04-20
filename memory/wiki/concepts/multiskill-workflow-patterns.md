---
name: Multiskill workflow patterns
description: Four structural patterns for composing multiple Claude Code skills — linear, branch, loop, parallel — and the Claude-as-orchestrator default
type: concept
tags: [claude-code, skills, orchestration, claude-workflow]
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-19
related:
  - "[[skill-invocation-model]]"
  - "[[skill-creation-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[seed-brief-pattern]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[Superpowers Plugin]]"
---

# Multiskill Workflow Patterns

Four structural patterns cover most multiskill workflows in Claude Code. Real systems are hybrids (Source: [[MindStudio Skill Collaboration Pattern]]).

## The Four Patterns

| Pattern | Shape | When to use |
|---|---|---|
| **Linear** | `A → B → C → D` | Predictable pipeline, each step's output feeds the next |
| **Branch** | `A → if(x) B else C` | Triage, classification, review workflows |
| **Loop** | `A → check → A until done` | Research, iterative refinement, autoresearch |
| **Parallel** | `A, B, C in parallel → merge` | Independent sub-tasks, speed matters |

`claude-workflow` uses hybrids: the phase sequence `/discovery → /define → /implement` is linear, but each phase spawns parallel specialists inside (Source: [[claude-workflow-phase-shape]]).

## Claude-as-Orchestrator (Default)

The dominant 2026 pattern: skills do NOT call each other directly. Claude reads each skill's output, reasons about what comes next, and invokes the next skill. This keeps skills decoupled and reusable (Source: [[MindStudio Skill Collaboration Pattern]]).

Implication for skill authors: the `description` field drives composition because Claude relies on descriptions to decide the next call. Descriptions must be explicit about trigger contexts and expected inputs/outputs.

## Sub-Skill Pattern (Tight Coupling)

A parent skill invokes children directly — the children are not independent citizens. This "reduces flexibility and is harder to debug" (Source: [[MindStudio Skill Collaboration Pattern]]), but is appropriate when:

- The sub-workflow is tight and well-defined
- The children should not be reachable outside the parent's context
- You want to enforce gating (can't run child skills out of order)

`claude-workflow` uses this at the phase level: `/discovery` invokes `/describe` + `/specify` as specialists via `TeamCreate`. Children are not usable standalone outside the phase.

## Structured I/O Contracts

Composition reliability depends on structured outputs — JSON schemas or a fixed markdown shape, not free text (Source: [[MindStudio Skill Collaboration Pattern]]).

```json
{
  "status": "issues_found",
  "issues": [{"line": 14, "type": "null_check", "severity": "high"}]
}
```

`claude-workflow` uses a markdown equivalent: the five-field handoff block (Acceptance criteria, Constraints, Prior decisions, Evidence, Open questions) stamped into the GitHub issue body. See [[agent-handoff-artifact-pattern]].

## Error Handling Across Chains

Return structured error objects, not exceptions. The orchestrator makes fallback decisions from them (Source: [[MindStudio Skill Collaboration Pattern]]).

```json
{"status": "error", "error_code": "RATE_LIMIT_EXCEEDED", "retry_after": 30}
```

## Failure Modes

- **Infinite handoff loops**: A → B → C → A with nobody owning the task. The number-one failure mode (Source: [[Beam Multi-Agent Orchestration Patterns]]).
- **Context loss at transfer**: each handoff drops detail unless the artifact captures it.
- **Handoff too early / too late**: first agent underperforms or frustration builds.
- **Subagents can't spawn subagents**: hard limit in Claude Code. Deeply nested team patterns need `TeamCreate` (experimental) or flat decomposition. See [[hierarchical-agent-decomposition]].

## Single-Agent Bias

Princeton NLP: single agent matched or beat multi-agent on **64% of tasks** at half the cost. Multi-agent adds ~+2.1pp accuracy (Source: [[Addy Osmani Code Agent Orchestra]]). Reserve multi-skill orchestration for genuinely cross-domain or parallelizable work.

`claude-workflow`'s CLAUDE.md encodes this: "Default to single-agent. Use `TeamCreate` only for parallelizable work across 3+ independent files or sub-issues."

## Related

- [[skill-invocation-model]] — how skills trigger (manual vs. auto)
- [[agent-handoff-artifact-pattern]] — artifact-based handoff between phases
- [[seed-brief-pattern]] — upstream research brief seeds downstream specialists
- [[hierarchical-agent-decomposition]] — nested team shape for deep workflows
- [[claude-workflow-phase-shape]] — applied synthesis for this repo
