---
name: Microsoft Agent Framework Handoff Workflows
description: Official Microsoft Learn documentation for the Handoff orchestration pattern — HandoffBuilder, start agent, typed handoff edges
type: source
source_type: official-documentation
author: Microsoft
date_published: 2026
url: https://learn.microsoft.com/en-us/agent-framework/user-guide/workflows/orchestrations/handoff
source_reliability: high
key_claims:
  - Handoff pattern enables dynamic delegation between specialists
  - Triage agent carries initial brief and routes
  - Explicit handoff edges define routing rules
  - Only one agent is active at a time; no central coordinator
tags: [orchestration, multi-agent, handoff, official-docs]
status: developing
confidence: EXTRACTED
updated: 2026-04-19
created: 2026-04-19
related:
  - "[[Microsoft Agent Framework]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[seed-brief-pattern]]"
evidence: []
---

# Microsoft Learn — Agent Framework Handoff Workflows

Official documentation for Microsoft's Handoff orchestration pattern. Confidence: high (first-party framework docs).

## Key Claims

1. **Handoff definition**: "Each agent can assess the task at hand and decide whether to handle it directly or transfer it to a more appropriate agent."
2. **Triage-first**: handoff flows typically start with a triage agent.
3. **Explicit routing rules**: HandoffBuilder participants with typed edges. Example: "only the return agent can hand off to the refund agent; all specialists can hand off back to triage."
4. **One agent active at a time**: no shared scratchpad.

## Relevance to claude-workflow

The DAG-with-gates shape of claude-workflow (`/discovery → /define → /implement`) is a simpler, more static cousin of Microsoft's runtime-routed handoff. claude-workflow trades runtime autonomy for predictable phase gates with user approval. See [[Microsoft Agent Framework]] for the mapping.

## Related

- [[Microsoft Agent Framework]] — entity page
- [[agent-handoff-artifact-pattern]] — claude-workflow's artifact-based variant
