---
type: comparison
title: "Claude + Obsidian Ecosystem: Feature Matrix"
created: 2026-04-08
updated: 2026-04-08
tags:
  - ecosystem
  - competitive-analysis
  - claude-obsidian
  - cherry-picks
status: current
tier: semantic
reviewed_at: 2026-04-20
related:
  - "[[cherry-picks]]"
  - "[[LLM Wiki Pattern]]"
  - "[[Andrej Karpathy]]"
sources:
  - "[[claude-obsidian-ecosystem-research]]"
---

# Claude + Obsidian Ecosystem: Feature Matrix

> Researched 2026-04-08 | 16+ projects analyzed | See [[cherry-picks]] for action items

---

## Legend
- ✅ Has it
- ❌ Missing
- 🟡 Partial
- ⭐ Best-in-class implementation

---

## LLM Wiki Pattern Projects (Claude Code Skills)

| Feature | claude-obsidian | claudesidian | llm-knowledge-bases | llm-wiki | obsidian-wiki | obsidian-claude-pkm |
|---------|:-:|:-:|:-:|:-:|:-:|:-:|
| /wiki setup & scaffold | ✅ | 🟡 `/init-bootstrap` | 🟡 `/kb-init` | ✅ | ✅ setup.sh | 🟡 `/onboard` |
| Source ingestion | ✅ | ❌ | ✅ | ✅ | ✅ | ❌ |
| Wiki query | ✅ | ❌ | ✅ 3 depths | 🟡 | ✅ | ❌ |
| Wiki lint | ✅ | ❌ | ✅ | ✅ | ❌ | ❌ |
| /save conversation | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Autoresearch loop | ✅ | ❌ | 🟡 | ❌ | ❌ | ❌ |
| Canvas / visual layer | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Hot cache | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Delta tracking** | ❌ | ❌ | ❌ | ❌ | ✅⭐ | ❌ |
| **Multi-depth query** | ❌ | ❌ | ✅⭐ | ❌ | ❌ | ❌ |
| **URL ingestion** | ❌ | 🟡 firecrawl | ❌ | ✅ | ✅ | ❌ |
| **Vision / image ingest** | ❌ | 🟡 gemini | ❌ | ❌ | ✅⭐ | ❌ |
| **Auto-commit hooks** | ❌ | ❌ | ❌ | ✅ git | ❌ | ✅⭐ |
| **Marp / slides output** | ❌ | ❌ | ✅⭐ | ✅ | ❌ | ❌ |
| **Chart output** | ❌ | ❌ | ✅ matplotlib | ❌ | ❌ | ❌ |
| **Hybrid search (BM25+vec)** | ❌ | ❌ | ❌ | ✅⭐ qmd | ❌ | ❌ |
| **Goal cascade (PKM)** | ❌ | 🟡 PARA | ❌ | ❌ | ❌ | ✅⭐ |
| **Daily/weekly review** | ❌ | 🟡 | ❌ | ❌ | ❌ | ✅⭐ |
| **Adopt existing vault** | ❌ | ✅⭐ | ❌ | ❌ | ❌ | ✅⭐ |
| **Multi-agent compat.** | ❌ | ❌ | ❌ | ❌ | ✅⭐ | ❌ |
| **X/Twitter ingest** | ❌ | ❌ | ✅⭐ smaug | ❌ | ❌ | ❌ |
| Marketplace install | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| Public repo | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## Native Obsidian Plugins (Embedded UI)

| Feature | Claudian | Nexus (claudesidian-mcp) | infio-copilot |
|---------|:-:|:-:|:-:|
| Sidebar chat in Obsidian | ✅ | ✅ | ✅ |
| Inline edit w/ diff | ✅⭐ word-level | ✅ | ✅ |
| Plan mode | ✅⭐ Shift+Tab | ❌ | ❌ |
| @mention files/agents | ✅⭐ | ❌ | 🟡 |
| MCP server support | ✅ | ✅⭐ external | ❌ |
| Multi-tab conversations | ✅ | ❌ | ❌ |
| Workspace memory | ❌ | ✅⭐ JSONL | ✅ workspaces |
| Task management | ❌ | ✅⭐ | ❌ |
| Semantic search | ❌ | ✅ | ✅⭐ local embed |
| PDF → Markdown | ❌ | ✅ | ❌ |
| Web page capture | ❌ | ✅ | ❌ |
| Mobile support | ❌ | ✅⭐ | ❌ |
| Obsidian Sync compatible | N/A | ✅⭐ | N/A |
| Stars / popularity | ~200 est. | ~800 est. | ~300 est. |

---

## MCP Servers

| Server | Key Differentiator | Requires |
|--------|-------------------|----------|
| obsidian-mcp-tools | Templater execution + SLSA attestation | Local REST API + Smart Connections |
| obsidian-memory-mcp | AI memories as Markdown in graph view | Node 18+ |
| obsidian-claude-code-mcp | WebSocket, auto-discovers vaults | Claude Code |
| administrativetrick/obsidian-mcp | Minimal, simple | Claude Desktop |
| MarkusPfundstein/mcp-obsidian | Via REST API | Local REST API |

---

## kepano/obsidian-skills (Special — from Obsidian Creator)

Linus Kepano (Obsidian creator + Minimal theme) published official Agent Skills for Obsidian:

| Skill | What It Teaches |
|-------|----------------|
| obsidian-markdown | Obsidian Flavored Markdown (callouts, embeds, wikilinks, properties) |
| obsidian-bases | Obsidian Bases (.base files, views, filters, formulas) |
| json-canvas | JSON Canvas spec (.canvas nodes/edges/groups) |
| obsidian-cli | Vault management via Obsidian CLI |
| defuddle | Extract clean Markdown from web pages (saves tokens) |

> **Key signal**: This project validates that the Agent Skills format is the right standard.
> These skills are platform-agnostic (Claude Code, Codex, OpenCode).

---

## Popularity Snapshot (Traditional Plugins)

| Plugin | Stars | Approach |
|--------|-------|---------|
| obsidian-copilot | 5,776 | Multi-provider vault chat |
| obsidian-smart-connections | 4,357 | Semantic search + embeddings |
| obsidian-textgenerator-plugin | 1,837 | Text generation |
| chatgpt-md | 1,229 | Chat in Markdown |
| obsidian-local-gpt | 569 | Local LLM |
| obsidian-ai-tools | 272 | Supabase + OpenAI semantic search |

---

## Where claude-obsidian Wins

1. **Hot cache** — session context mechanism is unique in the ecosystem
2. **Canvas skill** — no other LLM Wiki project has a visual layer
3. **Marketplace install** — most polished install experience
4. **/save conversation** — filing chat sessions as wiki pages is unique
5. **Pub quality docs** — README, install guide, demo GIFs
6. **Dual repo** (public + community) — distribution model unique

## Where claude-obsidian Has Gaps

See [[cherry-picks]] for prioritized list with implementation notes.

Top 5 gaps by impact:
1. No delta tracking → re-ingests everything on every compile
2. No URL ingestion → forces manual copy-paste
3. No auto-commit → vault changes aren't versioned automatically
4. No multi-depth query → one mode for all questions
5. No vision input → can't ingest screenshots or images
