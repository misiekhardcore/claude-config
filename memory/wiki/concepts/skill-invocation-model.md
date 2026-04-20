---
name: Skill invocation model
description: How Claude Code skills are triggered, discovered, and executed by Claude
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
  - "[[skill-creation-patterns]]"
  - "[[skill-frontmatter-reference]]"
---

# Skill Invocation Model

Claude Code skills can be triggered in two ways: **by the user** with an explicit slash command, or **automatically by Claude** when the skill's description matches the conversation context. Understanding this dual invocation model is critical for writing skills that trigger appropriately.

## Manual User Invocation

The user invokes a skill explicitly by typing `/skill-name`:

```
/explain-code src/auth/login.ts
```

This works for any skill with `user-invocable: true` (the default). Arguments after the skill name are passed via the `$ARGUMENTS` placeholder:

```markdown
When explaining the code in $ARGUMENTS...
```

The slash-command name comes from the skill's `name` field (or directory name if `name` is omitted). Skill names are lowercase, no spaces, max 64 characters.

## Automatic Claude Invocation

Claude can automatically load and apply a skill when:

1. The skill's `description` field matches something the user asked
2. The skill has `disable-model-invocation: false` (the default)
3. The skill is loaded into Claude's available skills list

Claude's decision to invoke a skill is based on the `description` field. The description is always in context (paired with all other skill descriptions) so Claude sees what capabilities are available. Claude only consults a skill for tasks it cannot easily handle directly — simple one-step queries often won't trigger a skill, even with a perfect description match.

### How Automatic Triggering Works

When Claude determines a task matches a skill's description, the full `SKILL.md` content enters the conversation, and Claude follows those instructions for the duration of the task. The description field is the sole mechanism controlling whether Claude invokes the skill — it must be specific and include both:

- **What the skill does** — concise, action-oriented
- **When to use it** — trigger contexts, phrases, scenarios

Good description:

```
Explains code using visual diagrams and analogies.
Use when explaining how code works, teaching about a codebase,
or when the user asks "how does this work?"
```

Poor description:

```
Code explanation tool
```

The poor version is vague; Claude won't reliably invoke it because "explanation" could mean many things.

### Undertriggering Bias

Claude has a tendency to **undertrigger** skills — to not invoke them when they'd be useful. Combat this by making descriptions "pushy": explicitly list contexts and trigger phrases.

Instead of:

```
Builds dashboards to display data
```

Write:

```
Build fast interactive dashboards to display internal data.
Use whenever the user mentions dashboards, data visualization,
internal metrics, company data display, or charts.
```

The second is more explicit about when to trigger.

## Controlling Invocation

Two frontmatter fields control who can invoke a skill:

| Field | Effect |
|-------|--------|
| `disable-model-invocation: true` | Only user can invoke. Claude cannot trigger automatically. Description not in context. |
| `user-invocable: false` | Only Claude can invoke. Hidden from user's `/` menu. |

### Manual-Only Skills

Use `disable-model-invocation: true` for side-effect-heavy operations (deployments, commits, sensitive actions):

```yaml
---
name: deploy
description: Deploy to production
disable-model-invocation: true
---
```

The description is not loaded into context (no auto-triggering), but the skill is available when the user explicitly invokes `/deploy`. This prevents Claude from deciding to deploy without explicit user instruction.

### Claude-Only Skills

Use `user-invocable: false` for background knowledge that isn't actionable as a command:

```yaml
---
name: legacy-system-context
description: Historical context about the legacy billing system
user-invocable: false
---
```

Claude loads this skill when relevant (matching the description), but users can't invoke `/legacy-system-context` directly — it's not a meaningful action.

## Skill Context Loading

Skill content lifecycle during a session:

1. **Startup**: Skill metadata (name + description) is always available in Claude's context (~100 words per skill)
2. **Invocation**: Full `SKILL.md` content loads into conversation, takes 1 message slot
3. **Persistence**: Content remains in context for the entire session
4. **Compaction**: During auto-compaction (context overflow), most recent 5,000 tokens of each invoked skill re-attach within a combined 25,000-token budget, starting from most recently invoked

This means:
- Invoking many skills in sequence can exhaust the re-attachment budget
- Later skills are prioritized; older ones may be dropped
- Re-invoking a skill after compaction restores full content

## Arguments and Substitution

Skills support several substitution mechanisms for dynamic content:

| Variable | Expands to | Example |
|----------|-----------|---------|
| `$ARGUMENTS` | All user arguments | `/my-skill foo bar` → "foo bar" |
| `$ARGUMENTS[N]` | Nth argument (0-indexed) | `/migrate-component Foo React Vue` → `$ARGUMENTS[0]` → "Foo" |
| `$N` | Shorthand for `$ARGUMENTS[N]` | `$0`, `$1`, etc. |
| `${CLAUDE_SESSION_ID}` | Current session ID | For logging, file naming |
| `${CLAUDE_SKILL_DIR}` | Skill directory path | Reference bundled scripts/files |

If a skill contains no `$ARGUMENTS` placeholder, Claude Code appends `ARGUMENTS: <your input>` to the end so Claude still sees what was passed.

Example with indexing:

```yaml
---
name: migrate-component
description: Migrate a component between frameworks
---

Migrate the $0 component from $1 to $2.
Preserve all existing behavior and tests.
```

Usage: `/migrate-component SearchBar React Vue` expands to "Migrate the SearchBar component from React to Vue."

## Subagent Execution

Skills can run in isolated subagent context using `context: fork`:

```yaml
---
name: deep-research
description: Research a topic thoroughly
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files
2. Analyze the code
3. Summarize findings
```

When `context: fork` is set:
- Skill content becomes the subagent's prompt
- Subagent has no access to conversation history
- Results are summarized and returned to main conversation
- `agent` field specifies the execution environment (Explore, Plan, general-purpose, or custom)

Useful for research tasks, isolated analysis, or delegated work that shouldn't inherit conversation context.

## Discovery and Listing

Skills appear in Claude's `/` menu and are discoverable via `?` in the chat. The listing shows:

- Skill name (from `name` field)
- Full description (from `description` + `when_to_use` fields, truncated at 1,536 characters)
- Argument hint (from `argument-hint` field)

If `disable-model-invocation: true`, the skill still appears in the menu for manual invocation but with a note that it's user-invocable only.

---

## Related

- **[[claude-skill-anatomy]]** — File structure and frontmatter fields
- **[[skill-creation-patterns]]** — Best practices for effective skill triggering
- **[[skill-frontmatter-reference]]** — Complete frontmatter field reference
