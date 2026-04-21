---
name: Play Assertion Runner Architecture
description: Two-system architecture in camunda-hub/play; final scope split for #23365 (evaluator only, blocked by #3498) and how scope corrections landed across #3495/#3498
type: concept
tags: [camunda, play, assertions, cpt, architecture, test-assertions, epic-3496]
status: current
created: 2026-04-21
updated: 2026-04-21
confidence: EXTRACTED
evidence:
  - "frontend/packages/modeler/play/src/modules/stores/scenarios.ts:504-539"
  - "frontend/packages/modeler/play/src/modules/stores/acceptanceTests.ts"
  - "frontend/packages/modeler/play/src/modules/utils/translate-scenarios/parse-test-scenario-file.ts"
  - "frontend/packages/modeler/play/src/modules/types/cpt-instructions.ts"
  - "test-studio-internal/src/services/ClientAssertionEvaluator.ts"
  - "https://github.com/camunda/camunda-hub/issues/23365"
related:
  - "[[3496-sub-issue-breakdown-plan]]"
  - "[[agent-handoff-artifact-pattern]]"
---

# Play Assertion Runner Architecture

Discovery from `/define` on camunda-hub **#23365** (Evaluation engine, epic #3496 Phase 1).

---

## Two-System Architecture

The Play package has two parallel test systems that do not share a runner:

### 1. Scenarios (`scenariosStore`)
- **Format**: internal Play vocabulary (lowercase-hyphen instruction types) — being migrated to CPT by #3498
- **Runner**: `replay()` at `scenarios.ts:504-539`
- **Pass/fail**: binary — `processInstance.state === 'COMPLETED'`
- **Execution path**: `Action[]` array, translated via `translate-scenarios` bridge (removed by #3498)

### 2. Acceptance Tests (`acceptanceTestsStore`)
- **Format**: CPT v2.0 (uppercase instruction types)
- **Runner**: **none — CRUD only, manual — out of scope for this epic**
- **Key fact**: acceptance tests stay CRUD-only; they are not the integration target for #23365

---

## The `translate-scenarios` Bridge (being removed by #3498)

`modules/utils/translate-scenarios/parse-test-scenario-file.ts` maps Play-internal instruction types → `Action[]`.

- Does **not** handle CPT v2.0 uppercase types
- **Assertions are silently dropped** with `console.warn`
- This bridge is removed as part of [product-hub#3498 — Low-Code Test CI/CD Compatibility](https://github.com/camunda/product-hub/issues/3498), which delivers the CPT-native scenario runner

---

## CPT Type Gaps (fixed in #23365)

### `AssertElementInstanceInstruction.state`
Current in `cpt-instructions.ts`: only 3 states — `IS_ACTIVE | IS_COMPLETED | IS_TERMINATED`  
Must add: `IS_NOT_ACTIVE` and `IS_NOT_ACTIVATED`

### `AssertProcessInstanceInstruction`
Already has `hasActiveIncidents?: boolean`.  
Gap: the prototype evaluator doesn't branch on this field. Must add incident flag branching.

---

## Final Architecture Decision

**#23365 is evaluator-only. The runner is owned by #3498.**

Scope split:
| Work | Owned by |
|------|----------|
| Scenario file migration (lowercase-hyphen → CPT uppercase) | **#3498** |
| Automatic on-load migration | **#3498** |
| CPT-native scenario runner (replaces `Action[]` dispatch) | **#3498** |
| `IAssertionEvaluator` interface + `ExecutionState` + `TestAssertionResult` | **#23365** |
| `ClientAssertionEvaluator` port from prototype | **#23365** |
| CPT type fixes (`IS_NOT_ACTIVE`, `IS_NOT_ACTIVATED`) | **#23365** |
| Runner integration (split assertions, assemble state, call evaluator) | **#23365** (PR 2, layered on #3498's PR 1) |
| Non-deterministic agent task warnings | **#3495** (moved out of #23367) |
| Acceptance tests runner | **out of epic** |

**PR plan for #23365:**
- **PR 1** (delivered in #3498 work): CPT-native scenario runner
- **PR 2** (this issue): evaluator + integration layered on PR 1

---

## Decided Interfaces

### `IAssertionEvaluator`
```typescript
interface IAssertionEvaluator {
  evaluate(assertions: TestCaseInstruction[], state: ExecutionState): Promise<TestAssertionResult[]>;
}
```
Async `Promise` — future CPT REST service swap without changing callers.

### `ExecutionState`
```typescript
type ExecutionState = {
  processInstance: ProcessInstance;
  flowNodeInstances: FlowNodeInstance[];
  variables: Variables;
  incidents: Incident[];
};
```
Assembled from stores already populated by polling during replay: `elementInstancesStore`, `variablesStore`, `incidentsStore`, `processInstanceStore`. No extra fetches needed.

### `TestAssertionResult`
```typescript
type TestAssertionResult = {
  type: string; name: string; expected: unknown; actual: unknown;
  passed: boolean; message?: string; elementId?: string; elementName?: string;
};
```

---

## Deferred (potential follow-ups)

- **FEEL-expression evaluation** for `ASSERT_VARIABLES` — exists in prototype but is not CPT v2.0. Revisit if added to CPT schema.

---

## Key Files

| File | Role |
|------|------|
| `modules/stores/scenarios.ts:504-539` | `replay()` engine — binary COMPLETED check, to be extended in PR 2 |
| `modules/stores/acceptanceTests.ts` | CRUD store, no runner — out of scope |
| `modules/utils/translate-scenarios/parse-test-scenario-file.ts` | Bridge being removed by #3498 |
| `modules/types/cpt-instructions.ts` | CPT types — needs `IS_NOT_ACTIVE`/`IS_NOT_ACTIVATED` |
| `modules/services/IZeebePlayService.ts` | 30+ methods, covers all Phase 1 CPT action types |
| `test-studio-internal/src/services/ClientAssertionEvaluator.ts` | Port source (217 lines) |
| `test-studio-internal/src/interfaces/assertion-evaluator.ts` | Interface source |

---

## Scope Corrections During /define

Three pieces of work were identified during /define and redirected to their owning epics:

1. **Non-deterministic agent task warnings** — originally in #23367 scope, moved to **#3495** (Non-Flaky Agentic Test Execution)
2. **Scenario file format migration** — initially proposed as "migrate on load" in #23365 PR 1, correctly redirected to **#3498** (Low-Code Test CI/CD Compatibility)
3. **Acceptance tests runner** — never in scope; `acceptanceTestsStore` is CRUD-only by design for now
