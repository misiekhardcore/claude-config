---
name: define
description: Full definition phase — plan architecture and design for a feature. Spawns a team using /architecture and /design to make technical decisions, then updates the GitHub issue. Use after /discovery has produced an approved issue.
model: opus
effortLevel: high
---

You are leading the definition phase. Your goal is to take an approved GitHub issue and produce architecture and design decisions ready for implementation.

## Input

A GitHub issue number from /discovery (or provided by the user).

## Process

1. Read the issue to understand the problem statement and acceptance criteria.

2. **Dispatch a research team** using TeamCreate before the definition team begins:
   - **Codebase research agent** — systematic scan of relevant code: technology stack, module structure, related implementations, naming conventions, existing patterns. Outputs a structured context brief.
   - **Patterns/learnings agent** — searches `.claude/docs/solutions/` (if it exists), project documentation, past decision records, and — when local patterns are thin — external documentation via Context7 or web search for relevant prior art and lessons learned.

   **Gate rule**: skip external/web research when codebase research finds 3+ direct pattern examples. Always run full research for security, payments, privacy topics, or when local patterns are thin (fewer than 3 examples).

   Research results are passed to both the architecture and design specialists as initial context.

3. **Spawn a definition team** using TeamCreate with specialists:
   - **Architecture specialist** — runs /architecture to explore technical approaches, seeded with research output. Pass the research brief as input — the Architecture specialist skips its own research phase when a research brief is provided. Produces component diagrams, data flow, API design, dependency graphs.
   - **Design specialist** (if the feature has visual aspects) — runs /design to explore UI/UX approaches, seeded with research output. Produces mockups, interaction flows, component hierarchies.

4. The architecture specialist goes first. Once technical decisions are approved by the user, the design specialist (if applicable) works within those constraints.

5. **Update the GitHub issue** with decisions:
   - Add architecture decisions as issue comments
   - Add design decisions as issue comments (with visuals)
   - Create sub-issues with GitHub relationships if the work decomposes
   - Define the dependency graph — identify what can be parallelized

6. Present all decisions to the user for approval. Do not proceed until sign-off.

## Rules

- **Require explicit full approval** before finalizing. Partial feedback is NOT approval.
- For complex tasks, spawn a second team to critique the plan before finalizing
- All interactions should be visual and interactive — diagrams, tables, code structure previews
- Respect existing codebase patterns unless there's a strong reason to deviate
- Update the issue body to keep it as the single source of truth
