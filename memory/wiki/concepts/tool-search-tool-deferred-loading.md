---
type: concept
title: "Tool Search Tool and Deferred Loading"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - tokens
  - mcp
  - tool-use
status: current
confidence: EXTRACTED
evidence:
  - "[[anthropic-tool-search-docs]]"
  - "[[claude-code-costs-docs]]"
related:
  - "[[claude-code-system-prompt-composition]]"
  - "[[mcp-tool-overhead]]"
---

# Tool Search Tool and Deferred Loading

A Claude Code mechanism that replaces "load every tool schema upfront" with "load schemas on demand". Mitigates MCP server bloat without sacrificing the tool surface.

## Mechanism

- Tools are registered with `defer_loading: true` (default for MCP tools above a context-share threshold).
- At session start only **tool names** are placed in the system-tools section. Full schemas are withheld.
- `ToolSearch` is a built-in tool. Claude calls it with either:
  - `tool_search_tool_regex_20251119` — Python `re.search()` regex patterns
  - `tool_search_tool_bm25_20251119` — natural-language query
- Top 3-5 matches are returned as `tool_reference` blocks that expand to full schemas inline in the conversation. The cached prefix is not invalidated.

## Reported impact

- 85% token-context reduction vs loading all tools (Anthropic internal benchmark)
- One workflow: 51k → 8.5k tokens of MCP overhead (46.9% reduction)
- Accuracy gains: Opus 4 MCP eval 49% → 74%; Opus 4.5 79.5% → 88.1%

## Settings that tune it

- `ENABLE_TOOL_SEARCH=auto:N` — set deferral threshold to N% of context. Default is 10% (~20k tokens of tool schemas). `auto:30` raises to 30% (~60k tokens); below the threshold, tools load inline and ToolSearch auto-disables. Use a **lower** value to force earlier deferral if you have many MCP servers.
- Marking a specific tool with `defer_loading: false` keeps it always-loaded — reserve this for tools used in every turn.

## Known limits

- **Tool names still accumulate.** ~200 deferred tools across 8 MCP services still inject hundreds of bytes of names per turn. Disabling unused servers beats deferring them.
- **Bedrock incompatible.** `CLAUDE_CODE_USE_BEDROCK=1` + multiple MCP servers breaks with "Tool reference not found".
- **Daemon-spawned agents lack ToolSearch.** Subagents launched via the daemon cannot discover deferred tools. Workaround: add frequently-used deferred tools to the subagent's direct tool list.
- **Custom agents discoverability** (issue #32485): when the `Agent` tool is deferred, subagent-type names disappear from index. Being addressed.
- **Conversation compaction** previously dropped deferred tool schemas; fixed in Claude Code v2.1.x.
- **"Tool loaded." noise**: every deferred load prints a line. Low-signal; tracked in issue #31596.

## Practical guidance

1. Keep ToolSearch enabled (it is, by default).
2. Audit `/mcp` quarterly; remove servers that have not been used in 2 weeks — name overhead alone is worth it.
3. Only pin `defer_loading: false` on tools you call every turn (Read/Write/Grep/Bash already bypass this).
4. Lower `ENABLE_TOOL_SEARCH=auto:5` if you want aggressive deferral in MCP-heavy sessions.

## Sources

- [[anthropic-tool-search-docs]] — platform.claude.com Tool Search reference
- [[claude-code-costs-docs]] — official cost/optimization doc
