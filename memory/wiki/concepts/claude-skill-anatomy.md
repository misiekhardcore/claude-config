---
name: Claude skill anatomy
description: The structure of a Claude Code skill file - frontmatter fields, body conventions, directory layout
type: concept
tags: [claude-code, skills]
status: evergreen
created: 2026-04-17
related:
  - "[[skill-invocation-model]]"
  - "[[skill-creation-patterns]]"
  - "[[skill-frontmatter-reference]]"
---

# Claude Skill Anatomy

Claude Code skills are declarative, structured files that teach Claude to perform specialized tasks. Every skill has a consistent anatomy: YAML frontmatter governing behavior, markdown content with instructions, and optional supporting files for scale.

## File Structure

Each skill is a directory containing a required `SKILL.md` file and optional supporting resources:

```
my-skill/
├── SKILL.md                 # Required: frontmatter + instructions
├── reference.md             # Optional: detailed docs loaded on demand
├── examples/                # Optional: example outputs
│   └── sample.md
├── templates/               # Optional: templates Claude fills in
│   └── report-template.md
└── scripts/                 # Optional: executable code Claude can run
    └── helper.py
```

### SKILL.md: The Core File

Every skill must contain `SKILL.md` with two parts:

1. **YAML frontmatter** (between `---` markers): Metadata controlling when and how the skill runs
2. **Markdown body**: Instructions Claude follows when the skill is invoked

```yaml
---
name: my-skill
description: What this skill does and when to use it
---

# Instructions
Your skill content here...
```

## Directory Locations

Skills are discovered based on where they're stored. Priority order (highest to lowest):

| Scope | Path | Applies to |
|-------|------|-----------|
| Enterprise | Managed settings | All org users |
| Personal | `~/.claude/skills/<skill-name>/` | All user's projects |
| Project | `.claude/skills/<skill-name>/` | This repo only |
| Plugin | `<plugin>/skills/<skill-name>/` | Where plugin enabled |

When skills share names, higher-priority locations override. Plugin skills use namespaced names (`plugin-name:skill-name`) to avoid conflicts.

## Supporting Files

### Reference Files

Large reference material doesn't need to load into context every time. Reference from `SKILL.md`:

```markdown
For complete API details, see [reference.md](reference.md)
For usage examples, see [examples.md](examples.md)
```

Claude loads reference files only when relevant to the task, keeping `SKILL.md` lean (<500 lines). Best for:
- API documentation
- Detailed specifications
- Example collections
- Domain knowledge

### Executable Scripts

Skills can bundle executable code (Python, shell, etc.) in `scripts/`. Claude runs scripts without loading them into context — execution happens automatically:

```markdown
Run the analysis script:
\`\`\`bash
python ${CLAUDE_SKILL_DIR}/scripts/analyze.py $ARGUMENTS
\`\`\`
```

Use the `${CLAUDE_SKILL_DIR}` variable to reference bundled files regardless of current working directory.

### Templates

Provide templates Claude fills in for consistent output format:

```
templates/
├── report-template.md
├── proposal-template.html
└── commit-template.txt
```

Reference templates in instructions so Claude knows what to use.

## Content Patterns

### Reference Content

Used for knowledge and guidance Claude applies to current work:

```markdown
---
name: api-conventions
description: API design patterns for this codebase
---

When writing API endpoints:
- Use RESTful naming conventions
- Return consistent error formats
- Include request validation
```

This content runs **inline** so Claude can apply it alongside conversation context.

### Task Content

Step-by-step instructions for a specific action (deployments, commits, code generation):

```markdown
---
name: deploy
description: Deploy the application to production
disable-model-invocation: true
---

1. Run the test suite
2. Build the application
3. Push to the deployment target
4. Verify deployment succeeded
```

Task content is often invoked **manually** with `/skill-name` rather than automatically by Claude.

### Hybrid Content

Many skills combine reference (persistent knowledge) with task (specific action):

```markdown
---
name: commit
description: Stage and commit changes following conventions
---

## Commit conventions (reference)
- feat: new feature
- fix: bug fix
- refactor: code restructuring

## Task: Create a commit
1. Stage files: git add
2. Create message following conventions above
3. Commit: git commit
```

## Key Principles

**Progressive disclosure**: Metadata loads always (~100 words), full content loads when invoked (<500 lines ideal), supporting files load on demand (unlimited). This scales knowledge without context cost until needed.

**Single source of truth**: No duplication between frontmatter and body. If important, mention once in the right place — either frontmatter fields or content.

**Declarative over imperative**: Prefer explaining why things matter over rigid MUSTs. LLMs respond better to theory of mind — understanding the reasoning — than absolute commands.

**Lean SKILL.md**: Keep main file focused. Move reference material, large examples, or API specs to supporting files. This makes the skill easier to understand and cheaper to invoke.

## Lifecycle

When a skill is invoked:
1. Skill is rendered (frontmatter processed, substitutions expanded)
2. Full content enters conversation as a single message
3. Content stays in context for the entire session
4. On context overflow (auto-compaction), most recent 5,000 tokens of each skill re-attach within a 25,000-token combined budget
5. Older skills may be dropped if budget exhausted; re-invoke if needed

Content is not re-read on subsequent turns, so write standing instructions (applying throughout a task) rather than one-time steps.

---

## Related

- **[[skill-invocation-model]]** — How skills are triggered, discovered, and executed
- **[[skill-creation-patterns]]** — Patterns and best practices for effective skills
- **[[skill-frontmatter-reference]]** — Complete list of valid frontmatter fields and their effects
