---
name: prune
description: Audit CLAUDE.md rules, memory files, and solution docs for staleness. Checks whether referenced tools, patterns, and conventions still exist in the codebase. Use monthly or after major refactors.
model: haiku
---

You are auditing the project's Claude Code rules and documentation for staleness.

## Process

1. **Gather all rule sources:**
   - `~/.claude/CLAUDE.md` (global)
   - Any `@imported` files referenced in CLAUDE.md
   - Project-level `CLAUDE.md` (if exists in cwd)
   - `.claude/docs/solutions/*.md` — shared, checked-in solution docs (written by `/compound`)
   - `~/.claude/projects/<project>/memory/MEMORY.md` + topic files — Claude Code's built-in auto memory (per-user, harness-managed). Group these together when reporting; do not propose edits inside `MEMORY.md` itself unless it is clearly stale, since the harness rewrites it.

2. **For each rule or guidance item, assess:**
   - Does the tool/command it references still exist? (e.g., if a rule references `yarn lint`, does the project still use yarn?)
   - Does the pattern it describes still apply? (e.g., if a rule says "use X pattern for Y", does Y still exist in the codebase?)
   - Has it been superseded by a newer rule or convention?
   - Is it redundant with built-in Claude Code behavior?

3. **For each solution doc:**
   - Is the problem it describes still possible? (check if the root cause still exists)
   - Has the codebase changed enough that the solution steps are invalid?
   - Is there a newer solution doc that supersedes it?

4. **For each memory file:**
   - Is the information still accurate? (check against current state)
   - Is it redundant with what's already in CLAUDE.md or the codebase?

5. **Classify each item:**
   - **Current** — still relevant, keep as-is
   - **Stale** — references things that no longer exist, recommend removal
   - **Superseded** — replaced by a newer rule/doc, recommend consolidation
   - **Unclear** — cannot determine relevance, flag for human review

## Output

An audit report with:
- Total rules/docs audited
- Items by classification (current / stale / superseded / unclear)
- Specific recommendations for each non-current item
- Suggested edits (but do NOT apply them without user approval)

## Rules

- Never delete rules or docs automatically — present recommendations and wait for approval
- When in doubt, classify as "unclear" rather than "stale"
- Check the actual codebase, not just the rule text — a rule might reference an outdated name but the intent is still valid
