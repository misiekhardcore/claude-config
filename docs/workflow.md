# Development Workflow

A step-by-step walkthrough of the feature lifecycle in this repo: which skill runs when, what it expects as input, and what it leaves behind. The rules themselves live in `CLAUDE.md` and in each `skills/<name>/SKILL.md`; this doc stitches them into a single narrative so a newcomer doesn't have to grep 15 files.

## Workflow paths

Pick the lightest path that fits the task (from `CLAUDE.md`):

| Size | Path |
|---|---|
| Trivial fix | `/implement` |
| Medium feature | `/discovery` → `/implement` |
| Large feature / epic | `/discovery` → `/define` → `/implement` |

Handoff between phases uses the **GitHub issue body** as the durable artifact — see `skills/_shared/handoff-artifact.md` for the five-field structure (Acceptance Criteria, Constraints, Prior Decisions, Evidence, Open Questions). Within a phase, `./.claude/NOTES.md` is authoritative for in-flight state — see `skills/_shared/notes-md-protocol.md`. When context pressure mounts, follow `skills/_shared/compaction-protocol.md` (context editing first, sub-agent delegation second, `/compact` last).

## Quick visual

```
/discovery ──► (issue w/ AC + handoff) ──► /define ──► (issue w/ arch+design) ──► /implement
                                                                                       │
                                                                        ┌──────────────┼──────────────┐
                                                                        ▼              ▼              ▼
                                                                     /build  ──►   /review    ─►  /verify
                                                                        ▲              │              │
                                                                        └── fix-brief ◄┴──────────────┘
                                                                                       │ (both clean)
                                                                                       ▼
                                                                                   draft PR ──► /compound ──► /wrap-up
```

## Step 1 — `/discovery` (Opus, high effort)

- **File:** `skills/discovery/SKILL.md`
- **When:** Start of any non-trivial feature or bug. Triggered by prompts like "add X" or "fix Y".
- **Prerequisites:** A user-provided problem statement. Nothing else.
- **What it does:** Classifies scope (Lightweight / Standard / Deep), then dispatches:
  - `/describe` (`skills/describe/SKILL.md`) — a problem analyst + domain researcher interview the user and scan the codebase for existing patterns.
  - `/specify` (`skills/specify/SKILL.md`) — happy-path + edge-case analysts turn the problem statement into testable GIVEN/WHEN/THEN acceptance criteria.
  - On Deep scope, adds a flow analyst and adversarial questioner in parallel.
- **Outcome:** A GitHub issue with a problem statement and the five-field handoff block. **User approval is required** before moving on.
- **Hands off to:** `/define` (for large work) or `/implement` (for medium work).

## Step 2 — `/define` (Opus, high effort) — *skip for medium features*

- **File:** `skills/define/SKILL.md`
- **When:** After `/discovery`, for epics or architecturally significant work.
- **Prerequisites:** An approved issue from `/discovery` with acceptance criteria.
- **What it does:** Spawns research agents (codebase research + patterns/learnings scan against `memory/wiki/`, starting with `memory/wiki/hot.md` and `memory/wiki/index.md`), then dispatches:
  - `/architecture` (`skills/architecture/SKILL.md`) — codebase analyst + solution architect + devil's advocate converge on a technical approach, producing component diagrams, trade-off tables, and a sub-task dependency graph. Uses `/grill-me` (`skills/grill-me/SKILL.md`) to pin down open decisions with the user.
  - `/design` (`skills/design/SKILL.md`) — UX researcher + design proposer + a11y reviewer, only when the task has visual aspects. Produces prototypes, wireframes, and interaction flows.
- **Outcome:** The issue body is updated in place with a `## /define` section containing architecture and design decisions, plus any sub-issues and their dependency graph. **User approval is required** before `/implement`.
- **Hands off to:** `/implement`.

## Step 3 — `/implement` (Sonnet)

- **File:** `skills/implement/SKILL.md`
- **When:** After `/discovery` (medium) or `/define` (large); directly for trivial fixes.
- **Prerequisites:** An approved issue with acceptance criteria (plus architecture/design if it's a large feature).
- **What it does:** Orchestrates a `/build → /review → /verify` loop until both review and verify pass clean. Maximum 3 cycles before escalating to the user.
  1. **`/build`** (`skills/build/SKILL.md`, Sonnet) — creates a git worktree, initializes `./.claude/NOTES.md`, spawns an implementation team (TeamCreate only for 3+ parallelizable files), writes code test-driven, commits incrementally with semantic messages, and runs lightweight simplification scans every 2–3 tasks.
  2. **`/review`** (`skills/review/SKILL.md`, Sonnet high effort) — reviewers run in isolated context against the diff + AC only. Standard scope runs correctness + standards reviewers and conditionally activates security / performance / migration specialists based on diff content. Findings are merged, deduped, and confidence-scored. Reviewers report findings only — they do not fix.
  3. **`/verify`** (`skills/verify/SKILL.md`, Haiku) — a QA team runs the full verification chain (type-check, lint, unit tests, build, e2e) and checks every acceptance criterion with evidence. Reports pass/fail only — it does not fix.
  - If review or verify finds issues, a fix-brief (failing AC + file:line findings) is fed back to `/build`, then re-reviewed and re-verified.
- **Outcome:** A draft PR (`gh pr create --draft`) linking the issue (`Closes #N`), with a manual test section. All acceptance criteria met, review clean, verify clean.
- **Follow-up:** `/compound` runs to capture learnings.

## Step 4 — `/compound` (Sonnet)

- **File:** `skills/compound/SKILL.md`
- **When:** Automatically after a successful `/implement`, or when the user says "that worked".
- **Prerequisites:** A recently-completed fix or feature with reusable learnings.
- **What it does:** Files the learning into the Obsidian vault at `memory/wiki/` (Karpathy LLM Wiki pattern, via the `claude-obsidian` plugin). Ensures `memory/wiki/concepts/` exists, searches the vault for overlap (starting at `index.md` and `hot.md`, then drilling into `concepts/`, `entities/`, `sources/`), and either updates an existing note or writes a new one using either **Bug Track** (Problem / Symptoms / What Didn't Work / Solution / Why It Works / Prevention) or **Knowledge Track** (Context / Guidance / Why / When / Examples). Appends an entry to `memory/wiki/log.md` and performs a staleness check against related notes. When the `claude-obsidian` plugin is active, prefers the plugin's `/save` flow — the plugin keeps frontmatter, cross-links, and the index in sync automatically.
- **Outcome:** A durable wiki note at `memory/wiki/concepts/<Title Case Name>.md` with frontmatter matching `memory/WIKI.md` (type, domain, tags, related wikilinks, sources). Never auto-deletes or overwrites without flagging.

## Step 5 — `/wrap-up` (Sonnet) — *optional, end of session*

- **File:** `skills/wrap-up/SKILL.md`
- **When:** End of a long or complex session, or when transitioning between phases mid-work.
- **Prerequisites:** Session history with decisions and in-progress work.
- **What it does:** Reads `./.claude/NOTES.md`, identifies assumptions, uncertain decisions, scope changes, and follow-ups from the conversation, then drafts an update to the active issue body (never auto-applies).
- **Outcome:** An audit block the user can paste into the issue — Assumptions Made / Uncertain Decisions / Scope Notes / Follow-ups.

## Support step — `/resolve-pr-feedback` (Sonnet)

- **File:** `skills/resolve-pr-feedback/SKILL.md`
- **When:** After a PR gets review comments.
- **What it does:** Fetches all review threads, triages them, spawns a fix team (one agent per file group, no conflicts), runs up to 2 fix-verify cycles per thread, then replies on each thread with a verdict: `fixed`, `fixed-differently`, `replied`, `not-addressing`, or `needs-human`.
- **Outcome:** PR feedback processed in bulk with verdicts posted back on the PR.

## Maintenance — `/prune` (Haiku)

- **File:** `skills/prune/SKILL.md`
- **When:** Monthly, or after major refactors.
- **What it does:** Audits `CLAUDE.md`, memory files, and `memory/wiki/**/*.md` for stale / superseded / unclear entries (semantic staleness; `wiki-lint` complements this for vault-structural health — orphans, broken wikilinks, missing frontmatter). Never auto-deletes — produces recommendations for user approval.

## Memory hierarchy

Four tiers, no overlap:

| Tier | Location | Lifetime | Authoritative for |
|---|---|---|---|
| TodoWrite | In-context | Current session | Throwaway working scratchpad |
| `./.claude/NOTES.md` | Worktree-local | This phase, across sessions | In-flight decisions, current task, open questions |
| GitHub issue body | Remote | Cross-phase | Acceptance criteria, prior-phase decisions, handoff state |
| Obsidian vault | `memory/wiki/` (git-tracked) | Durable, cross-feature | Compounded knowledge — bug-fix history, patterns, architectural insights (written by `/compound` or the plugin's `/save`) |
