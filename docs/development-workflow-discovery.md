# Development Workflow: Discovery, Define, Implement, Review

## Overview

The workflow is a four-phase pipeline for turning a feature request into a merged PR. Each phase has explicit read/write contracts on the GitHub issue and PR so that humans and agents always know where to look.

```
/discovery → /define → /implement → /address-review
```

Pick the lightest path that fits the task:

| Task size | Path |
|-----------|------|
| Trivial fix | `/implement` directly |
| Medium feature | `/discovery` → `/implement` |
| Large feature / epic | `/discovery` → `/define` → `/implement` |

---

## Phase 1: /discovery

### Purpose

Interview the user, write (or rewrite) the GitHub issue with a five-field handoff block, and get explicit approval before any code is written.

### Five-field handoff block

Every issue body produced by `/discovery` contains exactly these five fields:

1. **Problem statement** — what is broken or missing and why it matters.
2. **Acceptance criteria** — a numbered list of verifiable conditions that define "done".
3. **Out of scope** — explicit exclusions to prevent scope creep.
4. **Open questions** — anything still unresolved that a downstream phase must not silently assume.
5. **References** — links to relevant code, docs, or prior issues.

### Re-run semantics (replace in place)

When `/discovery` runs against an existing issue it **rewrites the five-field block wholesale**. No strikethroughs, no dated sub-headings, no `<details>` folds.

- The preamble reads the full current state (issue body + all comments) before rewriting — this is the knowledge-migration step. Anything worth preserving must make it into the new block consciously.
- If the problem framing has shifted, the problem statement is rewritten. If it has not shifted, it stays byte-identical (no cosmetic rewrites).
- Acceptance criteria follow the same rule: the old list is overwritten. No "previous AC" fold.
- **Audit trail:** GitHub's native issue edit history holds every prior version. `/discovery` does not try to replicate it.

### Postamble reconciliation (on AC change)

AC are the contract `/implement` verifies against, so silent changes have blast radius. After rewriting AC, `/discovery` checks for downstream artifacts:

| Situation | Action |
|-----------|--------|
| A PR is already open against this issue | Post a comment on the PR: "Acceptance criteria updated in #\<issue\>. Current AC: \<n/n\> still met, \<n\> changed, \<n\> new. Re-run /address-review or /implement to reconcile." Does **not** close the PR. |
| Sub-issues exist (from a prior `/define`) | Re-derive each sub-issue's AC slice from the new parent AC. Slices that no longer map get a superseded comment + close (see `/define` reconciliation). |
| Neither applies | Pure overwrite, nothing to reconcile. |

---

## Phase 2: /define

### Purpose

Break an epic into sub-issues, write their acceptance criteria slices, and link them to the parent via GitHub parent/child relationship (or `Parent: #N` in the body, depending on repo settings).

### Sub-issue inheritance

Each sub-issue receives the same five-field block inherited from the parent epic, pre-populated with the slice of acceptance criteria it covers.

### ## Define Outcome block

`/define` writes a `## Define Outcome` section into the epic issue body containing:

- The chosen architecture / decomposition rationale.
- The sub-issue breakdown (list with links).
- Any decisions made during define that downstream phases must honour.

### Re-run semantics (replace in place)

Same rule as `/discovery`:

- Re-running `/define` **replaces the `## Define Outcome` block in place**. No collapsed history.
- The preamble reads the existing block before replacing, so architecture decisions still valid are carried forward intentionally (not by accumulation).
- If a sub-issue was linked to a specific architecture decision from the previous define run and that decision no longer appears in the new block, the sub-issue link becomes the only remaining reference — this forces the re-run to confront whether the sub-issue is still valid.

### Postamble reconciliation (stale sub-issues)

When `/define` re-runs and the new `## Define Outcome` has a different sub-issue breakdown, old sub-issues are reconciled explicitly:

| Sub-issue state | Action |
|-----------------|--------|
| Still maps cleanly to a slice of the new breakdown | Keep it; update its body with the new AC slice. |
| No longer maps | Post comment: "Superseded by re-defined scope in #\<epic\>. Closing unless there's work already in flight." Then close the sub-issue. |
| Maps partially | Leave open; post a comment with the delta; flag in the epic's `## Define Outcome` as "needs manual review". |

---

## Phase 3: /implement

### Purpose

Write the code, open a draft PR, run fix cycles, and verify every acceptance criterion is met.

### Preamble (read before doing anything)

Before writing a single line of code, `/implement` fetches the issue body **and all comments**. Rationale: between `/define` and `/implement` the user or other reviewers may have posted clarifications, revised AC, or answered open questions from the handoff block.

- Any comment newer than the last `## Define Outcome` update is treated as material input.
- If conflicting information is found, `/implement` **halts and asks** — it never silently picks one interpretation.

### Comments posted by /implement

One comment per meaningful state change. Never more.

#### Start

Posted once when the phase begins:

```
🤖 Starting implementation. Working from ## Define Outcome (last updated <date>).
Branch: <branch>. Will post again when a draft PR is open or if the fix-cycle
escalates to needs-human.
```

#### Escalation (only if fix-cycle max iterations hit or an AC cannot be met)

```
🤖 Fix-cycle escalated after N iterations. Blocking issue: <one-line>.
Details: <fold with reviewer findings and failing AC>. Need guidance before continuing.
```

#### PR open

Posted once when the draft PR is opened:

```
🤖 Draft PR opened: #<n>. AC status: <n/n met>. Review + verify clean.
Ready for human review.
```

#### Consolidation summary (only if /consolidate wrote new memory notes)

```
🤖 Captured learnings: .memory/bugs/<slug>.md, .memory/procedures/<slug>.md.
```

### What is NOT posted as a comment

- Per-commit updates.
- Per-fix-cycle-iteration noise.
- Internal reviewer findings (those belong in the review agent's fix-brief, not the issue thread).

### PR body wording

| Situation | PR body contains |
|-----------|-----------------|
| PR delivers the full epic | `Closes #<epic>` |
| PR delivers one sub-issue of many | `Part of #<epic>` |

---

## Phase 4: /address-review

### Purpose

Triage every open review thread, post a verdict reply, and resolve threads where appropriate.

### Verdict table

| Verdict | Reply posted? | Thread resolved? | Rationale |
|---------|--------------|-----------------|-----------|
| `fixed` | Yes — with commit SHA | Yes — auto-resolve | We acted on the request exactly as asked. |
| `fixed-differently` | Yes — with rationale + commit SHA | Yes — auto-resolve | We addressed the underlying concern; reviewer can re-open if unhappy. |
| `replied` | Yes — discussion only, no code change | No — leave open | We are asking or disagreeing; reviewer owns the next move. |
| `not-addressing` | Yes — with rationale | No — leave open | Declining a request is a human-to-human decision; the reviewer resolves it (or insists). |
| `needs-human` | Yes — escalation context | No — leave open | We failed to act confidently; leaving it open keeps it visible on the unresolved count. |

### Verdict tag in reply

Every reply ends with a machine-readable tag so future runs can skip already-handled threads:

```
Fixed in abc1234 — replaced the N+1 loop with a single JOIN (benchmarks in commit body).
<!-- verdict: fixed -->
```

### Idempotency

`/address-review` always fetches the current state of each thread before acting. If it sees its own previous verdict tag and no new comments since, it skips that thread. Safe to re-run.

### Re-opened threads

If a reviewer unresolves a thread `/address-review` previously resolved, the next run treats it as a fresh triage entry and will try again (up to the 2-cycle cap per round). This prevents infinite ping-pong while allowing legitimate push-back.

---

## Consistency rule: replace in place

The following three regions are always rewritten in place on re-run. None of them accumulate history inline.

| Region | Written by |
|--------|-----------|
| Problem statement | `/discovery` |
| Acceptance criteria | `/discovery` |
| `## Define Outcome` block | `/define` |

Each re-running phase reads the existing region before overwriting so carry-forwards are deliberate. Stale downstream artifacts (sub-issues, open PRs) get a reconciliation pass in the phase's postamble, not an inline history fold.

---

## Audit surface

No phase contract tries to be its own audit log. The three canonical audit sources are:

1. **GitHub edit history** — every prior version of issue/PR bodies.
2. **Issue comments from `/implement` checkpoints** — a permanent timeline (comments are not edited, only added).
3. **`.memory/procedures/`** — when a re-run captures a new procedure note, that is the permanent record of "the second attempt shipped this way".

All three are read-only from the perspective of downstream phases, so none of them bloats the input any phase has to process.
