---
name: Skill creation patterns
description: Patterns and best practices for writing effective Claude Code skills
type: concept
tags: [claude-code, skills]
status: evergreen
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[claude-skill-anatomy]]"
  - "[[skill-invocation-model]]"
  - "[[skill-frontmatter-reference]]"
  - "[[skill-creator-plugin]]"
---

# Skill Creation Patterns

Effective skills share identifiable patterns. These patterns come from the official skill-creator plugin and tested examples across the ecosystem. Following them makes skills more discoverable, maintainable, and likely to work as intended.

## Pattern 1: Make Descriptions "Pushy"

Claude has a tendency to undertrigger skills — to not invoke them even when they'd be useful. Combat this by making the description explicit about when to use it.

**Bad** (vague, won't trigger reliably):
```
Code explanation tool
```

**Good** (specific trigger contexts):
```
Explains code using visual diagrams and analogies.
Use when explaining how code works, teaching about a codebase,
or when the user asks "how does this work?"
```

The good version:
- Leads with what the skill does (action-oriented)
- Lists specific trigger phrases ("how does this work?")
- Includes common use cases (teaching, learning, explanation)
- Is 1-2 sentences, front-loaded with key use case

## Pattern 2: Progressive Disclosure

Skills load content in three layers to minimize context cost until needed:

1. **Metadata** (always in context): name + description (~100 words)
2. **Full SKILL.md** (when invoked): instructions + guidance (<500 lines)
3. **Supporting files** (on demand): reference docs, templates, examples (unlimited)

Within `SKILL.md`, reference supporting files clearly:

```markdown
## API Reference

For complete endpoint documentation, see [api-reference.md](api-reference.md).
For usage examples, see [examples.md](examples.md).
```

Keep `SKILL.md` under 500 lines. Move detailed reference material to separate files referenced by name. This keeps the skill focused and cheaper to invoke while still providing deep reference material.

## Pattern 3: Explain the Why

Don't just tell Claude what to do; explain why it matters. LLMs respond to theory of mind — understanding reasoning — better than absolute commands.

**Weak**:
```
ALWAYS use this exact format:
# Title
## Summary
## Details
```

**Strong**:
```
Use this structure because readers scan top-to-bottom.
Lead with the title and summary so they know immediately
what they're reading. Details come after.

# Title
## Summary
## Details
```

The strong version explains the reasoning, so Claude can generalize to similar situations beyond the exact template.

## Pattern 4: Show, Don't Tell

Include real examples of expected output:

```markdown
## Commit message format

Commits should follow Conventional Commits.

**Example:**
Input: Added user authentication with JWT
Output: feat(auth): implement JWT-based authentication

**Example:**
Input: Fixed race condition in cache
Output: fix(cache): prevent concurrent write race condition
```

Examples show expectations more clearly than abstract rules. Include both input (what to look for) and output (what to produce).

## Pattern 5: Know Your Invocation Style

Decide whether the skill is better as **reference** (knowledge Claude applies) or **task** (step-by-step action):

### Reference Skills
- Applied to ongoing work
- Invoked automatically by Claude when relevant
- Should have `disable-model-invocation: false` (default)
- Example: API design conventions, code style guide, domain knowledge

```yaml
---
name: api-conventions
description: API design patterns for this codebase
---

When designing API endpoints:
- Use RESTful naming (GET /users, POST /users)
- ...
```

### Task Skills
- Invoked manually by user for specific actions
- Often have side effects (deployments, commits, writes)
- Should have `disable-model-invocation: true`
- Example: deploy, commit, create-pr

```yaml
---
name: deploy
description: Deploy to production
disable-model-invocation: true
---

1. Run tests
2. Build
3. Deploy
```

### Hybrid Skills
Some skills combine reference knowledge with actionable steps:

```yaml
---
name: commit
description: Commit changes following our conventions
disable-model-invocation: false
---

## Conventions (reference, always apply)
- feat: new feature
- fix: bug fix

## Action: Create a commit
1. Write message following conventions above
2. Stage files
3. Commit
```

## Pattern 6: Bundle Repeated Work

If you notice that every invocation of a skill repeats the same helper script or computation, move it to `scripts/`:

**Before** (inefficient):
```markdown
Each invocation re-writes a create_report.py script inline.
The model generates essentially the same code each time.
```

**After** (efficient):
```
my-skill/
└── scripts/
    └── create_report.py

# SKILL.md
Run the report generator:
\`\`\`bash
python ${CLAUDE_SKILL_DIR}/scripts/create_report.py $ARGUMENTS
\`\`\`
```

This saves every future invocation from reinventing the wheel. The script runs without loading into context, making the skill cheaper and more deterministic.

## Pattern 7: Use String Substitution for Flexibility

Support arguments to make skills reusable:

```yaml
---
name: fix-issue
description: Fix a GitHub issue by number
---

Fix GitHub issue $ARGUMENTS following our coding standards.
```

Usage: `/fix-issue 123` or `/fix-issue my-issue-number`

For multiple arguments, use indexing:

```yaml
---
name: migrate-component
description: Migrate a component between frameworks
---

Migrate the $0 component from $1 to $2,
preserving all existing behavior and tests.
```

Usage: `/migrate-component SearchBar React Vue`

## Pattern 8: Control Invocation Scope Explicitly

Most skills should default to being invocable by both user and Claude. But be explicit when restricting:

- **User-only** (side effects, timing-sensitive): `disable-model-invocation: true`
  - Deploy, commit, send message, delete — actions user wants to control
- **Claude-only** (background knowledge): `user-invocable: false`
  - System history, legacy context, reference that isn't actionable as a command

## Pattern 9: Keep Content Lean

Remove things that aren't pulling their weight:

- Don't repeat what the model already knows
- Don't include verbose explanations of obvious concepts
- Remove filler and extra formatting
- Keep standing instructions focused on what's unique

If a skill seems long, read the transcripts from test runs. If the model is wasting time on unproductive steps, the skill is instructing it to do unnecessary work. Delete those parts.

## Pattern 10: Preload Context Dynamically

Use `` !`command` `` syntax to inject live data into the skill before it runs:

```markdown
---
name: pr-summary
description: Summarize a pull request
context: fork
agent: Explore
---

## PR Context
- Diff: !`gh pr diff`
- Comments: !`gh pr view --comments`
- Changed files: !`gh pr diff --name-only`

Summarize this pull request...
```

Commands run before Claude sees the skill, so it receives actual data, not the command itself. This keeps skills current and eliminates the need to manually update context.

## Pattern 11: Test and Iterate

The official skill-creator plugin includes an evaluation loop: draft → test → review → improve → repeat. Key steps:

1. **Write a draft** based on user requirements
2. **Create test cases** — 2-3 realistic scenarios
3. **Run with-skill and baseline versions** in parallel to compare
4. **Gather user feedback** on outputs
5. **Improve based on feedback** — generalize, remove waste, clarify
6. **Repeat** until stable

The evaluation loop (via the skill-creator plugin) provides automated grading, benchmark comparison, and revision guidance.

## Pattern 12: Write for Multiple Invocations

Skills are reused many times. Avoid overfitting to a single example:

**Bad** (specific):
```
Fix the auth bug where user login fails after password reset.
The issue is in the resetPassword function in user.ts.
```

**Good** (generalizable):
```
Fix bugs where a common user workflow fails.
Identify the root cause, write a minimal fix,
test with the scenario that triggered the bug.
```

The good version works for many bug types; the bad version only works once.

## Pattern 13: Leverage Existing Plugins

The ecosystem provides plugin skills you can reference or build on:

- **claude-obsidian** — wiki management, autoresearch, defuddle
- **skill-creator** — interactive skill creation and evaluation
- **superpowers** — brainstorming, planning, code review, debugging
- **chrome-devtools-mcp** — debugging, LCP optimization, accessibility

Reference these in your skills when they solve part of your problem. Avoid duplicating what plugins already do.

---

## Related

- **[[skill-creator-plugin]]** — The official Anthropic plugin for creating and evaluating skills
- **[[skill-invocation-model]]** — How to control when and how skills trigger
- **[[claude-skill-anatomy]]** — File structure and frontmatter reference
