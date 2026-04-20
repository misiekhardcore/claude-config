---
type: concept
title: "AskUserQuestion in Skill Interviews"
created: 2026-04-19
updated: 2026-04-20
tags:
  - pattern
  - technique
  - claude-workflow
  - skill-authoring
  - AskUserQuestion
  - interview
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[skill-creation-patterns]]"
  - "[[claude-workflow-composition-codification]]"
  - "[[new-skill]]"
  - "[[grill-me]]"
---

# AskUserQuestion in Skill Interviews

## Context

When a Claude Code skill needs to gather structured input from the user during an interview phase -- for example `/new-skill` asking which role, model, and target location to use -- two interaction modes are available: plain text prompts (for free-text input) and the `AskUserQuestion` tool (for bounded-choice questions). Choosing the wrong mode degrades UX: numbered text lists are harder to select from than a rendered picker, and open prompts are inappropriate for yes/no or enum choices.

Applies to: any skill with an interview or Q&A phase (`/new-skill`, `/grill-me`, discovery/define phase orchestrators).

## Guidance

Use `AskUserQuestion` for every question with a **bounded set of distinct choices** (2-4 options). Use plain prompts for open-ended free-text input.

**AskUserQuestion parameters:**
- `questions`: array of 1-4 independent questions (use multiple only when answers don't depend on each other)
- Each question needs: `question` (full sentence ending in `?`), `header` (chip label, max 12 chars), `options` (2-4 items with `label` + `description`), `multiSelect` (true when choices are not mutually exclusive)
- "Other" is always auto-added -- do not include it yourself
- Recommended option goes first with ` (Recommended)` appended to its `label`

**When to fall back to plain prompts:**
- Free-text fields: name, description, custom tool list
- Genuinely open-ended exploration (brainstorming, grill-me discovery questions)
- Tool unavailable

**Applying to `/new-skill` interview (concrete mapping):**
- Name (a) and Description (b): plain prompts
- Role (c), Model (d), Effort (e), Tools (f): single-select AskUserQuestion
- Shared protocols (g): multi-select AskUserQuestion (4-option limit forces splitting `composition.md` into a second call)
- Target (h): single-select AskUserQuestion

**`_shared/interviewing-rules.md` exception clause:** "Ask one question at a time" still holds. AskUserQuestion's multi-question support (up to 4) is only for *independent* questions where no answer informs the options of another. Use it sparingly.

## Why

- Rendered picker UI is faster to interact with than a numbered text list
- "Other" escape hatch is automatic -- no need to add it as an option
- `multiSelect: true` handles "pick all that apply" without needing a separate follow-up
- Keeps skill prose aligned with how Claude Code actually renders the interaction

## When to Use

- Any skill step that presents 2-4 mutually exclusive choices
- Protocol/feature selection with "pick all that apply" semantics (multiSelect)
- Scaffolder interviews (e.g. `/new-skill`) where the option set is fully enumerated in the skill spec

Do NOT use when:
- The option set is open-ended or domain-specific (user needs to type freely)
- More than 4 options are required -- split into sequential AskUserQuestion calls instead

## Examples

Role question in `/new-skill`:
```
AskUserQuestion({
  questions: [{
    question: "Which role does this skill fill?",
    header: "Role",
    multiSelect: false,
    options: [
      { label: "Specialist (Recommended)", description: "Executes a bounded task; receives a seed brief from an orchestrator" },
      { label: "Orchestrator", description: "Leads a phase; spawns specialists; writes a handoff artifact" },
      { label: "Interactive primitive", description: "Reusable inline behavior; no team, no handoff" }
    ]
  }]
})
```

Shared protocols (multi-select, split into two calls due to 4-option limit):
```
Call 1: header "Protocols", multiSelect: true
  - Handoff artifact / Interviewing rules / NOTES.md protocol / Compaction protocol

Call 2: header "Composition", multiSelect: false
  - No / Yes (include composition.md)
```
