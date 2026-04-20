---
type: concept
title: "Plugin Root Variable in Skills"
created: 2026-04-17
updated: 2026-04-19
tags:
  - concept
  - claude-code
  - skills
  - plugin
  - claude-workflow
status: mature
related:
  - "[[claude-skill-anatomy]]"
  - "[[skill-frontmatter-reference]]"
  - "[[skill-invocation-model]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[claude-workflow-composition-codification]]"
sources:
  - "[[claude-code-skills-official-docs]]"
---

# Plugin Root Variable in Skills

`${CLAUDE_PLUGIN_ROOT}` is the variable Claude Code expands to the absolute path of the currently executing plugin's root directory. It exists so plugin-authored skills can reference sibling files (`_shared/*.md`, `_templates/*.md`, `docs/*.md`) without hard-coding absolute paths.

## Where it is officially expanded

Per `code.claude.com/docs` (captured via Context7), `${CLAUDE_PLUGIN_ROOT}` is documented only for:

- **Hook commands** in `hooks.json`
- **MCP server configs** (`.mcp.json` server `args` / `env`)

SKILL.md body references — e.g. ``See `${CLAUDE_PLUGIN_ROOT}/_shared/composition.md` for...`` — rely on Claude's **contextual resolution**, not a documented guarantee. It works today but is not part of the formal plugin contract.

## Fallback pattern

Since body-text expansion is not guaranteed, plugins that reference shared protocols from inside skill prose should document a fallback for authors and readers:

> Skills in this plugin reference shared protocols via `${CLAUDE_PLUGIN_ROOT}/_shared/<file>.md`. If your Claude Code version does not expand this variable inline in skill body text, the fallback convention is: skills reference `_shared/<file>.md` and Claude resolves the path by globbing against the plugin cache at `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/`.

That paragraph is in `claude-workflow`'s `CLAUDE.md`. Any plugin using `${CLAUDE_PLUGIN_ROOT}` in skill bodies should include an equivalent note.

## Why this matters for claude-workflow

The plugin uses `${CLAUDE_PLUGIN_ROOT}` heavily to cross-link:

- Skills → `_shared/composition.md`, `_shared/handoff-artifact.md`, `_shared/interviewing-rules.md`
- Orchestrator template → scope-assessment examples in other skills
- `docs/workflow.md` → `_shared/composition.md`

Without the fallback convention, an older Claude Code build could surface those references as literal unexpanded strings to the user. The fallback keeps the skills functional across versions.

## Historical context

Captured from claude-workflow stage #3 (PR #7, 17-skill migration). The migration replaced absolute paths with `${CLAUDE_PLUGIN_ROOT}` references and added the fallback paragraph to `CLAUDE.md` so authors of new skills in the plugin know the contract is best-effort, not guaranteed.
