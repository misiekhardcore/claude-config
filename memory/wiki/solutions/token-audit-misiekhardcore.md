---
type: solution
title: "Token Audit — misiekhardcore config"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - tokens
  - audit
  - misiekhardcore
status: current
confidence: INFERRED
evidence:
  - "[[claude-code-system-prompt-composition]]"
  - "[[sessionstart-hook-context-injection]]"
  - "[[mcp-tool-overhead]]"
  - "[[claude-md-sizing]]"
related:
  - "[[Research Claude Code Token Optimization]]"
---

# Token Audit — misiekhardcore config

Concrete optimization plan for Michal's setup. Baseline: **9k system prompt + 11k system tools = 20k pre-conversation overhead**. Target: **~12-13k (35-40% reduction)**.

## Measured baseline

| Source | Lines | Est. tokens |
|---|---|---|
| `~/.claude/CLAUDE.md` (global) | 41 | ~500 |
| `/home/michal/Projects/CLAUDE.md` (project) | 219 | ~2,800 |
| `~/.claude/memory/wiki/hot.md` (auto-read via claude-obsidian bootstrap) | 133 | ~2,800 |
| `superpowers` SessionStart hook (using-superpowers skill body) | ~150 | ~2,500 |
| MCP server instructions (`claude-in-chrome`, `mdn`, `context7`) | — | ~600 |
| Auto-memory `MEMORY.md` | 3 | ~80 |
| Harness fixed overhead | — | ~2,000 |
| **Total system prompt** | | **~11k** (observed 9k — some deferred) |

12 enabled plugins contribute to system tools:
- `chrome-devtools-mcp`, `claude-in-chrome` (both heavyweight, ~30+ tools each)
- `github`, `context7`, `skill-creator`, `superpowers`, `worktrunk`, `claude-hud`
- `claude-obsidian`, `claude-workflow`
- Plus `playwright` MCP visible in deferred list (~20 tools)
- Plus mdn (3 tools), Atlassian/Asana/Box/Notion/Linear/... auth tools (deferred)

## Priority actions

### P1 — Highest ROI, lowest effort

1. **Trim `/home/michal/Projects/CLAUDE.md` from 219 → ~120 lines.** Official target is <200. Extract long blocks (tech stack per project table, Docker/Git conventions, full tests spec) into `Projects/REFERENCE.md` and replace with pointers. **Est. saving: ~1.0-1.5k tokens/turn.**
2. **Trim `wiki/hot.md` from 133 → 30 lines.** The skill's own spec caps hot.md at ~500 words. Current content mixes vscode-gcode, camunda epics, and LLM-wiki research — archive all pre-2026-04-19 entries into `wiki/log.md` (where most already are) and trim the top section to the last 3-5 active threads. **Est. saving: ~1.5-2k tokens/turn** (only when claude-obsidian plugin is active and bootstrap ran).
3. **Disable `superpowers` when not actively used.** The SessionStart hook injection is ~2.5k tokens on every turn. Toggle via `~/.claude/settings.json`:
   ```json
   "superpowers@claude-plugins-official": false
   ```
   Re-enable for sessions that need its discipline skills (TDD, systematic-debugging, verification). **Est. saving: ~2.5k tokens when disabled.**

Combined P1: **~5-6k tokens off system prompt**, dropping from 9k → ~3-4k.

### P2 — Medium effort, big upside on tools counter

4. **Audit enabled MCP servers.** Run `/mcp` at start of next session. Toggle off anything unused for this session:
   - `chrome-devtools-mcp` and `claude-in-chrome`: keep only one of these enabled at a time. Both duplicate the same browser-automation surface. Savings: ~2-3k tokens/turn.
   - `playwright`: likely not used in normal coding sessions. Savings: ~1-2k tokens/turn.
   - Remote MCP auth tools (Asana/Box/Atlassian/Notion/Linear/HubSpot/Intercom/Canva/monday/Camunda Docs/Google Drive): currently deferred so cost is just tool-name bytes, but disabling unused ones reduces even the name surface.
5. **Set `ENABLE_TOOL_SEARCH=auto:5`** in `~/.claude/settings.json` env block. Forces more aggressive deferral of MCP tools. Effective only if total tool schema exceeds 5% of context window (~10k tokens), which the current setup almost certainly does.
   ```json
   "env": {
     "ENABLE_TOOL_SEARCH": "auto:5",
     ...
   }
   ```

Combined P2: **~3-5k tokens off system tools**, dropping from 11k → ~6-8k.

### P3 — Structural, higher effort

6. **Move project CLAUDE.md workflow content into skills.** The current 219-line file embeds: full tech-stack reference tables, build commands per project, test-framework guidance, Git conventions. These can become `~/.claude/skills/*` with pushy descriptions so Claude auto-invokes when touching the relevant subdir.
7. **Consider per-project vault for claude-obsidian.** Cross-project hot.md accumulates noise from unrelated domains. Split into project-scoped `.claude/wiki/` + one shared cross-project vault. See [[per-project-knowledge]].
8. **Compact-instruction block in CLAUDE.md.** Add a `## Compact instructions` stanza to project CLAUDE.md to bias `/compact` toward preserving test output + decisions.

## Already correct (do not change)

- `CLAUDE_CODE_SUBAGENT_MODEL: "haiku"` — cheapest subagent model already set.
- `claude-code-setup`, `claude-md-management`, `code-simplifier` already disabled.
- Global `~/.claude/CLAUDE.md` at 41 lines — well under the 100-line hard cap.
- `rtk-rewrite.sh` PreToolUse hook — converts verbose CLI to token-efficient RTK, reported 60-90% tool-output savings.
- `log-session-cost.sh` SessionEnd — audit trail, no per-turn cost.
- `DISABLE_TELEMETRY=1` — reduces ambient traffic.

## Verification

After each change, run `/context` and compare:
- System prompt line
- System tools line
- Memory files line

Track over one week. Expected combined reduction: **~35-45% on system+tools baseline** without giving up functionality.

## Open questions

- Does `ENABLE_TOOL_SEARCH=auto:N` accept `0` to force deferral of everything? Changelog is silent. Test empirically.
- Is there a documented way to measure per-plugin contribution to system prompt? Currently only possible by toggling plugins off and diffing `/context`.
- Can SessionStart hook content be gated on a predicate (e.g. only inject superpowers body if session contains `/plan` or TDD tasks)? No known mechanism; upstream feature request worth filing.
