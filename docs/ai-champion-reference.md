# AI Champion Reference

Curated from [urbanisierung/ai-kit](https://github.com/urbanisierung/ai-kit) — the actionable items
most relevant to our setup. Focus: levels 6-9 (we already cover levels 0-5 via CLAUDE.md, hooks, skills, and teams).

Source: `docs/ai-champion.md` in the ai-kit repo (compiled from 130+ weeklyfoo newsletter issues).

---

## Level 6 — Token Management and Observability

We already have RTK (`rtk-rewrite.sh` hook) and session cost logging (`log-session-cost.sh`).
Additional techniques worth evaluating:

- **`rtk discover`** — analyzes Claude Code history and finds commands that could have been
  rewritten but weren't. Run periodically to find missed token savings.
- **`rtk gain --history`** — shows per-command savings breakdown. Useful for auditing which
  commands benefit most from compression.
- **Context budget rule of thumb**: keep CLAUDE.md under 100 lines; use `@imports` for long
  reference docs. Every line is injected into every session (~20 tokens/line).

## Level 7 — Hooks and Persistent Memory

We have PreToolUse (RTK) and SessionEnd (cost logging). Additional hook patterns:

- **PostToolUse lint hook** — run linter on files Claude just wrote. Catches issues mid-session
  instead of at commit time. Example:
  ```bash
  # In PostToolUse hook, check if tool was Edit/Write and file is TS:
  if [[ "$TOOL_INPUT" == *.ts || "$TOOL_INPUT" == *.tsx ]]; then
    npx biome check "$TOOL_INPUT" 2>&1 | tail -10
  fi
  ```

## Level 8 — Remote Setup

- **Headless agent execution** — run Claude Code sessions on remote machines via SSH or
  cloud VMs. Useful for long-running tasks that shouldn't block your local machine.
- **`opencode-ai`** — headless agent server supporting 75+ model providers. Alternative
  execution environment for tasks that don't need interactive feedback.
- **Hermes Agent** — persistent agent with learning loop + messaging gateway (Telegram,
  Discord, Slack). Can run as a daemon and accept tasks via chat.

## Level 9 — Parallel Agents

We already use agent teams (`CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`, `teammateMode: tmux`).
Additional patterns:

- **Dedicated research teams** — before implementation, dispatch a team where each teammate
  analyzes a different area (codebase structure, external APIs, prior art). Synthesize
  findings before writing code.
- **QA teams** — split acceptance criteria across teammates, cross-verify findings via
  peer-to-peer messages. Don't let the same agent implement and verify.
- **Review teams** — one teammate on correctness, another on style/standards. Discuss
  disagreements via messages before converging on unified review.
- **DeerFlow** (ByteDance) — multi-agent research framework. Docker-based, uses LangGraph
  for orchestration. Good for deep research tasks that benefit from multiple perspectives.

---

## Tool Reference

| Tool | Purpose | Install | Status |
|------|---------|---------|--------|
| RTK | Token compression (60-90% savings) | `curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/master/install.sh \| sh` | Installed |

---

## Maturity Model (Bassim Eledath)

For context — where our setup sits:

| Level | Name | Our coverage |
|-------|------|-------------|
| 1 | Tab complete | N/A (CLI-based) |
| 2 | Agent IDE | N/A (CLI-based) |
| 3 | Context engineering | CLAUDE.md, RTK.md, project CLAUDE.md files |
| 4 | Compounding engineering | Feature workflow (8 phases), agent teams |
| 5 | MCP and Skills | context7, chrome-devtools, playwright, superpowers skills |
| 6 | Harness engineering | RTK hooks, cost logging, linter hooks (partial) |
| 7 | Background agents | Agent teams in tmux, teammate dispatch |
| 8 | Autonomous agent teams | Research/QA/review team patterns (in CLAUDE.md workflow) |

> Focus area: solidify level 6 (run rtk discover regularly) and
> level 7 (add vault-sync hooks for durable memory).
