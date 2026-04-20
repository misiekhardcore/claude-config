---
name: allowed-tools best practice for multi-agent workflow plugins
description: Guidance for declaring `allowed-tools` in plugins like claude-workflow — by skill role (orchestrator/specialist/primitive) and by invocation surface (CLI vs SDK).
type: concept
tags: [claude-code, plugins, claude-workflow, skills, multi-agent, composition]
status: current
created: 2026-04-19
updated: 2026-04-20
confidence: INFERRED
evidence:
  - "[[agent-skills-best-practices-anthropic]]"
  - "[[claude-code-skills-official-docs]]"
uses:
  - "[[skill-invocation-model]]"
related:
  - "[[allowed-tools-semantics]]"
  - "[[skill-vs-subagent-tool-fields]]"
  - "[[claude-workflow-composition-codification]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[multiskill-workflow-patterns]]"
  - "[[skill-creation-patterns]]"
sources:
  - "[[agent-skills-best-practices-anthropic]]"
  - "[[claude-code-skills-official-docs]]"
---

# `allowed-tools` Best Practice for Multi-Agent Workflow Plugins

Guidance for plugins like `claude-workflow` that ship bundles of skills playing distinct roles (orchestrator, specialist, primitive).

## TL;DR

- **Default: omit `allowed-tools`.** The field is optional. Omission defers to user/project permission settings, maximizes cross-platform portability, and causes no functional loss.
- **Declare it only when pre-approval is the point** — a narrow, destructive, or side-effectful skill where per-use prompts would break flow (e.g., `/commit`, `/deploy`).
- **Pair `allowed-tools` with `disable-model-invocation: true` for side-effect skills.** Defense in depth: user-only invocation plus a pinned toolset.
- **Do not use `allowed-tools` as a sandbox.** It pre-approves, it does not restrict. Real capability limits go in subagent `tools:` (see [[skill-vs-subagent-tool-fields]]).

## Guidance by Role

Aligned with the three-role taxonomy from [[claude-workflow-composition-codification]]:

### Orchestrator skills (`/discovery`, `/define`, `/implement`)

**Recommendation: omit `allowed-tools`.**

Orchestrators interview the user, spawn specialists via `TeamCreate`, and write handoff artifacts (GitHub issues, etc.). They exercise a broad tool surface: `Read`, `Write`, `Edit`, `Bash`, `WebFetch`, GitHub MCP. Declaring the full list buys nothing — it pre-approves tools the user already has rules for.

Orchestrators should respect the user's existing permission posture. If a user has `Bash(gh *)` allowlisted globally, that carries over. If not, they consent once per session. Silently pre-approving the entire orchestration surface contradicts the user's own security configuration.

### Specialist skills (`/build`, `/review`, `/architecture`, `/specify`)

**Recommendation: omit `allowed-tools` for normal specialists. Consider declaring for specialists that spawn subagents with `context: fork`.**

Most specialists run inline, doing bounded work with standard tools. Omit the field.

For specialists that fork subagents (e.g., a research specialist using `context: fork` + `agent: Explore`), `allowed-tools` can pre-approve the preprocessing `` !`command` `` injections that run before the fork. The subagent's `tools:` field still governs what runs inside the fork.

### Primitive / interactive skills (`/grill-me`)

**Recommendation: omit `allowed-tools` unless the primitive has a fixed narrow surface.**

Primitives are reusable inline behaviors. If a primitive always and only reads context (e.g., a grill-style interviewer that uses `Read`, `Grep`, `Glob`), declaring `allowed-tools: Read Grep Glob` is reasonable — the surface is narrow enough that pre-approval is a clear ergonomic win. But if the primitive might reach for `Bash` or `Edit` in edge cases, omit the field to avoid surprising the user with unprompted tool calls.

Confirmed by the `SKILL.primitive.template.md` stance: the line is commented out and labeled *"Uncomment only if the skill should be restricted to a subset of tools."*

> [!gap] The template's comment uses "restricted" — per [[allowed-tools-semantics]] the correct framing is "pre-approved." Update the comment when next editing.

### Side-effect skills (`/deploy`, `/commit`, destructive commands)

**Recommendation: declare `allowed-tools` + `disable-model-invocation: true`.**

This is the canonical case. Example from official docs:

```yaml
---
name: commit
description: Stage and commit the current changes
disable-model-invocation: true
allowed-tools: Bash(git add *) Bash(git commit *) Bash(git status *)
---
```

The user types `/commit` deliberately; the skill runs the three git commands without six permission prompts; nothing else is smuggled in because the skill's markdown body doesn't tell Claude to do anything else.

## Guidance by Invocation Surface

### Claude Code CLI (the default)

`allowed-tools` works as documented. Follow the role-based guidance above.

### Agent SDK

`allowed-tools` **frontmatter is ignored**. The SDK reads `allowedTools` from the query configuration instead. If you ship a plugin expected to work under both CLI and SDK, duplicating the toolset in frontmatter is wasted motion. Document SDK usage separately.

To enforce restriction under the SDK, pair `allowedTools` with `permissionMode: "dontAsk"`. This converts unlisted-tool prompts into denials and is the only built-in way to make the list actually restrictive. (Source: [[agent-skills-best-practices-anthropic]])

## What the `claude-workflow` Plugin Currently Does

Observed state (2026-04-19) in this worktree:

- **None of the 17 existing skills declare `allowed-tools`.** Consistent with the guidance above — claude-workflow orchestrators, specialists, and `/grill-me` all omit the field.
- `_templates/SKILL.primitive.template.md` has `# allowed-tools: Read, Grep, Glob, Bash` commented out with the misleading "restricted" label.
- `_templates/AUTHORING.md` describes the field as "Restrict the skill to a subset of tools. Omit to allow all tools." This is **factually wrong** per the official docs — it inverts the semantics. Fix: replace "restrict" with "pre-approve" and add a pointer to deny rules / subagent `tools:` for actual restriction.

## Decision Matrix

| Skill role | `allowed-tools` | `disable-model-invocation` | Rationale |
|------------|-----------------|----------------------------|-----------|
| Orchestrator | omit | default (false) | Broad surface; respect user permission config |
| Specialist (inline) | omit | default (false) | Standard tools; user has rules already |
| Specialist (forks subagent) | narrow list optional | default (false) | Pre-approve preprocessing; subagent `tools:` does real restriction |
| Primitive with narrow surface | narrow list optional | default (false) | Ergonomic win if surface is truly fixed |
| Side-effect / destructive | declare narrow list | `true` | Defense in depth: user-only trigger + pinned toolset |
| Reference / background knowledge | omit | default | Pair with `user-invocable: false` instead |

## Related Patterns

- For capability restriction, reach for subagents (`.claude/agents/*.md` with `tools:`) — see [[skill-vs-subagent-tool-fields]].
- For defense-in-depth on destructive actions, combine `disable-model-invocation: true` + narrow `allowed-tools` + explicit user invocation.
- For cross-platform plugins (Claude Code + Copilot CLI + SDK), prefer omission since tool names differ across platforms.
