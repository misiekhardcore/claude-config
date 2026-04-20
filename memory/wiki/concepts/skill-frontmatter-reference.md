---
name: Skill frontmatter reference
description: Definitive reference for all valid YAML frontmatter fields in Claude Code skills
type: concept
tags: [claude-code, skills, reference]
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
  - "[[claude-code-skills-official-docs]]"
---

# Skill Frontmatter Reference

Complete reference for all YAML frontmatter fields available in `SKILL.md`. All fields are optional unless marked otherwise.

## Basic Metadata

### `name`
**Type**: string  
**Required**: No (defaults to directory name)  
**Constraints**: Lowercase letters, numbers, hyphens; max 64 characters  
**Effect**: Becomes the `/slash-command` name and identifier in listings

```yaml
---
name: my-skill
---
```

Result: User types `/my-skill` to invoke

### `description`
**Type**: string  
**Required**: Recommended  
**Constraints**: None (soft limit ~200 words for conciseness)  
**Effect**: Primary mechanism controlling automatic invocation; always visible in skill listings

The description tells Claude when to use the skill automatically. Must include both:
1. What the skill does (action-oriented)
2. When to use it (trigger phrases, contexts, scenarios)

```yaml
---
description: >
  Explains code using visual diagrams and analogies.
  Use when explaining how code works, teaching about a codebase,
  or when the user asks "how does this work?"
---
```

Claude tends to undertrigger skills, so make descriptions "pushy" — be explicit about trigger contexts.

### `when_to_use`
**Type**: string  
**Required**: No  
**Effect**: Appended to `description` in skill listing; combined with `description` under 1,536-character cap

Additional context for when Claude should invoke the skill. Useful for separating the action (description) from trigger contexts (when_to_use).

```yaml
---
description: Explains code using visual diagrams and analogies.
when_to_use: >
  Use when explaining how code works, teaching about a codebase,
  or when the user asks "how does this work?"
---
```

## Invocation Control

### `disable-model-invocation`
**Type**: boolean  
**Default**: `false`  
**Effect**: When `true`, prevents Claude from automatically invoking the skill; only user can invoke with `/name`

Use for side-effect operations where timing/safety is critical (deployments, commits, deletes):

```yaml
---
name: deploy
disable-model-invocation: true
---
```

With this field, the skill description is **not** loaded into context, so Claude won't trigger it. User can still invoke `/deploy` explicitly.

### `user-invocable`
**Type**: boolean  
**Default**: `true`  
**Effect**: When `false`, hides skill from user's `/` menu; only Claude can invoke

Use for background knowledge that's useful to Claude but not an actionable command:

```yaml
---
name: legacy-system-context
user-invocable: false
---
```

User cannot type `/legacy-system-context` (it's hidden), but Claude can invoke it when relevant.

## Execution Environment

### `model`
**Type**: string  
**Required**: No  
**Effect**: Model used when this skill is invoked; overrides session model

Specify when a skill requires a particular model:

```yaml
---
model: claude-opus-4-1
---
```

### `effort`
**Type**: string (enum)  
**Default**: Inherits from session  
**Values**: `low`, `medium`, `high`, `xhigh`, `max` (availability depends on model)  
**Effect**: Effort level when this skill is invoked; overrides session effort level

```yaml
---
effort: xhigh
---
```

Use for CPU-intensive skills (deep research, complex analysis) that benefit from extended thinking.

### `agent`
**Type**: string  
**Required**: No (only meaningful with `context: fork`)  
**Values**: `Explore`, `Plan`, `general-purpose`, or custom agent name  
**Default**: `general-purpose`  
**Effect**: Which subagent type executes the skill when `context: fork`

```yaml
---
context: fork
agent: Explore
---
```

- `Explore` — read-only, optimized for codebase exploration (Glob, Grep, Read)
- `Plan` — planning and architecture (diagram, outline, reasoning)
- `general-purpose` — full tool access (default)

### `context`
**Type**: string  
**Required**: No  
**Values**: `fork` (only valid value)  
**Effect**: Runs skill in isolated subagent context; skill content becomes subagent's prompt

```yaml
---
context: fork
agent: Explore
---
```

Subagent has:
- No access to conversation history
- `agent` type's tools and configuration
- Skill content as the prompt

Results are summarized and returned to main conversation.

## Tool Access and Permissions

### `allowed-tools`
**Type**: string or list  
**Required**: No  
**Effect**: Pre-approves listed tools; Claude can use them without permission prompts when skill is active

Pre-approval only applies during skill execution. Your baseline permission settings still govern; this supplements without restricting.

```yaml
---
allowed-tools: Bash(git *) Bash(curl *) Read
---
```

Or as YAML list:

```yaml
---
allowed-tools:
  - Bash(git *)
  - Bash(curl *)
  - Read
---
```

Useful for safe, well-scoped operations (e.g., git commands for a deploy skill).

## User Interface

### `argument-hint`
**Type**: string  
**Required**: No  
**Effect**: Hint shown during `/` autocomplete menu

```yaml
---
argument-hint: "[issue-number]"
---
```

When user types `/fix-issue`, the hint displays: `/fix-issue [issue-number]`

For multiple arguments:

```yaml
---
argument-hint: "[component] [from-framework] [to-framework]"
---
```

## Hooks and Lifecycle

### `hooks`
**Type**: object  
**Required**: No  
**Effect**: Hooks scoped to this skill's lifecycle

Hook types (typically managed in settings.json, but can be scoped to a skill):

```yaml
---
hooks:
  on-skill-start: |
    echo "Skill starting..."
  on-skill-end: |
    echo "Skill complete"
---
```

See [Hooks](/en/hooks) documentation for full syntax and available hook types.

## Filtering and Scope

### `paths`
**Type**: string or list  
**Required**: No  
**Effect**: Glob patterns limiting when skill auto-activates

Skill loads automatically only when working with files matching the patterns:

```yaml
---
paths: "**/*.py"
---
```

As list:

```yaml
---
paths:
  - "**/*.py"
  - "**/*.ts"
---
```

Uses same format as [path-specific rules](/en/memory#path-specific-rules).

Useful for skills specialized to certain file types or directories (Python linter skill, TypeScript migration skill, etc.).

## Shell Configuration

### `shell`
**Type**: string  
**Default**: `bash`  
**Values**: `bash`, `powershell`  
**Effect**: Shell used for `` !`command` `` and ` ```! ` blocks

```yaml
---
shell: powershell
---
```

On Windows, `powershell` setting runs inline commands via PowerShell. Requires `CLAUDE_CODE_USE_POWERSHELL_TOOL=1`.

## Complete Example

```yaml
---
# Metadata
name: my-research-skill
description: >
  Performs deep research on topics using codebase analysis.
  Use when you need thorough understanding of how something works
  in the codebase, when exploring unfamiliar code, or when the user
  asks "how does X work?" about internal systems.
when_to_use: >
  Particularly useful for legacy systems, understanding architecture,
  or tracing data flow through complex code.

# Invocation
disable-model-invocation: false
user-invocable: true
argument-hint: "[topic-or-query]"

# Execution
context: fork
agent: Explore
effort: high
model: claude-opus-4-1

# Tools
allowed-tools:
  - Glob(**/*.*)
  - Grep
  - Read

# Filtering
paths:
  - "src/**"
  - "lib/**"

# Hooks
hooks:
  on-skill-start: |
    echo "Starting research on $ARGUMENTS..."
---

# Research Instructions Here...
```

## Invalid Fields

Common mistakes to avoid:

| Field | Issue | Use instead |
|-------|-------|-------------|
| `allowed-commands` | Not a valid field | `allowed-tools` |
| `auto-invoke` | Invalid field name | `disable-model-invocation` |
| `max-tokens` | Not supported in skill frontmatter | Set via `effort` field |
| `permissions` | Not frontmatter syntax | Set in `.claude/settings.json` |

## Defaults and Interaction

When fields are omitted:

- **`name`**: Uses directory name
- **`description`**: Uses first paragraph of markdown content
- **`disable-model-invocation`**: `false` (Claude can auto-invoke)
- **`user-invocable`**: `true` (user can invoke)
- **`model`**: Current session model
- **`effort`**: Current session effort level
- **`agent`**: `general-purpose` (if `context: fork`)
- **`allowed-tools`**: None (use existing permissions)
- **`paths`**: None (skill available everywhere)
- **`shell`**: `bash`

## Field Priority and Conflicts

When the same skill appears in multiple locations (enterprise > personal > project), the entire frontmatter from the highest-priority location is used. Lower-priority versions are completely replaced (no merging of fields).

If a skill and a custom command share the same name, **the skill takes precedence**.

---

## Related

- **[[claude-skill-anatomy]]** — Overall skill structure and file organization
- **[[skill-invocation-model]]** — How invocation control fields affect behavior
- **[[claude-code-skills-official-docs]]** — Official documentation source
