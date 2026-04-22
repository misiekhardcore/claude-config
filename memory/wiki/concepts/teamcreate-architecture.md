---
name: TeamCreate Architecture
description: How Agent Teams are structured in Claude Code — lead, teammates, shared task list, mailbox. What loads into each teammate, operational constraints, and cost implications.
type: concept
tags: [claude-code, agent-teams, teamcreate, architecture]
status: current
created: 2026-04-22
updated: 2026-04-22
confidence: EXTRACTED
evidence:
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-costs-docs]]"
uses:
  - "[[subagent-spawn-mechanics]]"
related:
  - "[[subagent-spawn-mechanics]]"
  - "[[subagent-vs-teamcreate-rubric]]"
  - "[[agent-scaling-empirical-evidence]]"
  - "[[hierarchical-agent-decomposition]]"
  - "[[multiskill-workflow-patterns]]"
sources:
  - "[[claude-code-agent-teams-docs]]"
  - "[[claude-code-costs-docs]]"
  - "[[ClaudeFast Agent Teams Guide]]"
---

# TeamCreate Architecture

TeamCreate spawns a **team** of Claude Code sessions that coexist, share a task list, and message each other directly. This is distinct from the Task-tool subagent pattern ([[subagent-spawn-mechanics]]): teammates are long-lived peers, not disposable workers.

## Gating

- **Flag**: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in `settings.json` or env.
- **Version**: Claude Code v2.1.32 or later.
- **Released**: 2026-02-05 with Opus 4.6.
- **Status**: experimental.

Without the flag, `TeamCreate` is unavailable. The user's CLAUDE.md should document this prerequisite (as claude-workflow does via `_shared/composition.md`).

## Components (Official Anthropic Table)

| Component | Role |
|---|---|
| **Team lead** | The main Claude Code session. Creates the team, spawns teammates, coordinates work. Fixed for the team's lifetime. |
| **Teammates** | Independent Claude Code instances with their own context windows. Spawned by the lead. |
| **Task list** | Shared on disk at `~/.claude/tasks/{team-name}/`. Dependencies tracked; file locking prevents race conditions on claims. |
| **Mailbox** | Messaging system. Any teammate can message any other by name, or broadcast. SendMessage tool. |

Team config lives at `~/.claude/teams/{team-name}/config.json`. Claude generates and maintains it; do not hand-edit.

## What Loads Into Each Teammate (Verbatim)

> Each teammate has its own context window. When spawned, a teammate loads the same project context as a regular session: CLAUDE.md, MCP servers, and skills. It also receives the spawn prompt from the lead. The lead's conversation history does not carry over.

So per teammate:
- **CLAUDE.md** — project and global, loaded
- **MCP servers** — user and project config, loaded
- **Skills** — user and project, loaded
- **Spawn prompt** — the message the lead sends at creation
- **NOT loaded**: the lead's conversation history, the lead's files-read cache, the lead's intermediate tool results

This is why each teammate costs roughly the same baseline as a fresh session. N teammates ≈ N × single-session baseline.

## Subagent Definitions as Teammates

The lead can spawn a teammate using a subagent definition name. When this happens:
- The definition's `tools:` allowlist and `model:` frontmatter apply.
- The definition body is **appended to** the teammate's system prompt (not replacing it).
- Team-coordination tools (`SendMessage`, task tools) are always available, even if `tools:` restricts everything else.
- **Caveat** (officially documented): `skills:` and `mcpServers:` frontmatter fields in the subagent definition are **ignored** — teammates always load skills/MCP from project and user settings.

## Operational Constraints

- **One team per session** — a lead can only manage one team at a time.
- **No nested teams** — teammates cannot spawn their own teams or teammates.
- **Lead is fixed** — the session that created the team remains lead; cannot transfer leadership.
- **Permissions set at spawn** — all teammates inherit the lead's permission mode. Per-teammate changes possible after spawn, but not at spawn time.
- **No session resumption for in-process teammates** — `/resume` and `/rewind` don't restore them.
- **Shutdown is slow** — teammates finish their current request/tool call before exiting.
- **Split panes** require tmux or iTerm2; in-process mode works anywhere.

## Communication Patterns

- **Automatic idle notification**: when a teammate stops, the lead is notified.
- **Automatic message delivery**: no polling needed.
- **Broadcast**: send-to-all is available but "use sparingly, as costs scale with team size" (official).
- **Plan-approval flow**: lead can require teammates to plan in read-only mode; lead approves or rejects with feedback.

## Cost Implications

- **Each teammate = full Claude instance** → N teammates ≈ N × baseline context.
- **~7× multiplier** (Anthropic /en/costs) for typical plan-mode teams vs a single session.
- **Idle teammates still consume tokens** — clean up when done.
- **Mailbox traffic** adds tokens proportional to message volume.
- **Broadcasts** are N-way message sends — cost explicitly flagged in official docs.

See [[claude-code-costs-docs]] for the official cost guidance and [[agent-scaling-empirical-evidence]] for when the multiplier is worth paying.

## Best-Practice Sizing (From Official Docs)

- Start with **3–5 teammates**.
- Target **5–6 tasks per teammate** for productive throughput.
- Example: 15 independent tasks → 3 teammates.
- Scale up only when work genuinely benefits from simultaneity.

## Suggested Patterns (From Official Docs)

- **Parallel code review**: each teammate reviews a different lens (security / perf / test coverage).
- **Adversarial hypothesis debate**: 5 teammates test competing root-cause theories and try to disprove each other.
- **Cross-layer coordination**: frontend, backend, tests — each teammate owns one layer.

## Related

- [[subagent-spawn-mechanics]] — the contrast pattern (one-shot, report-back)
- [[subagent-vs-teamcreate-rubric]] — when to pick which
- [[agent-scaling-empirical-evidence]] — Google DeepMind + Princeton NLP data on multi-agent scaling
- [[multiskill-workflow-patterns]] — how linear/parallel shapes map onto these primitives
