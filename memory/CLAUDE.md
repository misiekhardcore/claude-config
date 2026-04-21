# claude-obsidian — Claude + Obsidian Wiki Vault

This folder is both a Claude Code plugin and an Obsidian vault.

**Plugin name:** `claude-obsidian`
**Skills:** `/wiki`, `/wiki-ingest`, `/wiki-query`, `/wiki-lint`
**Vault path:** This directory (open in Obsidian directly)

## What This Vault Is For

This vault demonstrates the LLM Wiki pattern — a persistent, compounding knowledge base for Claude + Obsidian. Drop any source, ask any question, and the wiki grows richer with every session.

## Vault Structure

```
.raw/           source documents — immutable, Claude reads but never modifies
wiki/           Claude-generated knowledge base
_templates/     Obsidian Templater templates
_attachments/   images and PDFs referenced by wiki pages
```

## How to Use

Drop a source file into `.raw/`, then tell Claude: "ingest [filename]".

Ask any question. Claude reads the index first, then drills into relevant pages.

Run `/wiki` to scaffold a new vault or check setup status.

Run "lint the wiki" every 10-15 ingests to catch orphans and gaps.

## Cross-Project Access

To reference this wiki from another Claude Code project, add to that project's CLAUDE.md:

```markdown
## Wiki Knowledge Base
Path: /path/to/this/vault

When you need context not already in this project:
1. Read wiki/hot.md first (recent context, ~500 words)
2. If not enough, read wiki/index.md
3. If you need domain specifics, read wiki/<domain>/_index.md
4. Only then read individual wiki pages

Do NOT read the wiki for general coding questions or things already in this project.
```

## Plugin Skills

| Skill | Trigger |
|-------|---------|
| `/wiki` | Setup, scaffold, route to sub-skills |
| `ingest [source]` | Single or batch source ingestion |
| `query: [question]` | Answer from wiki content |
| `lint the wiki` | Health check |
| `/save` | File the current conversation as a structured wiki note |
| `/autoresearch [topic]` | Autonomous research loop: search, fetch, synthesize, file |
| `/canvas` | Visual layer: add images, PDFs, notes to Obsidian canvas |

## Ingest Rules

Single-source ingests via `wiki-ingest` require an interactive discussion before writing pages. After reading the source, Claude must ask:
- What to emphasize
- How granular to go
- What existing wiki context to link against

**Escape hatch:** Say "just ingest it" or "auto-ingest" to skip the discussion and proceed automatically.

The `/autoresearch` pipeline is exempt — it is intentionally autonomous and skips the discussion by design.

## MCP (Optional)

If you configured the MCP server, Claude can read and write vault notes directly.
See `skills/wiki/references/mcp-setup.md` for setup instructions.

---

## Maintenance Rules

The schema (directory map, page types), ingest procedure, contradiction handling, quality standards, and log format are defined in [`skills/wiki/references/maintenance-rules.md`](skills/wiki/references/maintenance-rules.md).

The frontmatter field schema (universal fields, typed relationship fields, type-specific additions) is defined in [`skills/wiki/references/frontmatter.md`](skills/wiki/references/frontmatter.md).

Read both files before any ingest, autoresearch, or significant wiki operation.

## Repository Awareness

- ALWAYS verify the correct target repository before creating PRs, issues, or running cross-repo searches. When a user references a PR/issue number, confirm which repo it belongs to from the current working directory and recent context.
- When the user says "this repo", confirm by running `git remote -v` or `pwd` first.

## Scope Discipline

- Do NOT add backwards-compatibility shims, dual-format support, or migration paths unless explicitly requested. Prefer the clean correct solution.
- Do NOT include out-of-scope sections, stretch goals, or speculative features in proposals/docs unless asked.
- When rebasing or migrating, only carry over the files explicitly in scope; flag unrelated files rather than silently including them.

## Documentation Hygiene

- Before adding content to CLAUDE.md or other docs, grep existing docs to avoid duplication. Prefer extracting long rule/schema blocks (>50 lines) into dedicated reference files and linking from CLAUDE.md.
- After any commit, verify with `git status` that no expected files (especially in `.claude/`) remain untracked.
