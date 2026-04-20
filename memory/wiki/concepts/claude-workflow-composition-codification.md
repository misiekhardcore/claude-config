---
type: concept
title: "claude-workflow composition codification"
created: 2026-04-19
updated: 2026-04-19
tags:
  - claude-workflow
  - pattern
  - architecture
  - skill-authoring
  - composition
status: current
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[multiskill-workflow-patterns]]"
  - "[[seed-brief-pattern]]"
  - "[[claude-workflow-phase-shape]]"
  - "[[skill-creation-patterns]]"
  - "[[Research: Multiskill Workflow Structure in claude-workflow]]"
---

# claude-workflow Composition Codification

Learnings from issue #13 (PR #14): closing G1-G5 documentation gaps in the `claude-workflow` plugin without restructuring its architecture.

## Context

The plugin's multi-skill architecture was already correct and matched 2026 multi-agent consensus. But the standards (composition patterns, skill roles, seed-brief contracts) existed only in an external Obsidian wiki, invisible to skill authors and maintainers without vault access. The autoresearch synthesis identified five documented gaps (G1-G5) that all pointed to missing in-repo documentation, not missing features.

## Guidance

### 1. When wiki standards should move into the codebase

When a codebase's architecture matches external standards but those standards live only in an external wiki, the fix is documentation-only: add a single shared reference file (`_shared/composition.md`) that the existing docs and skills can cross-link to. No restructuring required.

Signal that it's time to codify:
- Autoresearch identifies open questions that are "confirm X is documented" rather than "decide how to do X"
- Multiple skills reference the same undocumented pattern in their prose
- New contributors cannot understand the architecture without vault access

The codification file (`_shared/composition.md`) becomes the in-repo canonical source. The wiki pages remain as the synthesis layer; the plugin file is the durable, publishable record.

### 2. Template-split strategy for role-based scaffolders

When a single generic template breeds conditional logic in a scaffolder (`/new-skill`), split it into role-specific templates. Each template:
- Stays under 50 lines and remains fully self-contained
- Pre-fills the patterns specific to that role (orchestrator opens with "You are leading...", specialist checks for seed brief, primitive omits team/handoff)
- Routes the scaffolder by role with no conditionals

Three roles, three templates: `SKILL.orchestrator.template.md`, `SKILL.specialist.template.md`, `SKILL.primitive.template.md`.

### 3. Scaffolder question ordering (dependency invariant)

When one question answer informs a recommendation for a later question, the dependency must determine the order. In `/new-skill`, Role was asked before Description but the Role prompt said "Recommend one based on the description" — impossible to fulfill.

Fix: Description before Role. The recommendation at the Role step can then reference the description already collected.

**General rule**: in any scaffolder, topologically sort questions by their dependency graph. A question that recommends an answer based on prior input must come AFTER that input.

### 4. Seed-brief field stabilization

`_shared/composition.md` is now the authoritative field list for the three brief types:

| Brief | Fields |
|-------|--------|
| Research | `tech_stack`, `module_map`, `patterns`, `prior_art`, `open_questions` |
| Prior-art | `problem_domain`, `existing_patterns`, `constraints` |
| Fix | `failing_ac`, `findings`, `prior_decisions` |

Older wiki pages (including [[seed-brief-pattern]]) used different field names inherited from the `/define` SKILL.md prose. The `composition.md` fields are the canonical set going forward.

## Why

- Codifying in-repo avoids the vault-access dependency: any skill author reads the plugin source, not a private wiki
- Role-specific templates eliminate the "which section applies to me?" cognitive load
- Question ordering is a logical invariant, not a style preference — violating it makes recommendations unusable

## When to Use

- Any wiki research session that returns "this should be documented in the repo" rather than "the repo needs new features"
- Authoring a new scaffolder skill: define the question dependency graph before writing the interview sequence
- Adding a new skill role: create a new template file rather than conditionalizing the existing one

## Examples

- `_shared/composition.md` — the codification target for this session
- `_templates/SKILL.orchestrator.template.md` (45 lines), `SKILL.specialist.template.md` (33 lines), `SKILL.primitive.template.md` (30 lines)
- `skills/new-skill/SKILL.md` — Description moved from step (c) to step (b), Role to step (c)

## Staleness Flag

[[seed-brief-pattern]] documents research-brief fields as `Technology stack`, `Module structure`, `Related implementations`, `Naming conventions`, `Existing patterns`, `Prior decisions`, `External references`. The authoritative fields are now those in `_shared/composition.md` (shorter, more condensed). Update [[seed-brief-pattern]] when next editing that page.
