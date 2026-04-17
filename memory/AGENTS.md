# claude-obsidian: Agent Instructions

This repo is a Claude Code plugin **and** an Obsidian vault that builds persistent, compounding knowledge bases using Andrej Karpathy's LLM Wiki pattern.

## Skills Discovery

All skills live in `skills/<name>/SKILL.md` and are auto-discovered by Claude Code via the plugin manifest.

## Available Skills

| Skill | Trigger phrases |
|---|---|
| `wiki` | `/wiki`, set up wiki, scaffold vault |
| `wiki-ingest` | ingest, ingest this url, ingest this image, batch ingest |
| `wiki-query` | query, what do you know about, query quick:, query deep: |
| `wiki-lint` | lint the wiki, health check, find orphans |
| `save` | /save, file this conversation |
| `autoresearch` | autoresearch, autonomous research loop |
| `canvas` | /canvas, add to canvas, create canvas |
| `defuddle` | clean this url, defuddle |
| `obsidian-markdown` | obsidian syntax, wikilink, callout |
| `obsidian-bases` | obsidian bases, .base file, dynamic table |

## Key Conventions

- **Vault root**: the directory containing `wiki/` and `.raw/`
- **Hot cache**: `wiki/hot.md` (read at session start, updated at session end)
- **Source documents**: `.raw/` (immutable: agents never modify these)
- **Generated knowledge**: `wiki/` (agent-owned, links to sources via wikilinks)
- **Manifest**: `.raw/.manifest.json` tracks ingested sources (delta tracking)

## Bootstrap

When the user opens this project for the first time:

1. Read this file (`AGENTS.md`) and the project `CLAUDE.md` for full context
2. Read `skills/wiki/SKILL.md` for the orchestration pattern
3. If `wiki/hot.md` exists, read it silently to restore recent context
4. If the user types `/wiki` (or "set up wiki"), follow the wiki skill's scaffold workflow

## Reference

- Plugin homepage: https://github.com/AgriciDaniel/claude-obsidian
- Pattern source: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Cross-reference: https://github.com/kepano/obsidian-skills (authoritative Obsidian-specific skills)
