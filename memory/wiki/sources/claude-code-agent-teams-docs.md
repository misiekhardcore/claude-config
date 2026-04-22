---
type: source
title: "Claude Code Agent Teams Documentation"
source_type: official-docs
author: Anthropic
date_published: 2026-04
url: https://code.claude.com/docs/en/agent-teams
source_reliability: high
accessed: 2026-04-22
tags:
  - claude-code
  - agent-teams
  - teamcreate
  - official
status: current
confidence: EXTRACTED
evidence: []
key_claims:
  - "Each teammate has its own context window and loads the same project context as a regular session: CLAUDE.md, MCP servers, and skills. Lead's conversation history does not carry over."
  - "Start with 3-5 teammates for most workflows. Having 5-6 tasks per teammate keeps everyone productive."
  - "Subagents report results back to the main agent only; teammates message each other directly."
  - "No nested teams. One team per session. Lead is fixed. Permissions set at spawn."
  - "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1 enables the feature; requires v2.1.32+"
related:
  - "[[teamcreate-architecture]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[claude-code-sub-agents-docs]]"
  - "[[claude-code-costs-docs]]"
---

# Claude Code Agent Teams Documentation

Canonical Anthropic reference for the experimental Agent Teams feature (TeamCreate + SendMessage + shared task list).

## Summary

Official `/en/agent-teams` page. Covers when to use agent teams vs subagents, how to enable the feature, how to start/control a team, architecture, context-and-communication model, known limitations, and best practices.

## Direct Quotes Pinned to the Wiki

**On context initialization (the critical quote):**
> Each teammate has its own context window. When spawned, a teammate loads the same project context as a regular session: CLAUDE.md, MCP servers, and skills. It also receives the spawn prompt from the lead. The lead's conversation history does not carry over.

**On subagent-definition reuse as teammate:**
> The `skills` and `mcpServers` frontmatter fields in a subagent definition are not applied when that definition runs as a teammate. Teammates load skills and MCP servers from your project and user settings, the same as a regular session.

**On team sizing:**
> Start with 3-5 teammates for most workflows. This balances parallel work with manageable coordination. Having 5-6 tasks per teammate keeps everyone productive. If you have 15 independent tasks, 3 teammates is a good starting point.

**On the subagents-vs-teams choice:**
> Use subagents when you need quick, focused workers that report back. Use agent teams when teammates need to share findings, challenge each other, and coordinate on their own.

## Architecture Components (Verbatim Table)

| Component | Role |
|---|---|
| Team lead | The main Claude Code session that creates the team, spawns teammates, and coordinates work |
| Teammates | Separate Claude Code instances that each work on assigned tasks |
| Task list | Shared list of work items that teammates claim and complete (`~/.claude/tasks/{team-name}/`) |
| Mailbox | Messaging system for communication between agents (SendMessage tool) |

## Known Limitations (Verbatim)

- No session resumption with in-process teammates
- Task status can lag
- Shutdown can be slow
- One team per session
- No nested teams
- Lead is fixed
- Permissions set at spawn
- Split panes require tmux or iTerm2

## Use Case Examples Quoted

- Parallel code review (security / performance / test-coverage reviewer)
- Adversarial hypothesis debate (5 teammates trying to disprove each other)
- Cross-layer coordination (frontend/backend/tests each owned by a teammate)

## Best-Practice Guidance

- Give teammates enough context in the spawn prompt (they do NOT inherit lead conversation)
- Start with research/review tasks before parallel implementation
- Avoid file conflicts — each teammate owns a disjoint file set
- Monitor and steer; don't leave unattended
- Use hooks (`TeammateIdle`, `TaskCreated`, `TaskCompleted`) for quality gates

## Caveats

Feature is experimental and disabled by default. Flag: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`. Requires Claude Code v2.1.32+. Behavior may change between versions.
