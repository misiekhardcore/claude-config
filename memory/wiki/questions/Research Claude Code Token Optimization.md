---
type: synthesis
title: "Research: Claude Code Token Optimization"
created: 2026-04-21
updated: 2026-04-21
tags:
  - research
  - claude-code
  - tokens
  - optimization
status: current
confidence: INFERRED
evidence: []
related:
  - "[[claude-code-system-prompt-composition]]"
  - "[[tool-search-tool-deferred-loading]]"
  - "[[mcp-tool-overhead]]"
  - "[[claude-md-sizing]]"
  - "[[sessionstart-hook-context-injection]]"
  - "[[token-audit-misiekhardcore]]"
sources:
  - "[[claude-code-costs-docs]]"
  - "[[claude-code-token-optimization-2026]]"
  - "[[mindstudio-mcp-token-overhead]]"
  - "[[anthropic-tool-search-docs]]"
---

# Research: Claude Code Token Optimization

Triggered by: 9k system prompt + 11k system tools observed in `/context`, user asked whether claude-config, claude-workflow, claude-obsidian or the internet have patterns to reduce this.

## Overview

System-prompt token cost is a **stack** of contributions (harness + plugins + CLAUDE.md + auto-memory + wiki bootstrap). Each layer has a distinct lever. The cheapest wins are trimming verbose CLAUDE.md and wiki bootstrap content; the structural wins are moving instructions into on-demand skills and disabling MCP servers by default. Tool-side overhead is already mitigated by Claude Code's default deferred loading (ToolSearch), but tool names still accumulate — disabling unused servers beats deferring them.

## Key Findings

1. **CLAUDE.md hierarchical compose is loaded every turn.** Official target: <200 lines per file. User's project `Projects/CLAUDE.md` is 219 lines (~2.8k tokens). Global is fine at 41 lines. (Source: [[claude-code-costs-docs]])
2. **SessionStart hooks inject per-session context invisibly.** The `superpowers` plugin's hook pastes ~2.5k tokens into every session; it is observable only by reading the raw `<system-reminder>`. This is the largest single hidden contributor in Michal's setup. (Source: direct observation, documented in [[sessionstart-hook-context-injection]])
3. **hot.md is 133 lines vs its own 500-word spec.** The wiki's bootstrap pattern auto-reads it at session start, costing ~2-3k tokens when claude-obsidian is active. This is purely self-inflicted drift.
4. **MCP tool schemas are already deferred by default** (Claude Code ~2.x). Default threshold: tools load inline below ~10% of context, deferred above. Configurable via `ENABLE_TOOL_SEARCH=auto:N`. 85% schema savings reported by Anthropic's Tool Search benchmark. (Source: [[anthropic-tool-search-docs]])
5. **Tool-name overhead still counts even when schemas are deferred.** ~200 deferred tools cost hundreds of bytes of names per turn. Disabling unused MCP servers beats relying on deferral.
6. **Claude-workflow's context-hygiene pattern applies here.** Its `_shared/notes-md-protocol.md` caps per-session NOTES.md at <1k tokens. Same discipline belongs in hot.md. (Source: [[claude-workflow-phase-shape]])
7. **12 enabled plugins in Michal's config.** `chrome-devtools-mcp` + `claude-in-chrome` duplicate the same browser-automation surface; one should be disabled. `playwright` MCP visible in deferred list but likely not used in coding sessions.
8. **Code Mode is the emerging 50-90% reduction pattern.** Instead of loading tools, agent writes an orchestration script that runs in a sandbox. Cloudflare/Anthropic published within weeks. Not yet widely available in Claude Code; track.
9. **Skills beat CLAUDE.md for conditional workflow instructions.** Anthropic explicitly recommends moving PR-review/migration/etc. instructions out of CLAUDE.md into skills that load on invocation.
10. **Prompt-cache preservation** matters. Deferred tool schemas are injected inline in conversation, not the system prefix, so the cache survives tool discovery. Do not mix `defer_loading: false` with frequently-changing tools.

## Key Entities

- **ToolSearch / Tool Search Tool**: Anthropic's deferred-tool mechanism, active by default in Claude Code.
- **superpowers plugin**: SessionStart hook injector. Verified to contribute ~2.5k tokens/session in current config.
- **Code Mode**: pattern for compressing 1000s of tool calls into a single sandbox-executed script.

## Key Concepts

- [[claude-code-system-prompt-composition]]: the stack that fills /context's system-prompt line.
- [[tool-search-tool-deferred-loading]]: mechanism + tunables.
- [[mcp-tool-overhead]]: per-server cost ranges + audit workflow.
- [[claude-md-sizing]]: targets and content rules.
- [[sessionstart-hook-context-injection]]: the hidden cost.

## Concrete Action List for Michal

See [[token-audit-misiekhardcore]] for the full plan. P1 quick wins:
1. Trim `Projects/CLAUDE.md` 219 → 120 lines (~1-1.5k savings).
2. Trim `wiki/hot.md` 133 → 30 lines (~1.5-2k savings).
3. Disable `superpowers` when discipline skills not in use (~2.5k savings).
4. Run `/mcp` and disable one of `chrome-devtools-mcp` / `claude-in-chrome` (~2-3k tools savings).
5. Add `ENABLE_TOOL_SEARCH=auto:5` to env (~1-2k tools savings).

Expected combined reduction: **35-45% off the 20k baseline → ~12-13k**.

## Contradictions

- [[claude-code-costs-docs]] says CLAUDE.md under 200 lines; [[claude-code-token-optimization-2026]] says <500 tokens. These are compatible: 200 lines worth of sparse text ≈ 2k tokens, so the stricter community target is the aspirational goal while the official line-count is the hard rule.
- MindStudio's 55k baseline for 5 MCP servers conflicts with Anthropic's claim that "deferred by default" keeps this small. The reconciliation: pre-ToolSearch era vs current Claude Code. Today's baseline for an equivalent setup is closer to 5-8k.

## Open Questions

- Does `ENABLE_TOOL_SEARCH=auto:0` disable the threshold entirely (force defer)? Not documented.
- Is there a way to audit SessionStart hook contributions without toggling plugins? Currently no.
- Can the user gate SessionStart injection on predicates (task type, directory)? No known mechanism; upstream feature request candidate.
- The `superpowers` plugin's SessionStart hook provides real value (enforcing skill invocation) — is there a reduced form that keeps the behaviour at lower token cost? Worth asking upstream.
- March 2026 caching incident (#40524) — has the billing-layer opacity been addressed? Open.

## Sources

- [[claude-code-costs-docs]] — Anthropic, /en/costs
- [[claude-code-token-optimization-2026]] — buildtolaunch, community guide
- [[mindstudio-mcp-token-overhead]] — MindStudio, per-server ranges
- [[anthropic-tool-search-docs]] — Anthropic, Tool Search mechanism
- Local repo signals: claude-config (`just-in-time` rule, 2.6k CLAUDE.md, rtk-rewrite hook), claude-workflow (`_shared/notes-md-protocol.md` <1k cap, 84% context-editing reduction, sub-agent isolation), claude-obsidian (hot.md 500-word target spec, progressive disclosure in query skill)
