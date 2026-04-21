---
name: Play Assertion Runner Architecture
description: Two-system architecture in camunda-hub/play; scope split for #23365; PR1 (#23380) scaffolding delivered; PR2 evaluator pending; prototype comparison
type: concept
tags: [camunda, play, assertions, cpt, architecture, test-assertions, epic-3496]
status: current
created: 2026-04-21
updated: 2026-04-21
confidence: EXTRACTED
evidence:
  - "frontend/packages/modeler/play/src/modules/stores/scenarios.ts"
  - "frontend/packages/modeler/play/src/modules/stores/acceptanceTests.ts"
  - "frontend/packages/modeler/play/src/modules/utils/translate-scenarios/parse-test-scenario-file.ts"
  - "frontend/packages/modeler/play/src/modules/types/cpt-instructions.ts"
  - "frontend/packages/modeler/play/src/modules/types/assertion-evaluator.ts"
  - "frontend/packages/modeler/play/src/modules/utils/split-instructions.ts"
  - "frontend/packages/modeler/play/src/modules/utils/assemble-execution-state.ts"
  - "test-studio-internal/src/services/ClientAssertionEvaluator.ts"
  - "https://github.com/camunda/camunda-hub/issues/23365"
  - "https://github.com/camunda/camunda-hub/pull/23380"
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

**PR plan for #23365 (actual — revised from /define):**

- **PR 1 — #23380** (standalone, **no dependency on #3498**, draft open, review cycle 2 passed clean):
  - New `modules/types/assertion-evaluator.ts` — `IAssertionEvaluator`, `ExecutionState`, `TestAssertionResult`
  - New `modules/utils/split-instructions.ts` + tests — partitions `TestCaseInstruction[]` by `type.startsWith('ASSERT_')`
  - New `modules/utils/assemble-execution-state.ts` + tests — adapter over 4 Play stores; throws on missing/mismatched `instanceKey`; call guarded by try-catch in `replay()`
  - `ScenarioRun` extended with `assertionResults?: TestAssertionResult[]`
  - `replay()` returns `{ assertionResults, instanceKey }` instead of `{ isCompleted, processInstanceKeyForScenarioRun }`
  - Placeholder evaluator always returns `[]` → `[].every(r => r.passed) === true` → Completed (zero behavior change)
  - Execution errors emit synthetic `{ passed: false }` result to preserve `Failed` semantics
- **PR 2** (pending): `ClientAssertionEvaluator` implementation — ~50% logic port from `test-studio-internal/src/services/ClientAssertionEvaluator.ts` + ~50% greenfield (plural-aggregate branches, incident branch); replaces placeholder in `replay()`

> **Note**: The /define-era plan had PR 1 as the CPT-native runner owned by #3498. During /build, PR 1 was repivoted to standalone scaffolding. The two PRs are now independent: #3498 owns the runner, #23365 PR 1 owns types/utilities/scaffolding, PR 2 owns the evaluator.

---

## Prototype Comparison

The prototype (`test-studio-internal`) had `IAssertionEvaluator` and `ClientAssertionEvaluator` but **never wired them into any runner**. `ExecutionState` was declared but assembled nowhere.

| Piece | Prototype | #23365 PR 1 |
|---|---|---|
| `IAssertionEvaluator` interface | ✅ sync, 3-field state | ✅ async `Promise`, 4-field state (adds `incidents`) |
| `splitInstructions` | ❌ absent | ✅ new |
| `assembleExecutionState` | ❌ absent | ✅ new |
| `replay()` refactor | ❌ never touched | ✅ returns `{ assertionResults, instanceKey }` |
| Wired into runner | ❌ never | ✅ placeholder wired |

PR 2 is where the prototype logic port lands. The key divergences: prototype is sync; prototype's `ExecutionState` has 3 fields (no incidents); prototype has no plural-aggregate branch; prototype has no incident branch.

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
| `modules/stores/scenarios.ts` | `replay()` refactored in PR 1 to return `{ assertionResults, instanceKey }`; placeholder wired; real evaluator in PR 2 |
| `modules/types/assertion-evaluator.ts` | **NEW (PR 1)** — `IAssertionEvaluator`, `ExecutionState`, `TestAssertionResult` |
| `modules/utils/split-instructions.ts` | **NEW (PR 1)** — partitions instructions by `type.startsWith('ASSERT_')` |
| `modules/utils/assemble-execution-state.ts` | **NEW (PR 1)** — adapter over 4 stores; throws on missing/mismatched instanceKey |
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
