---
name: Microsoft Agent Framework
description: Microsoft's multi-agent orchestration framework with explicit handoff routing rules — triage agents, start agents, HandoffBuilder with typed edges
type: entity
tags: [orchestration, multi-agent, framework]
status: current
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-19
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[agent-handoff-artifact-pattern]]"
  - "[[seed-brief-pattern]]"
---

# Microsoft Agent Framework

Multi-agent orchestration framework by Microsoft. Most relevant for claude-workflow: the **Handoff orchestration pattern** with explicit routing rules and triage-first design (Source: [[Microsoft Agent Framework Handoff Workflows]]).

## Handoff Pattern Core Concepts

- **Triage agent** carries the initial user brief and routes to specialists.
- **Start agent** is designated in the `HandoffBuilder`.
- **Handoff edges** define which agent can transfer to which. Edges are typed: e.g., "only the return agent can hand off to the refund agent; all specialists can hand off back to triage."
- **One agent active at a time.** No shared scratchpad; no broadcast.

Claim: ~40% faster case resolution reported at HCLTech via dynamic agent handoff (Source: [[Beam Multi-Agent Orchestration Patterns]]). Mark low-confidence — single vendor data point.

## When to Use (Per the Framework Docs)

- Tasks needing specialized knowledge where the number/order of agents can't be predetermined
- Expertise requirements that emerge during processing
- Multiple-domain problems where specialists operate one at a time
- Logical signals that indicate an agent has reached capability limits

## Mapped to `claude-workflow`

- **`/discovery` as triage**: the Scope Assessment phase triages Lightweight / Standard / Deep. Routing rules are static (mode → team composition), unlike Microsoft's runtime routing.
- **Explicit routing edges**: claude-workflow's phase order (discovery → define → implement) is a three-edge DAG, not a runtime-routed graph.
- **No dynamic handoff back**: once a phase is done, you don't route back. Microsoft's pattern allows "all specialists can hand off back to triage"; claude-workflow does not.

This reflects a deliberate choice: claude-workflow prefers **predictable phase gates with user approval** over runtime routing. Lower autonomy, higher control.

## Failure Modes (From the Framework Docs)

- **Infinite handoff loops** — number-one failure mode. A → B → C → A with no owner.
- **Context loss at each transfer** — compounds over depth.
- **Fragmented agents kill ROI** — unification requires strict, predictable handoff protocols and API contracts.

## Links

- [Microsoft Learn: Handoff Workflows](https://learn.microsoft.com/en-us/agent-framework/user-guide/workflows/orchestrations/handoff)
- [Azure Architecture Center: AI Agent Orchestration Patterns](https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns)

## Related

- [[multiskill-workflow-patterns]] — Handoff is Microsoft's version of the Branch pattern
- [[agent-handoff-artifact-pattern]] — Microsoft uses in-memory handoff; claude-workflow uses durable artifacts
- [[seed-brief-pattern]] — triage agent is effectively a seed-brief carrier
