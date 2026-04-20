---
type: synthesis
title: "Research: allowed-tools best practice for multi-agent workflow plugins"
created: 2026-04-19
updated: 2026-04-19
tags:
  - research
  - claude-code
  - skills
  - plugins
  - claude-workflow
  - permissions
status: developing
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[allowed-tools-semantics]]"
  - "[[skill-vs-subagent-tool-fields]]"
  - "[[allowed-tools-for-multi-agent-plugins]]"
  - "[[agent-skills-best-practices-anthropic]]"
  - "[[claude-code-skills-official-docs]]"
  - "[[skill-frontmatter-reference]]"
  - "[[claude-workflow-composition-codification]]"
sources:
  - "[[agent-skills-best-practices-anthropic]]"
  - "[[claude-code-skills-official-docs]]"
---

# Research: `allowed-tools` Best Practice for Multi-Agent Workflow Plugins

## Overview

The `allowed-tools` frontmatter field in `SKILL.md` is optional and **pre-approves** tools during skill execution — it does not restrict them. For multi-agent workflow plugins like `claude-workflow`, the recommended default is to **omit** `allowed-tools` from orchestrator and specialist skills, and declare it only for side-effectful skills combined with `disable-model-invocation: true`. Real capability restriction belongs on subagents, not skills.

## Key Findings

- **`allowed-tools` is a pre-approval list, not a sandbox.** When the skill is active, listed tools run without a permission prompt. Unlisted tools remain callable; they fall through to the user's permission settings. (Source: [[claude-code-skills-official-docs]], [[agent-skills-best-practices-anthropic]])
- **Required vs. optional.** Only `name` and `description` are effectively required. `allowed-tools` is optional and has no default recommendation in the official best-practices checklist. (Source: [[agent-skills-best-practices-anthropic]])
- **The SDK ignores frontmatter `allowed-tools`.** When a skill is loaded via the Claude Agent SDK, control tool access via the `allowedTools` query option. To enforce restriction, pair with `permissionMode: "dontAsk"`. (Source: [[agent-skills-best-practices-anthropic]])
- **Skill `allowed-tools` and subagent `tools:` are different fields with opposite semantics.** Skill pre-approves; subagent restricts. See [[skill-vs-subagent-tool-fields]]. (Source: [[claude-code-skills-official-docs]])
- **`bypassPermissions` ignores `allowed-tools` entirely.** Only deny rules and hooks can block tools in that mode. (Source: [[agent-skills-best-practices-anthropic]])
- **The official `skill-creator` skill (anthropics/skills repo) does not declare `allowed-tools`.** This is a signal that omission is the normal case even for non-trivial skills. (Source: [[claude-code-skills-official-docs]])
- **Cross-platform portability favors omission.** Tool names differ across Claude Code (`Read`), Copilot CLI (`read_file`), and Gemini CLI — declaring tools binds the skill to one platform. (Source: [[agent-skills-best-practices-anthropic]])
- **Canonical use case: side-effect skills.** `/commit`, `/deploy`, destructive commands benefit from `allowed-tools` + `disable-model-invocation: true` as defense in depth. (Source: [[claude-code-skills-official-docs]])
- **Plugin-specific finding:** `claude-workflow`'s own 17 skills omit `allowed-tools` across the board. Consistent with best practice. But the plugin's `_templates/AUTHORING.md` describes the field as "Restrict the skill to a subset of tools" — this is incorrect per Anthropic's docs.

## Recommendation for `claude-workflow`

For the current plugin shape (three roles: orchestrator / specialist / primitive + interviewer):

1. **Keep omitting `allowed-tools` from all 17 skills.** The current state is correct.
2. **Fix `_templates/AUTHORING.md`:** replace "Restrict the skill to a subset of tools" with "Pre-approve listed tools so Claude runs them without per-use prompts. Does not restrict access — use deny rules or subagent `tools:` for real restriction."
3. **Fix `_templates/SKILL.primitive.template.md` comment:** replace "if the skill should be restricted" with "if the skill should pre-approve a narrow tool surface."
4. **If a future skill is destructive** (`/deploy`, `/publish`, `/release`): declare a narrow `allowed-tools` list + `disable-model-invocation: true`.
5. **If a future skill spawns a subagent via `context: fork`**: use the subagent's `tools:` for real restriction; use `allowed-tools` only to pre-approve any preprocessing `` !`command` `` injections.

## Key Entities

- **Anthropic** — author of the official Claude Code and Agent Skills docs; defines the canonical semantics of `allowed-tools`.
- **anthropics/skills (GitHub)** — official repo; `skill-creator/SKILL.md` models the "no `allowed-tools` declaration" pattern.
- **claude-workflow plugin** — the codebase where this research applies; current practice aligns with best practice, but authoring docs misdescribe the semantics.

## Key Concepts

- [[allowed-tools-semantics]] — pre-approve vs restrict, permission evaluation order, SDK vs CLI.
- [[skill-vs-subagent-tool-fields]] — the same-looking-opposite-behaving pair.
- [[allowed-tools-for-multi-agent-plugins]] — role-based and surface-based decision matrix.
- [[skill-frontmatter-reference]] — full field-by-field reference (already evergreen).

## Contradictions

- **[[skill-frontmatter-reference]]** (2026-04-17) correctly describes `allowed-tools` as "Pre-approves listed tools; Claude can use them without permission prompts."
- **claude-workflow `_templates/AUTHORING.md`** (current) describes it as "Restrict the skill to a subset of tools."
- **Resolution:** The wiki page is correct per Anthropic docs. The repo doc is wrong and should be fixed. See [[allowed-tools-for-multi-agent-plugins]] §"What the `claude-workflow` Plugin Currently Does" for the fix list.

## Open Questions

- Does Claude Code raise a warning when a skill declares `allowed-tools` with a tool name that doesn't exist on the current platform? (Not explicitly documented — likely silent pass-through.)
- For plugins distributed across Claude Code, Copilot CLI, and Gemini CLI, is there a convention for platform-conditional frontmatter? The search surfaced no official pattern.
- Does `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (the feature flag claude-workflow depends on) change `allowed-tools` semantics for team-parallel execution? Not mentioned in Anthropic docs — assume unchanged.

## Sources

- [[claude-code-skills-official-docs]] — code.claude.com/docs/en/skills (authoritative)
- [[agent-skills-best-practices-anthropic]] — platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices (authoritative)
- anthropics/skills `skill-creator/SKILL.md` — confirms canonical skill omits `allowed-tools` (via [[claude-code-skills-official-docs]])
- Secondary community guides (levelup.gitconnected.com, leehanchung.github.io, alexop.dev) — all converge on the pre-approval interpretation; no credible source argues for the restrict interpretation.
