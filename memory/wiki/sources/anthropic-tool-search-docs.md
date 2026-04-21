---
type: source
title: "Anthropic Tool Search Tool Documentation"
source_type: official-docs
author: Anthropic
date_published: 2025-11
url: https://platform.claude.com/docs/en/agents-and-tools/tool-use/tool-search-tool
source_reliability: high
accessed: 2026-04-21
tags:
  - anthropic
  - tool-use
  - tokens
  - mcp
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "Tool Search preserves 191,300 tokens vs 122,800 traditional — 85% context saving"
  - "Deferred tools are not in system-prompt prefix; loaded as tool_reference blocks inline, prefix cache preserved"
  - "regex variant uses Python re.search; BM25 variant uses natural language"
  - "Opus 4 MCP-eval: 49% → 74%; Opus 4.5: 79.5% → 88.1%"
related:
  - "[[tool-search-tool-deferred-loading]]"
  - "[[mcp-tool-overhead]]"
---

# Anthropic Tool Search Tool Documentation

Canonical reference for the Tool Search Tool mechanism that underlies Claude Code's deferred MCP loading.

## Summary

Official platform docs describing the `tool_search_tool_regex_20251119` and `tool_search_tool_bm25_20251119` tools, the `defer_loading: true` flag, and the expand-as-tool_reference mechanism. Used downstream by Claude Code to manage MCP schema bloat.

## Key contributions

- Full mechanism description in [[tool-search-tool-deferred-loading]].
- Accuracy gains are documented, not just token savings — contradicts the assumption that more context = better tool selection.
- Prefix-cache preservation is explicit: deferred-tool schemas are inline in conversation, not the system prompt, so cache is not invalidated.

## Caveats

Platform-level feature; Claude Code surfaces it but underlying API behaviour may diverge on Bedrock/Vertex deployments. See open issues #25212 (Bedrock) and #32485 (custom agent discoverability).
