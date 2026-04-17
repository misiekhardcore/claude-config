---
name: Claude Code skills - official docs
description: Official Anthropic documentation on custom slash commands and skill creation
type: source
tags: [claude-code, skills, official]
status: evergreen
created: 2026-04-17
related:
  - "[[claude-skill-anatomy]]"
  - "[[skill-invocation-model]]"
  - "[[skill-creation-patterns]]"
---

# Claude Code Skills - Official Anthropic Documentation

## Source Information

**Official documentation**: https://code.claude.com/docs/en/slash-commands  
**Organization**: Anthropic  
**Confidence**: High (official source)  
**Last fetched**: 2026-04-17

This page summarizes the official Anthropic documentation on Claude Code custom skills and slash commands. The documentation covers skill anatomy, invocation patterns, frontmatter fields, and advanced patterns.

## Key Definitions

**Skill**: A directory containing `SKILL.md` with YAML frontmatter and markdown instructions. Skills extend Claude's capabilities by teaching it specialized workflows.

**Slash command** or **manual invocation**: User explicitly invokes a skill by typing `/skill-name` with optional arguments.

**Automatic invocation**: Claude loads and applies a skill automatically when the skill's description matches the user's request and the skill has `disable-model-invocation: false`.

**Bundled skills**: Official skills shipped with Claude Code (e.g., `/simplify`, `/debug`, `/loop`, `/batch`). These are prompt-based, not hardcoded logic.

## File Structure

Every skill has this structure:

```
skill-name/
├── SKILL.md           # Required: frontmatter + instructions
├── reference.md       # Optional: detailed reference docs
├── examples/          # Optional: example outputs
├── templates/         # Optional: templates Claude fills
└── scripts/           # Optional: executable code
```

Only `SKILL.md` is required. Other files are optional and loaded on demand to keep context lean.

## Frontmatter Fields

All fields in YAML frontmatter are optional except where recommended. Key fields:

| Field | Required | Description |
|-------|----------|-------------|
| `name` | No | Skill identifier (lowercase, hyphens, max 64 chars). Defaults to directory name. Becomes the `/slash-command`. |
| `description` | Recommended | What the skill does and when to use it. This is the primary triggering mechanism for automatic invocation. Must include both action and trigger contexts. |
| `when_to_use` | No | Additional trigger context. Appended to description. |
| `argument-hint` | No | Hint shown during `/` autocomplete (e.g., `[issue-number]`). |
| `disable-model-invocation` | No | Set to `true` to prevent automatic invocation. Only user can invoke with `/`. |
| `user-invocable` | No | Set to `false` to hide from user's `/` menu. Only Claude can invoke. |
| `allowed-tools` | No | Space-separated or YAML list of tools Claude can use without asking permission while skill is active. |
| `model` | No | Model to use when this skill is active. |
| `effort` | No | Effort level (`low`, `medium`, `high`, `xhigh`, `max`) when skill is active. |
| `context` | No | Set to `fork` to run skill in isolated subagent context. |
| `agent` | No | Which subagent type to use when `context: fork`. Options: `Explore`, `Plan`, `general-purpose`, or custom. |
| `hooks` | No | Hooks scoped to this skill's lifecycle. |
| `paths` | No | Glob patterns limiting when skill auto-activates (e.g., only for certain file types). |
| `shell` | No | Shell to use for inline commands: `bash` (default) or `powershell`. |

## String Substitutions

Skills support dynamic substitution for arguments and environment variables:

| Variable | Value |
|----------|-------|
| `$ARGUMENTS` | All arguments passed by user |
| `$ARGUMENTS[N]` or `$N` | Nth argument (0-indexed) |
| `${CLAUDE_SESSION_ID}` | Current session ID |
| `${CLAUDE_SKILL_DIR}` | Path to skill directory |

Example: `/migrate-component Foo React Vue` → `$0`="Foo", `$1`="React", `$2`="Vue"

## Skill Discovery and Loading

Skills are discovered based on location:

| Scope | Path | Who sees |
|-------|------|----------|
| Enterprise | Managed settings | All org users |
| Personal | `~/.claude/skills/<name>/` | All user's projects |
| Project | `.claude/skills/<name>/` | This repo only |
| Plugin | `<plugin>/skills/<name>/` | Where plugin enabled |

Higher-priority scopes override lower ones. Plugin skills use namespacing (`plugin-name:skill-name`) to avoid conflicts.

**Live change detection**: `.claude/skills/` directories are watched during a session. Adding, editing, or removing skills takes effect immediately without restart.

## Invocation Control

### Automatic vs. Manual

Claude decides whether to invoke a skill based on its `description` field. The description is always in context so Claude knows what capabilities are available.

**Important**: Claude only invokes skills for tasks it can't easily handle directly. Simple one-step queries (e.g., "read this file") usually won't trigger a skill, even with perfect description match.

### Controlling Who Can Invoke

| Setting | User Can Invoke | Claude Can Invoke | Description in Context |
|---------|-----------------|-------------------|------------------------|
| Default | Yes | Yes | Yes |
| `disable-model-invocation: true` | Yes | No | No |
| `user-invocable: false` | No | Yes | Yes |

Use `disable-model-invocation: true` for side-effect operations (deploy, commit, delete) where timing/safety matters.

Use `user-invocable: false` for background knowledge that's useful to Claude but not an actionable command.

## Content Lifecycle

1. **Startup**: Skill descriptions always available (~100 words per skill)
2. **Invocation**: Full `SKILL.md` enters conversation as single message, stays in context
3. **Persistence**: Content remains through entire session
4. **Compaction**: During auto-compaction, most recent 5,000 tokens of each invoked skill re-attach within 25,000-token combined budget, prioritizing most recent skills

This means invoking many skills can exhaust re-attachment budget; older skills may be dropped.

## Advanced Patterns

### Dynamic Context Injection

Use `` !`command` `` to run shell commands before the skill is sent to Claude:

```markdown
## PR Context
- Diff: !`gh pr diff`
- Comments: !`gh pr view --comments`
```

Commands run first, output replaces placeholder. Claude receives actual data, not the command itself.

Multi-line commands use ` ```! ` fenced blocks.

### Subagent Execution

Set `context: fork` to run skill in isolated subagent:

```yaml
---
name: research
description: Research topic
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find files using Glob
2. Analyze code
3. Summarize findings
```

Subagent has no conversation history access, receives skill content as its prompt. Results summarized and returned to main conversation.

### Permission Pre-approval

The `allowed-tools` field grants tool access without per-use prompts when skill is active:

```yaml
---
name: deploy
allowed-tools: Bash(git *) Bash(curl *)
---
```

Permission settings still govern baseline access; `allowed-tools` supplements, doesn't restrict.

## Performance and Context

Skill descriptions load into context so Claude knows available capabilities. If you have many skills, descriptions are truncated to stay within context budget (1% of context window, ~8KB default).

To raise the limit, set `SLASH_COMMAND_TOOL_CHAR_BUDGET` environment variable. Or trim `description` + `when_to_use` text at the source — combined character cap is 1,536 characters per skill regardless of budget.

**Front-load key use case**: Put the most important triggering context first in the description, since it may be truncated.

## Key Recommendations

From official docs:

1. **Keep `SKILL.md` under 500 lines** — move reference material to supporting files
2. **Make descriptions "pushy"** — explicitly list trigger contexts and phrase examples
3. **Reference supporting files clearly** — tell Claude when to load them and why
4. **Explain the why** — help Claude generalize beyond exact instructions
5. **Use progressive disclosure** — metadata always, content on demand, supporting files on request
6. **Include examples** — show expected input/output format
7. **Plan for reuse** — write skills that work across multiple scenarios, not just one example

## Bundled Skills

Claude Code includes these prompt-based bundled skills:

- `/simplify` — Review code for reuse and quality
- `/batch` — Process many items in parallel
- `/debug` — Troubleshoot issues systematically
- `/loop` — Run a command on recurring interval
- `/claude-api` — Build and optimize Claude API / Anthropic SDK apps

These are templates Claude follows when invoked; they're not hardcoded.

## Notes

- Custom commands (`.claude/commands/`) and skills (`.claude/skills/`) coexist. Skills are recommended for new development due to supporting file capability and lifecycle features.
- Skills follow the open [Agent Skills](https://agentskills.io) standard, extended by Claude Code with invocation control and dynamic context injection.
- The [skill-creator](/en/commands) plugin (built into superpowers) provides interactive guidance for creating and evaluating skills.

---

## Reference

Full official documentation: https://code.claude.com/docs/en/slash-commands
