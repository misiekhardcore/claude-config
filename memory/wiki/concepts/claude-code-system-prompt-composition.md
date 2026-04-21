---
type: concept
title: "Claude Code System Prompt Composition"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - tokens
  - system-prompt
  - context-engineering
status: current
confidence: EXTRACTED
evidence:
  - "[[claude-code-costs-docs]]"
  - "[[claude-code-token-optimization-2026]]"
related:
  - "[[tool-search-tool-deferred-loading]]"
  - "[[mcp-tool-overhead]]"
  - "[[claude-md-sizing]]"
  - "[[sessionstart-hook-context-injection]]"
  - "[[token-audit-misiekhardcore]]"
---

# Claude Code System Prompt Composition

The "system prompt" counter in `/context` is not one blob. It is a stack of contributions that each session pays on every turn. Knowing the stack tells you which lever to pull.

## Stack

1. **Built-in harness prompt**. Fixed. Contains tool-use protocol, safety rules, markdown conventions, environment block. ~3-4k tokens in 2026-04 builds.
2. **Plugin-injected harness fragments**. Each enabled plugin can contribute system-level instructions. Known contributors: `superpowers` (ships a SessionStart hook that pastes the full `using-superpowers` skill body — ~3k tokens), `claude-in-chrome` (MCP server instructions block), `context7` (MCP server instructions), `mdn` (MCP server instructions). See [[sessionstart-hook-context-injection]].
3. **CLAUDE.md files — hierarchical compose**. Global `~/.claude/CLAUDE.md` + project `./CLAUDE.md` + any subdirectory CLAUDE.md Claude has entered. All loaded verbatim, every turn. See [[claude-md-sizing]].
4. **Memory files**. Auto-memory (`~/.claude/projects/<project>/memory/MEMORY.md`) is harness-loaded every session. Wiki vault (`memory/wiki/hot.md`) is only loaded if a skill reads it — but the claude-obsidian bootstrap instructs Claude to read `hot.md` silently on startup, so practically it is paid every session where that plugin is active.
5. **User instruction / "currentDate" block**. Small, fixed.

## Tools Stack (separate counter)

1. **Built-in tools**. Read/Write/Edit/Glob/Grep/Bash/Skill/Agent/ToolSearch + parameter schemas. ~2-3k tokens.
2. **MCP server tool definitions**. Per-server per-turn cost. See [[mcp-tool-overhead]].
3. **Deferred tools**. Since late 2025, Claude Code defers most MCP tools past a threshold (default ~10% of context, configurable via `ENABLE_TOOL_SEARCH=auto:N`). Deferred tools still inject their **names** — only full schemas are loaded on demand via ToolSearch. See [[tool-search-tool-deferred-loading]].
4. **Custom slash commands**. Each enabled plugin's commands inject a short metadata line.
5. **Skills registry**. Each installed skill's frontmatter (`name`, `description`) is listed so Claude can decide when to trigger. The **body** is only loaded when the skill is invoked. Pushy descriptions improve triggering at a modest per-turn cost.

## Reading your own stack

Run `/context` in any session. The output breaks down:
- System prompt
- System tools
- MCP tools
- Memory files
- Custom agents
- Messages (current conversation)
- Free space

Every line is an independent lever. Optimize the fattest one first.

## Why this matters

Token costs scale linearly with context size. At 20k baseline (9k system + 11k tools) every user message re-transmits all of it. Over a 200-message session that is 4M+ input tokens paid. Prompt caching absorbs some repetition but the marginal hit on each turn remains.

## Sources

- [[claude-code-costs-docs]] — official /en/costs reference
- [[claude-code-token-optimization-2026]] — community synthesis guide
