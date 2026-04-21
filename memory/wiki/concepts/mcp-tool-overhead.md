---
type: concept
title: "MCP Tool Overhead"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - mcp
  - tokens
status: current
confidence: EXTRACTED
evidence:
  - "[[mindstudio-mcp-token-overhead]]"
  - "[[claude-code-token-optimization-2026]]"
related:
  - "[[tool-search-tool-deferred-loading]]"
  - "[[claude-code-system-prompt-composition]]"
---

# MCP Tool Overhead

Every MCP server attached to a Claude Code session contributes to the "System tools" token counter. Costs add up fast, and they are paid on every turn — whether the server is used or not.

## Rough per-server costs (pre-ToolSearch baseline)

| Tool count per server | Per-turn token cost |
|---|---|
| 1 tool | 100-500 |
| 10 tools (well-documented) | 1,500-3,000 |
| 30 tools (rich schemas) | 5,000-8,000 |

Industry examples:
- Jira MCP: ~17k tokens alone
- 5-server / 58-tool setup: ~55k tokens baseline
- Anthropic internal worst case: 134k tokens of tool definitions before optimization

With ToolSearch enabled (default in Claude Code since 2025-11), full schemas are deferred — but **tool names remain** in system tools. A server exposing 200 tools still costs hundreds of name-bytes per turn.

## Levers

1. **`/mcp`** — runtime toggle. Lists configured servers; lets you disable unused ones for the rest of the session. Use at start of any focused coding session.
2. **Zero-default MCP policy**. Keep `~/.claude.json` lean; add servers per project or per task, remove when done. Global `~/.claude/settings.json` should list only servers used in almost every session.
3. **Per-workspace `.mcp.json`**. Narrow server set to project needs.
4. **Prefer CLI tools over MCP** for read-only work. `gh`, `aws`, `gcloud`, `sentry-cli` cost **zero** system-tools tokens — Claude runs them via Bash. Reported ~40% savings when MCP is swapped for CLI equivalents.
5. **Trim verbose tool descriptions** on MCP servers you control. 2026-03 Claude Code builds cap server instructions at 2KB but per-tool descriptions still add up.
6. **Code Mode** (emerging). Instead of exposing every tool, the agent writes a short orchestration script that the gateway executes in a sandbox. Cloudflare: 2,500 endpoints collapsed to 2 tools (~1k tokens). Anthropic Drive-to-Salesforce demo: 150k → 2k tokens (98.7%). 50-90% input-token reductions commonly reported.

## The "zero MCP default" workflow

Recommended baseline:
- `~/.claude.json`: empty MCP list.
- Per-task, `/mcp add <server>` → do the work → `/mcp remove <server>`.
- Keep only evergreen servers (e.g., `context7` for docs, `github` if you live in PRs) permanently enabled.

## Caveats

- Disabling MCP servers mid-session still keeps any already-started tool context in the conversation. For a full reset use `/clear` after disabling.
- MCP schemas are not invalidated by prompt-cache when the set changes; a config edit causes one cache miss.

## Sources

- [[mindstudio-mcp-token-overhead]] — MindStudio analysis with per-server ranges
- [[claude-code-token-optimization-2026]] — community synthesis
