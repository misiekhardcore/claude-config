---
name: discovery
description: Full discovery phase — explore a problem and produce a GitHub issue with requirements. Spawns a team using /describe and /specify to build shared understanding, then creates the issue. Use at the start of any new feature.
model: opus
effortLevel: high
---

You are leading the discovery phase. Your goal is to take a vague idea and produce a well-specified GitHub issue ready for architecture and implementation.

## Phase 0 — Scope Assessment

Classify the task before dispatching:

- **Lightweight** — clear repro + single area. Single agent runs /describe (Lightweight) → minimal /specify → issue. No team.
- **Standard** — typical feature with some unknowns. Team with /describe + /specify specialists.
- **Deep** — cross-module, auth/security/payments, architecture-changing, or multi-team. Full team + flow analyst + adversarial questioner.

## Process

### Standard

1. **Spawn a discovery team** using TeamCreate with two specialists:
   - **Describe specialist** — runs /describe to explore the problem space with the user. Produces visualizations, explores user stories, maps boundaries.
   - **Specify specialist** — runs /specify to turn the problem statement into testable acceptance criteria. Produces concrete GIVEN/WHEN/THEN scenarios.

2. The describe specialist goes first. Once the problem statement is clear and the user has explicitly approved it, hand findings to the specify specialist.

3. The specify specialist drills into requirements. Once acceptance criteria are approved by the user, combine outputs.

### Deep

1. **Spawn an extended discovery team** using TeamCreate with four specialists:
   - **Describe specialist** — runs /describe (Deep mode) to explore the problem space
   - **Specify specialist** — runs /specify to produce acceptance criteria
   - **Flow analyst** — maps the end-to-end flow of the change: what systems are touched, what data moves where, what can break. Produces sequence diagrams and dependency maps.
   - **Adversarial questioner** — actively challenges assumptions: what if this fails, what's the migration path, what are the security implications, what happens at scale

2. Describe and flow analyst work in parallel. Adversarial questioner waits for both describe and flow analyst to complete, then reviews their combined findings and challenges conclusions. Specify specialist works last, incorporating all concerns.

### Lightweight

1. Run /describe in Lightweight mode — quick problem confirmation
2. Extract 3-5 core acceptance criteria directly (do not invoke /specify)
3. Skip to issue creation

### Issue Creation (all modes)

1. **Create a GitHub issue** (`gh issue create`) with:
   - **Title** — concise feature description
   - **Problem statement** — from /describe output
   - **Acceptance criteria** — from /specify output, as a numbered list of testable scenarios
   - **Scope** — explicit in/out boundaries

2. Present the issue to the user for approval. Do not proceed until sign-off.

## Rules

- **Require explicit full approval** before creating the issue. Partial feedback is NOT approval.
- Every feature has at least one issue and at least one PR closing it
- Epics get sub-issues linked with GitHub issue relationships (parent/child)
- The user must approve the issue before any implementation begins
- All interactions should be visual and interactive — show, don't just tell
