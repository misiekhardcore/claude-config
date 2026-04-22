---
type: meta
title: "Hot Cache"
updated: 2026-04-22T00:00:00
created: 2026-04-17
tags:
  - meta
  - hot-cache
status: evergreen
confidence: EXTRACTED
evidence: []
related:
  - "[[index]]"
  - "[[log]]"
  - "[[Wiki Map]]"
  - "[[getting-started]]"
---

# Recent Context

Navigation: [[index]] | [[log]] | [[overview]]

Target: ~500 words. Older entries live in [[log]].

## Last Updated

- 2026-04-22: **claude-workflow wiki pages refreshed**. [[claude-workflow-phase-shape]] updated to reflect current plugin: Lightweight scope added to `/discovery` and `/define`; Deep adds critique team; define output section is `## Implementation plan` (not `## /define`). [[claude-workflow-composition-codification]] staleness flag removed — [[seed-brief-pattern]] already uses canonical `_shared/composition.md` fields.
- 2026-04-22: **resolve-vault.sh cron fallback** (claude-obsidian #31/PR #32). `jq`/`python3` read of `settings.local.json` `pluginConfigs[*claude-obsidian*].options.vault_path`; resolution order arg > CWD > settings > error. See [[out-of-session-plugin-config-access]].
- 2026-04-22: **Subagents vs TeamCreate research** (claude-workflow #30). ~7× multiplier verified live on claude.com/docs/en/costs; teammate loads full CLAUDE.md+MCP+skills (no lead history). Primary pivot = **mid-task communication**, not file count. Sequential tasks degrade 39–70% under MAS (DeepMind, arXiv:2512.08296). Sweet spot 3–5 teammates. See [[Research: Subagents vs TeamCreate Decision Rubric]], [[subagent-vs-teamcreate-rubric]].
- 2026-04-22: **Citation audit**: Princeton NLP "64% of benchmarks" claim (via [[Addy Osmani Code Agent Orchestra]]) flagged as unverified; downstream pages softened; see [[princeton-nlp-64-percent-unverified]]. Osmani source downgraded to `source_reliability: low`.
- 2026-04-21: **Claude Code token optimization research.** P1 actions: trim `Projects/CLAUDE.md` <200 lines, trim `hot.md` to ~30 lines, disable redundant browser MCPs, `ENABLE_TOOL_SEARCH=auto:5`. ~35–45% reduction expected. See [[Research Claude Code Token Optimization]], [[token-audit-misiekhardcore]].
- 2026-04-21: **claude-obsidian migrated** to `misiekhardcore/claude-obsidian`, install ID `claude-obsidian@claude-obsidian`. See [[claude-plugin-userconfig-schema]], [[claude-hook-template-variable-expansion]].

## Plugin State

- **Install ID**: `claude-obsidian@claude-obsidian` (misiekhardcore fork)
- **Vault**: `memory/` in `misiekhardcore/claude-config`
- **Install flow**: `claude plugin marketplace add misiekhardcore/claude-obsidian` then `claude plugin install claude-obsidian@claude-obsidian`
- **Skills**: 10 (wiki, wiki-ingest, wiki-query, wiki-lint, save, autoresearch, canvas, defuddle, obsidian-bases, obsidian-markdown)
- **Hooks**: SessionStart, PostCompact, PostToolUse, Stop

## Style Preferences

- No em dashes or `--` as punctuation. Hyphens in compound words are fine.
- Short responses, no trailing summaries.
- Parallel tool calls when independent.
