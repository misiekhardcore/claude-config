### **Rules Lane: CLAUDE.md, Auto-Memory, Imports**

**Total items audited:** 8 sections + 2 memory files

| Item | Classification | Status |
|------|-----------------|--------|
| Behavior Rules (4) | **Current** | All fundamental; no staleness |
| Implementation Rules (4) | **Current** | All valid; one minor clarity issue |
| Conversation Rules (4) | **Current** | Clear and sound |
| Repository Awareness (2) | **Current** | Essential for multi-project workspace |
| GitHub Authoring (2) | **Current** | Skills auto-activate on trigger phrases |
| Scope Discipline (7) | **Current** | All rules remain sound |
| Documentation Hygiene (3) | **Current** | Foundational practices |
| Compact Instructions (3) | **Current** | Clear guidance |
| ~~**MEMORY.md**~~ | ~~**Stale**~~ | ~~25 days old; feedback with no ongoing relevance~~ — superseded by [#93](https://github.com/misiekhardcore/claude-workflow/issues/93): Rules lane removed; auto-memory out of `/prune` scope |
| ~~**feedback_allowed-tools-frontmatter.md**~~ | ~~**Stale**~~ | ~~25 days old; point-in-time lesson learned~~ — fact is still load-bearing (`allowed-tools:` actively used across `claude-obsidian/skills/*`); kept by decision |

**Key findings:**
- CLAUDE.md is well-maintained (last edited 2026-05-10, 2 days ago)
- All rules cross-referenced against current settings.json and available tools ✓
- **Minor issue:** Line 15 slightly conflates auto-loaded memory vs optional vault search. Suggested clarification below.

---

### **Authoring Lane: CLAUDE.md, Skill.md Files**

**Total items audited:** 3 files, 79 lines total

| File | Length | Issues | Severity |
|------|--------|--------|----------|
| `/claude-config/CLAUDE.md` | 48 lines (cap: 200) | 1 unpaired "Don't" (line 36) | Minor |
| `/skills/load-issue-guidelines/SKILL.md` | 15 lines (cap: 50) | None | — |
| `/skills/load-pr-guidelines/SKILL.md` | 16 lines (cap: 50) | None | — |

**Detailed finding:**
- **CLAUDE.md, line 36:** "Don't ship stretch goals or speculative features in proposal/doc PRs." lacks a paired positive within 3 lines. Next statement (line 37) shifts to a different topic.
- **Suggested fix:** Add "Do scope PRs to the explicit request only." or similar paired statement.

**Passes all other checks:**
- ✓ All files under length caps
- ✓ No warning-stack issues (<10 "Don't" lines per file)
- ✓ No architecture smell (no large Overview/Architecture sections)
- ✓ No decision-table candidates (no ≥3-branch conditional prose)

**Overall:** Strong authoring quality; 1 minor pairing issue to fix.

---

### **Vault Lane: Obsidian Wiki Health**

**Vault status:** Healthy overall. Last lint audit: 2026-05-07 (5 days old, 325 pages scanned)

| Category | Finding | Priority |
|----------|---------|----------|
| ~~**Critical**~~ | ~~4 canvas asset refs broken~~ — 3 broken canvases deleted from `wiki/meta/archive/canvases/`; folder removed | ~~Fix this week~~ Done |
| **Large pages** | 6 pages >300 lines; 2 should consider split | Medium |
| **Dead links** | 51 unresolved (mostly assets, stubs, templates) | Low–Medium |
| **Orphan pages** | 78 total; 25 intentional, ~28 actionable | Medium (gradual linking) |
| **Missing fields** | Some pages lack `related:` field | Low |
| **Stale seeds** | 1 seed page >15 days old | Low |

**Actionable recommendations (this week):**
1. ~~Resolve 4 broken canvas asset references (delete canvases or restore assets)~~ Done — canvases deleted.
2. ~~Create stubs for 3 high-priority concepts: `progressive-disclosure`, `anthropic-skills`, `hook-template`~~ — `progressive-disclosure-*` and `hook-template-*` already exist in more specific form; `anthropic-skills` skipped by decision.
3. Link orphan seed pages from related pages (gradual, not urgent) — deferred; vault content rot is now `/lint`'s responsibility, not `/prune`'s (see [#93](https://github.com/misiekhardcore/claude-workflow/issues/93)).

**No blockers.** Vault supports continued use; cleanup is incremental.

---

## Recommended Actions

### ~~1. Fix unpaired "Don't" in CLAUDE.md (Immediate)~~ — Done.
**Location:** Line 36 of `/home/michal/Projects/claude-config/CLAUDE.md`

**Current:**
```
- Don't ship stretch goals or speculative features in proposal/doc PRs. Do rewrite the affected call sites cleanly when they're already in the diff.
```

**Suggested replacement:**
```
- Don't ship stretch goals or speculative features in proposal/doc PRs. Do scope PRs to the explicit request only.
```

**Rationale:** Pairs the prohibition with a positive directive within the same bullet.

---

### ~~2. Clarify auto-memory loading in CLAUDE.md (Low priority)~~ — Rejected: user kept original wording.
**Location:** Line 15 of `/home/michal/Projects/claude-config/CLAUDE.md`

**Current:**
```
- **Check existing memory.** Auto-memory is loaded by the harness automatically; the vault is not. Search `memory/wiki` (from the `claude-obsidian` plugin) and other `memory` docs for data related to the task at hand.
```

**Suggested revision:**
```
- **Check existing memory.** The harness auto-loads `/memory/` at session start. Optionally search `memory/wiki/` (from `claude-obsidian` plugin) when deeper context is needed. Never pre-read the vault; search just-in-time only.
```

**Rationale:** Clarifies what is auto-loaded vs optional, and reinforces just-in-time principle.

---

### ~~3. Archive stale memory files (Immediate)~~ — Superseded by [#93](https://github.com/misiekhardcore/claude-workflow/issues/93): auto-memory is out of `/prune` scope going forward; `feedback_allowed-tools-frontmatter.md` kept (load-bearing fact).
**Files to remove:**
- `/home/michal/.claude/projects/-home-michal-Projects-claude-config/memory/MEMORY.md` (single entry, 25 days old, no ongoing relevance)
- `/home/michal/.claude/projects/-home-michal-Projects-claude-config/memory/feedback_allowed-tools-frontmatter.md` (point-in-time feedback, stale)

**Action:**
- Delete both, OR
- Archive to `memory/archive/` with a note that they can be recovered if the same confusion resurfaces.

**Rationale:** These are lessons learned from 2026-04-17 sessions with no ongoing decision-making weight. Fresh memories created in-session are more reliable.

---

### ~~4. Resolve 4 broken canvas assets (This week)~~ — Done.
**Location:** 3 canvases in `memory/wiki/canvases/`
- `claude-obsidian-presentation.canvas`
- `main.canvas`
- `welcome.canvas`

**Action:** Either restore missing attachments or delete the broken canvases.

---

## Summary Table

| Lane | Total Items | Current | Stale | Superseded | Unclear | Actions |
|------|-------------|---------|-------|-----------|---------|---------|
| **Rules** | 8 + 2 files | 8 | 2 | 0 | 0 | ~~Archive 2 stale memory files; clarify line 15~~ — both items resolved (see [#93](https://github.com/misiekhardcore/claude-workflow/issues/93) / decision above) |
| **Authoring** | 3 files | 2 | 0 | 0 | 1 | ~~Fix unpaired "Don't" on line 36 CLAUDE.md~~ Done |
| **Vault** | 325 pages | ✓ Healthy | — | — | — | ~~Fix 4 canvas assets~~ Done; ~~create 3 concept stubs~~ skipped by decision |

**Overall health:** Strong. Rules and authoring are well-maintained; vault is healthy with incremental cleanup recommended.