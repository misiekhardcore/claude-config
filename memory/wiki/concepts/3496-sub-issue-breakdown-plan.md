---
name: Epic 3496 Sub-Issue Breakdown Plan
description: Sub-issue structure, GH issue numbers, and /define briefings for product-hub epic #3496 (Low-Code Test Assertions) — load before any /define session on 1a, 1c, 3a, or 3b
type: concept
tags: [camunda, product-hub, epic-breakdown, test-assertions, project-plan]
status: current
created: 2026-04-21
updated: 2026-04-21
confidence: INFERRED
evidence:
  - "https://github.com/camunda/product-epics-pilot/pull/24"
  - "https://github.com/camunda/product-hub/issues/3496"
related:
  - "[[claude-workflow-phase-shape]]"
---

# Epic 3496 Sub-Issue Breakdown Plan

Plan for decomposing product-hub epic **#3496 — Low-Code Test Assertions** into GitHub sub-issues, derived from the solution proposal in [product-epics-pilot PR #24](https://github.com/camunda/product-epics-pilot/pull/24) (branch `fix/pr-20-review-feedback`).

Context: The solution proposal organizes the work into three phases. Phases 1 and 3 have internal a/b/c/d parts; Phase 2 is a single flat scope.

## Decision: Nested for Phase 1 and Phase 3, flat for Phase 2

**Why:**
- **1a** (evaluation engine) and **3a** (validation pipeline) are genuine foundation issues that gate everything else in their phase.
- 1b/1c/1d/1e and 3b/3c/3d are independently shippable UI surfaces with their own designs and acceptance criteria.
- A flat phase issue would hide the dependency graph (1a → 1b-e, 3a → 3b-d) that the proposal is already built around.
- Phase 2 already has a single coherent scope — no sub-parts needed.

**How to apply:**
- **Parent**: product-hub #3496 (existing epic)
- **Phase issues** (children of #3496): Phase 1, Phase 2, Phase 3
- **Sub-part issues** (children of their phase): 1a–1e, 3a–3d
- **Dependency links**:
  - 1b, 1c, 1d, 1e → `Depends on` 1a
  - 3b, 3c, 3d → `Depends on` 3a
  - Phase 3 → `Depends on` Phase 1

## Phase / sub-issue list

Created 2026-04-21 in `camunda/camunda-hub` with native sub-issue relationships wired for same-repo parent/child.

Titles are the plain feature names — phase/order is encoded in GitHub native sub-issue relationships, not in the title. Depends-on relationships live in issue bodies.

### Assertion authoring and evaluation (Phase 1) — [#23375](https://github.com/camunda/camunda-hub/issues/23375)
- Evaluation engine — [#23365](https://github.com/camunda/camunda-hub/issues/23365) _(foundation; 1b/c/d/e depend on this)_
- Variable assertion editor — [#23366](https://github.com/camunda/camunda-hub/issues/23366)
- Element instance (path) assertion editor — [#23367](https://github.com/camunda/camunda-hub/issues/23367)
- Process instance assertion editor — [#23368](https://github.com/camunda/camunda-hub/issues/23368)
- Pass/fail results — [#23369](https://github.com/camunda/camunda-hub/issues/23369)

### Test case editing (Phase 2) — [#23370](https://github.com/camunda/camunda-hub/issues/23370)
Single flat issue. Independent of Phase 1; can ship in parallel.

### Test case repair (Phase 3) — [#23376](https://github.com/camunda/camunda-hub/issues/23376) _(depends on Phase 1)_
- Validation pipeline — [#23371](https://github.com/camunda/camunda-hub/issues/23371) _(foundation; 3b/c/d depend on this)_
- Graphical repair view — [#23372](https://github.com/camunda/camunda-hub/issues/23372) _(primary repair path)_
- Re-record flow — [#23373](https://github.com/camunda/camunda-hub/issues/23373)
- JSON editor — [#23374](https://github.com/camunda/camunda-hub/issues/23374) _(advanced fallback)_

## /discovery vs /define routing

Skip `/discovery` — the solution proposal already nails the problem space.

Run `/define` (or `/design`) on issues with real architecture decisions or UX complexity:

| Issue | Workflow | Reason |
|---|---|---|
| **1a** | `/define` | `IAssertionEvaluator` interface boundary, CPT-parity contract |
| **1c** | `/define` or `/design` | Non-deterministic-agent-task warning UX is novel; mitigates a High-severity risk |
| **3a** | `/define` | Validation pipeline + `ValidationResult` recovery-action shape |
| **3b** | `/design` | Inline repair-editor reuse pattern is non-trivial |
| 1b, 1d, 1e, 2, 3c, 3d | skip | Proposal is detailed enough |

## Target repo

**`camunda/camunda-hub`** — this is where the `camunda/play` package lives (the package the epic will touch). The parent epic #3496 remains in `camunda/product-hub`; cross-repo parent link to it from the phase issues.

## Open questions (resolve before creating issues)

1. **Which GitHub relationship mechanism?** Native sub-issue feature (new) vs tasklists vs `Depends on`/`Tracks` labels? Likely a mix: native sub-issues for parent/child, tasklists or comments for dependency graph. Cross-repo parent link (camunda-hub → product-hub #3496) may need tasklist or body reference rather than native sub-issue.

## Pre-Define Briefings

Compact context for each `/define` candidate. Load this page + the solution proposal before each session. Skip re-reading the solution proposal if the relevant section is summarised below.

---

### 1a — Evaluation engine ([#23365](https://github.com/camunda/camunda-hub/issues/23365))

**Skill**: `/define`

**Decisions already made (do not re-litigate):**
- Client-side TypeScript evaluator — no backend, no backend engineer available for 8.10.
- Single `IAssertionEvaluator` interface as the swap boundary for the future CPT service.
- Follow CPT schema: assertions live in the shared `instructions[]` array alongside execution instructions; frontend filters at runtime.
- Three assertion types in scope: `ASSERT_VARIABLES`, `ASSERT_ELEMENT_INSTANCE`, `ASSERT_PROCESS_INSTANCE`.

**Open decisions for /define to nail down:**
- Exact `IAssertionEvaluator` interface: method signatures, return type shape, async/sync, how to surface element-not-found vs. evaluation-failure.
- `TestAssertionResult` field contract: which fields are required vs. optional; how human-readable element name is resolved (where does the lookup happen?).
- CPT-parity mapping: which specific CPT Java test fixtures to verify against; JSON.stringify equivalence edge cases (undefined vs. null, number vs. string).
- `CPT_STATE_TO_RUNTIME` mapping table — the full state→enum translation; confirm against CPT source.
- Evaluator wiring: exact insertion point in the test run flow (post-execution hook? separate evaluation step triggered by test runner? inline with instruction replay?).
- Prototype gap to close: incident flag evaluator branch (`hasActiveIncidents`/`hasNoActiveIncidents` — type exists, branch missing).

**Key constraints:**
- Evaluation must produce identical results to the future CPT service. Verify against CPT's Java test fixtures, not just informal testing.
- The interface must not expose internal implementation details that would break when the evaluator is swapped for CPT service calls.

**Prototype reference:** `test-studio-internal` on `main`. Evaluator exists; incident branch is the gap.

---

### 1c — Element instance (path) assertion editor ([#23367](https://github.com/camunda/camunda-hub/issues/23367))

**Skill**: `/define` or `/design` (UX-heavy; consider splitting: `/define` for the non-det warning detection algorithm, `/design` for the canvas integration UX)

**Decisions already made:**
- Five element states in scope, including negative states (IS_NOT_ACTIVE, IS_NOT_ACTIVATED).
- Add-from-canvas context action on selected BPMN element pre-fills the editor.
- Live preview overlay on canvas: selected element shows state-colored marker as dropdown changes.
- Non-deterministic agent task warning surfaced **pre-save**, not post-failure — this is a product commitment.

**Open decisions for /define/design to nail down:**
- **Non-det warning detection**: what makes an element "downstream of an agent task"? Need a BPMN graph traversal algorithm — does it cover gateways (all paths? any path?), subprocess boundaries, event-based gateways?
- **Warning UX**: inline banner in the editor? Blocking pre-save dialog? Non-blocking indicator that persists on save? How dismissible?
- **Canvas overlay**: does it reuse existing Play element state colors? How does it handle multiple assertions on the same element? What happens when the selected element has no BPMN shape (e.g., sequence flow)?
- **Add-from-canvas context action**: right-click menu? Selection panel floating button? Consistent with existing Play canvas interactions?
- **Element selector ComboBox**: data source for BPMN element list — already available via `bpmn-moddle`? Filtered to flow nodes only or all elements?

**High-severity risk this closes:** Users writing path assertions on elements downstream of agent tasks get silent non-deterministic failures. Pre-save warning is the only mitigation. If the detection algorithm is wrong (false negatives), the risk is live.

**Prototype reference:** Not implemented in `test-studio-internal`. Design from scratch.

---

### 3a — Validation pipeline ([#23371](https://github.com/camunda/camunda-hub/issues/23371))

**Skill**: `/define`

**Decisions already made:**
- Extend the existing instruction validator (which already checks element IDs via `bpmn-moddle`) — same pipeline, not a separate one.
- Validate element ID existence for `ASSERT_ELEMENT_INSTANCE` and scoped `ASSERT_VARIABLES` (`elementSelector`).
- Validation runs on test case open and on BPMN change.
- `ValidationResult` carries a recommended recovery action — not a bare error state.

**Open decisions for /define to nail down:**
- **`ValidationResult` shape**: what fields exactly? Suggested: `{ instruction, issueType, recommendedAction, message, affectedElementId? }` — but this needs agreement.
- **Recovery-action taxonomy**: enumerated set of possible actions. Candidates: `DELETE_INSTRUCTION`, `EDIT_ASSERTION`, `RE_RECORD`, `IGNORE`. Are there others? Does the taxonomy need to be open-ended?
- **Integration with existing validator**: extend the class? Implement same interface? Wrap? What's the existing validator's interface shape?
- **BPMN-change trigger**: what event/listener triggers re-validation when the diagram changes? Is it eager (on every edit) or lazy (on next view of the repair view)?
- **Broken test case marking in list**: new status field on the TestCase model? Badge/icon added by the list component? What's the data flow from validation result → list indicator?
- **Prototype gap**: scoped `ASSERT_VARIABLES` `elementSelector` existence not checked today — this is a new validation path.

**Prototype reference:** Instruction validator exists for execution instructions in `test-studio-internal`. Extension points for assertions to be identified.

---

### 3b — Graphical repair view ([#23372](https://github.com/camunda/camunda-hub/issues/23372))

**Skill**: `/design`

**Decisions already made:**
- Graphical repair is the **default** surface for broken test cases — JSON editor (3d) is explicitly a power-user fallback.
- Must not require JSON knowledge (business analyst persona).
- Inline edit of broken assertions by reopening the Phase 1 editors pre-filled with current values.
- Delete broken instructions with save/cancel flow.
- Prototype today supports delete only; inline edit via Phase 1 editors is new.

**Open decisions for /design to nail down:**
- **Editor reuse pattern**: how do Phase 1 editors (variable, element-instance, process-instance) integrate into the repair context? Same component in a different mode? Modal dialog opened from the repair row? Inline expansion?
- **Pre-fill semantics for broken assertions**: if the element ID no longer exists in BPMN (the common broken case), what does "pre-filled with current values" look like in the element selector? Show the stale ID with an error? Empty the selector? Show a ghost item?
- **Repair view placement**: separate page? Sidebar panel? Modal? Inline expansion within the test case detail?
- **Multi-broken case UX**: ordered list by severity? Priority ordering (execution instructions before assertion instructions, or mixed)? Bulk actions?
- **Save/cancel scope**: per-row save/cancel or a single apply-all with one save?
- **Recovery-action-driven UX**: does the recommended action from `ValidationResult` change the row appearance? (e.g. DELETE_INSTRUCTION rows show delete button prominently; EDIT_ASSERTION rows show edit-in-place button?)

**Prototype reference:** Repair view exists in `test-studio-internal` (delete only). Inspect for interaction patterns to preserve; identify what to extend.

---

## Source

- Solution proposal: `initiatives/testing-camunda-agents/3496-low-code-test-assertions.solution-proposal.md` on branch `fix/pr-20-review-feedback`
- PR: https://github.com/camunda/product-epics-pilot/pull/24
- Epic: https://github.com/camunda/product-hub/issues/3496
- Related epics (out of scope reminders): [#3315](https://github.com/camunda/product-hub/issues/3315) (FEEL), [#3495](https://github.com/camunda/product-hub/issues/3495) (statistical thresholds), [#3498](https://github.com/camunda/product-hub/issues/3498) (CPT format migration)
