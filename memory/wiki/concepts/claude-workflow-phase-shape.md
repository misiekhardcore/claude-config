---
name: claude-workflow phase shape
description: Applied synthesis of multiskill patterns in the claude-workflow plugin — discovery, define, implement and their internal team shapes
type: concept
tags: [claude-code, skills, orchestration, claude-workflow]
status: current
updated: 2026-04-19
created: 2026-04-19
updated: 2026-04-20
confidence: INFERRED
evidence: []
implements:
  - "[[multiskill-workflow-patterns]]"
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[seed-brief-pattern]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[Superpowers Plugin]]"
---

# claude-workflow Phase Shape

How the claude-workflow plugin (~/Projects/claude-workflow) composes skills, phases, and teams. This is the applied synthesis for this repo — read the pattern concepts for the generic theory.

## Three-Phase Pipeline

| Size | Path |
|---|---|
| Trivial fix | `/implement` directly |
| Medium feature | `/discovery` → `/implement` |
| Large feature / epic | `/discovery` → `/define` → `/implement` |

Each arrow crosses a **fresh-session boundary**. The GitHub issue body is the handoff artifact. See [[agent-handoff-artifact-pattern]].

## Phase Shapes

### `/discovery`

**Modes**: Lightweight / Standard / Deep (scope-triaged in Phase 0).

**Standard team** (3 specialists):
- Describe specialist — runs `/describe` to explore the problem space
- Specify specialist — runs `/specify` to produce testable acceptance criteria
- Prior-Art Scout — gathers institutional memory (vault → past issues/PRs → docs) in parallel

**Deep team** (5 specialists): adds Flow analyst and Adversarial questioner.

The Prior-Art Scout's brief seeds `/describe`, which skips its own nested prior-art search. See [[seed-brief-pattern]].

**Output**: a GitHub issue with Problem statement + five-field handoff block.

### `/define`

**Shape**: research team → definition team (two-stage).

**Research team** (parallel):
- Codebase research agent — tech stack, modules, related implementations
- Patterns/learnings agent — vault → project docs → external via Context7

**Definition team** (sequential):
- Architecture specialist — runs `/architecture`, seeded with research brief; architecture decisions go first.
- Design specialist — runs `/design`, seeded with the same brief, working within architecture constraints.

The seed-brief contract is documented: specialists skip their own nested research when a brief is provided.

**Output**: issue body updated with `## /define` section (architecture + design decisions + sub-issues if decomposed).

### `/implement`

**Shape**: `/build` → `/review` → `/verify` → PR, each running in sequence. Loops back to `/build` if review or verify fails.

- `/build` — TDD against acceptance criteria (one criterion at a time).
- `/review` — spawns reviewers (correctness, style/standards) in parallel.
- `/verify` — splits criteria, runs each check, reports pass/fail.

**Output**: a PR closing the issue.

## Inner-Team Hierarchy (Standard Mode)

```
/discovery
├── /describe (specialist)
│   ├── Problem analyst
│   ├── Domain researcher
│   └── (Deep) Failure-mode analyst
├── /specify (specialist)
│   ├── Happy-path analyst
│   └── Edge-case analyst
└── Prior-Art Scout
```

Two levels of team nesting. Only possible with `TeamCreate` (classic subagents can't spawn subagents). See [[hierarchical-agent-decomposition]].

## Composition Rules in CLAUDE.md

From `~/Projects/claude-workflow/CLAUDE.md`:

- **Default to single-agent.** Use `TeamCreate` only for parallelizable work across 3+ independent files or sub-issues.
- **Use the cheapest viable model.** Skills set their own `model:` and `effortLevel:` — trust them.
- **Respond concisely.** No filler, no preamble.

The single-agent default aligns with the Princeton NLP finding: a well-built single agent matches multi-agent on 64% of tasks (Source: [[Addy Osmani Code Agent Orchestra]]).

## Gating Rules

- **Explicit approval required** between phases. Partial feedback is NOT approval.
- **Fresh session between phases.** `/discovery` does not invoke `/define` — it tells the user to start a new session.
- **Open questions mandatory.** Every handoff block has an explicit Open Questions section ("None" if empty).

## Comparison to Superpowers

`claude-workflow` and Superpowers share the same philosophical spine: structured workflow with gating, durable artifacts, subagent-driven execution.

Differences:
- Superpowers gates on skill **auto-activation** ("the agent checks for relevant skills before any task"). `claude-workflow` gates on **explicit phase invocation** — the user runs `/discovery`, then `/define`, etc.
- Superpowers embeds TDD as a first-class skill (RED-GREEN-REFACTOR enforced). `claude-workflow` puts TDD inside `/build` rather than as a separate gate.
- Superpowers uses a git-worktrees skill for branch setup. `claude-workflow` delegates worktrees to the Worktrunk plugin.

See [[Superpowers Plugin]] for the full comparison.

## Related

- [[multiskill-workflow-patterns]] — four generic patterns; claude-workflow is a hybrid
- [[agent-handoff-artifact-pattern]] — issue body is the cross-phase artifact
- [[seed-brief-pattern]] — `/define` → `/architecture` and `/discovery` → `/describe` both use it
- [[hierarchical-agent-decomposition]] — two-level team nesting needs TeamCreate
