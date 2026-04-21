---
type: source
title: "Claude Code Costs Documentation"
source_type: official-docs
author: Anthropic
date_published: 2026-04
url: https://code.claude.com/docs/en/costs
source_reliability: high
accessed: 2026-04-21
tags:
  - claude-code
  - tokens
  - costs
  - official
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "CLAUDE.md under 200 lines by including only essentials"
  - "MCP tool definitions are deferred by default"
  - "Agent teams use ~7x more tokens than standard sessions when teammates run plan mode"
  - "Prompt caching and auto-compaction are built-in; user behavior drives the rest"
related:
  - "[[claude-code-system-prompt-composition]]"
  - "[[claude-md-sizing]]"
  - "[[mcp-tool-overhead]]"
  - "[[tool-search-tool-deferred-loading]]"
---

# Claude Code Costs Documentation

Canonical Anthropic reference for cost tracking, team management, and token reduction.

## Summary

Official /en/costs page. Structured into three blocks: tracking your costs, team management, reduce token usage.

## Key contributions to the wiki

1. **CLAUDE.md sizing target**. "Aim to keep CLAUDE.md under 200 lines by including only essentials." Used in [[claude-md-sizing]].
2. **Deferred MCP loading**. "MCP tool definitions are deferred by default, so only tool names enter context until Claude uses a specific tool." Used in [[tool-search-tool-deferred-loading]].
3. **Hooks as context preprocessors**. Example: PreToolUse on Bash filters test output from 10k lines → 100 matching lines. Used in [[sessionstart-hook-context-injection]].
4. **Skills over CLAUDE.md for conditional content**. "Skills load on-demand only when invoked, so moving specialized instructions into skills keeps your base context smaller." Used in [[claude-md-sizing]].
5. **Agent teams cost multiplier**. "~7x more tokens than standard sessions when teammates run plan mode." Informs TeamCreate economics.
6. **`/compact` with focus hint** — custom compaction instruction via CLAUDE.md `## Compact instructions` section.
7. **`MAX_THINKING_TOKENS`** — tunable extended-thinking budget.

## Caveats

Page is maintained by Anthropic and reflects current harness behaviour. Settings keys and defaults are specific to Claude Code 2.x; older/newer versions may diverge.

## Relevant commands

- `/cost` — session token stats (API users; subscribers use `/stats`)
- `/context` — show token breakdown
- `/clear` — reset conversation
- `/compact` — summarize conversation
- `/model` — switch between Opus/Sonnet/Haiku
- `/mcp` — list and toggle MCP servers
- `/rewind` — restore previous checkpoint
- `/effort` — adjust thinking effort
