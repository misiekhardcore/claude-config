---
type: source
title: "Claude Code MCP Servers and Token Overhead"
source_type: community-guide
author: MindStudio
date_published: 2026-Q1
url: https://www.mindstudio.ai/blog/claude-code-mcp-server-token-overhead
source_reliability: medium
accessed: 2026-04-21
tags:
  - claude-code
  - mcp
  - tokens
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "Single MCP tool definition: 100-500 tokens"
  - "10-tool server: 1.5-3k tokens per turn"
  - "30-tool server: 5-8k tokens per turn"
  - "5-server / 58-tool setup: ~55k baseline"
  - "Jira MCP alone: ~17k tokens"
  - "Zero-MCP default is the right baseline"
related:
  - "[[mcp-tool-overhead]]"
  - "[[tool-search-tool-deferred-loading]]"
---

# Claude Code MCP Servers and Token Overhead

MindStudio's blog analysis of per-server token costs.

## Summary

Provides concrete token ranges for MCP tool definitions and a "zero MCP by default" workflow recommendation.

## Key contributions

- **Per-server token cost table** used in [[mcp-tool-overhead]].
- **Zero-default policy**: keep `~/.claude/settings.json` and `~/.claude.json` minimal; add servers per task via `/mcp add`.
- **Audit cadence**: disable any server not used in 2 weeks.

## Caveats

Exact per-server numbers are ranges, not measurements of specific server versions. Newer MCP spec revisions (late 2025) support `compactDescription` field that may lower the numbers materially.
