---
type: concept
title: "SessionStart Hook Context Injection"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - hooks
  - tokens
  - plugins
status: current
confidence: EXTRACTED
evidence:
  - "[[observed-session-reminder-2026-04-21]]"
  - "[[claude-code-costs-docs]]"
related:
  - "[[claude-code-system-prompt-composition]]"
  - "[[Superpowers Plugin]]"
---

# SessionStart Hook Context Injection

Plugins that register a `SessionStart` hook can inject arbitrary text into Claude's initial context. The text appears to Claude as a `<system-reminder>` from the harness and is paid on every turn of the session.

## How it works

Any plugin's `settings.json` / `plugin.json` can declare:

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "", "hooks": [{ "type": "command", "command": "..." }] }
    ]
  }
}
```

Output of the command is wrapped into a `<system-reminder>` and prepended to the conversation. Unlike CLAUDE.md, the user has no visibility into this cost except via `/context`.

## Observed contributors (2026-04)

- **superpowers**: SessionStart hook pastes the full `using-superpowers` skill body (~3k tokens) into every session start. Content contains the "invoke skills even at 1% relevance" decision graph and red-flag table. Verified via `<system-reminder>` block observed at session open: "SessionStart hook additional context: <EXTREMELY_IMPORTANT> You have superpowers. Below is the full content of your 'superpowers:using-superpowers' skill..."
- **claude-in-chrome**: injects server instructions block ("IMPORTANT: Before using any chrome browser tools, you MUST first load them using ToolSearch") via MCP server instructions, not hook. Small (<300 tokens).
- **mdn**, **context7**: MCP server instructions (~100-300 tokens each).

## Cost analysis

One SessionStart hook injection pattern is equivalent to permanently pinning a skill body to CLAUDE.md. Defeats progressive disclosure: the core benefit of skills is that their body is only loaded on invocation.

## Levers

1. **Audit** — no direct Claude Code command lists SessionStart hooks. Grep plugin configs: `grep -r "SessionStart" ~/.claude/plugins/`.
2. **Disable the plugin** if the injection is not essential every session. In `~/.claude/settings.json`:
   ```json
   "enabledPlugins": { "superpowers@claude-plugins-official": false }
   ```
3. **Fork + trim** — some plugins' SessionStart content is actionable but over-sized. Forking to reduce the injected blurb is a one-time cost.
4. **Ask upstream** to move the content into a short auto-invoked skill description, letting Claude load the body only when relevant.

## Trade-off

SessionStart hooks exist because some plugin behaviour depends on Claude being *primed* before any user message (the "1% relevance → invoke" rule of superpowers is a prime example — it only works if Claude sees the instruction before processing the user's first turn). Removing the hook weakens the plugin.

Decision rule: keep SessionStart injection only for plugins whose value comes from *every session*. For any plugin whose value is *conditional* on task type, prefer an auto-triggered skill with a pushy description.

## Sources

- [[observed-session-reminder-2026-04-21]] — direct observation of superpowers injection in current session
- [[claude-code-costs-docs]] — hooks as a preprocessing mechanism
