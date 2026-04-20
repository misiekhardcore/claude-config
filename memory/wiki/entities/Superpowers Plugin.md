---
name: Superpowers Plugin
description: Claude Code agentic skills framework by Jesse Vincent (obra) — structured software dev methodology with brainstorm → design → plan → subagent-driven execution → review → merge
type: entity
tags: [claude-code, plugin, orchestration]
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-19
related:
  - "[[claude-workflow-phase-shape]]"
  - "[[multiskill-workflow-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
---

# Superpowers Plugin

Agentic skills framework for Claude Code by Jesse Vincent (GitHub: obra). Enforces a structured development methodology via auto-activating skills (Source: [[Superpowers GitHub]]).

## Workflow Phases

1. **Brainstorm** — Socratic questioning to refine requirements before coding.
2. **Design spec / worktree setup** — isolated workspace; clean test baseline.
3. **Implementation plan** — bite-sized tasks (2-5 min each) with exact paths, test commands, expected outputs, and commit messages.
4. **Subagent-driven execution** — one fresh subagent per task; two-stage review (spec compliance, then code quality).
5. **TDD throughout** — RED-GREEN-REFACTOR enforced by the `test-driven-development` skill. Makes Claude delete code written before tests.
6. **Review** — `requesting-code-review` runs between tasks; critical issues block progress.
7. **Merge / finish** — `finishing-a-development-branch` verifies tests, offers merge/PR/discard options.

## Key Design Choices

- **Auto-activation, not manual invocation.** Skills monitor context and self-activate. "You don't need to do anything special."
- **Hard gates.** "You cannot build what you haven't designed. Skip the brainstorm gate and you'll implement the wrong thing."
- **Two-stage review separation** (v4.0+): spec-compliance reviewer and code-quality reviewer are distinct agents.
- **Composable skills**, but the composition is enforced by gate order, not by parent-skill frontmatter.

## Comparison to `claude-workflow`

| Dimension | Superpowers | claude-workflow |
|---|---|---|
| Gating | Auto-activation per context | Explicit `/phase` invocation |
| TDD | First-class enforced skill | Inside `/build` |
| Worktrees | Own `using-git-worktrees` skill | Delegates to Worktrunk plugin |
| Review | Two-stage (spec + quality) between tasks | `/review` + `/verify` phase skills |
| Artifact | Design doc + plan.md + review-notes.md | GitHub issue body (five-field handoff block) |
| Subagents | `dispatching-parallel-agents` skill | `TeamCreate` (experimental) |

Both share the philosophical spine: **structured workflow, durable artifacts, subagent-driven execution, gated phases**.

## Installation

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace
```

## Links

- [GitHub: obra/superpowers](https://github.com/obra/superpowers)
- [Claude plugin listing](https://claude.com/plugins/superpowers)
- [Author blog post (Jesse Vincent)](https://blog.fsck.com/2025/10/09/superpowers/)

## Related

- [[claude-workflow-phase-shape]] — sibling framework
- [[multiskill-workflow-patterns]] — both use Parallel + Linear hybrids
- [[agent-handoff-artifact-pattern]] — Superpowers uses md files; claude-workflow uses issue body
