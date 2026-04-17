---
type: concept
title: "Per-Project Knowledge Management"
created: 2026-04-17
updated: 2026-04-17
tags:
  - concept
  - llm-wiki
  - architecture
  - knowledge-management
  - multi-project
status: current
related:
  - "[[LLM Wiki Pattern]]"
  - "[[Compounding Knowledge]]"
  - "[[Andrej Karpathy]]"
  - "[[vscode-gcode-extension]]"
  - "[[Ar9av-obsidian-wiki]]"
---

# Per-Project Knowledge Management

How should project-specific knowledge be organized in an LLM Wiki architecture? This page synthesizes research on Karpathy's LLM Wiki pattern, Obsidian multi-vault strategies, and real-world implementations to guide decisions for VSCode extension projects and similar codebases.

## Three Core Options

### Option 1: Centralized Shared Wiki (Current Pattern)

**Structure**: Single vault at `~/Projects/claude-config/memory/wiki/` with all knowledge (generic patterns, project-specific details, solutions).

**How project knowledge appears**: Dedicated folders (e.g., `wiki/projects/vscode-gcode-extension/`, `wiki/entities/vscode-gcode-extension.md`, tags like `#vscode-gcode`).

**Advantages**:
- **Network effects**: Cross-project pattern discovery. A formatter bug solution in vscode-gcode might apply to another VSCode extension.
- **Unified search**: All knowledge queryable in one MCP call; no context-switching between vaults.
- **Simpler setup**: New agents inherit the entire knowledge base without new MCP configuration.
- **Reuse at scale**: Shared patterns (LSP architecture, TypeScript typing gotchas, Obsidian MCP wiring) benefit all projects.
- **Proven at ~40 pages**: This wiki's current structure (39 pages, 4 sources ingested) handles mixed content well.

**Disadvantages**:
- **Cognitive load**: Searchers see results from unrelated projects; must filter/refine queries.
- **Permission complexity**: Private projects' knowledge lives in shared vault (trust model issue).
- **Branching chaos**: If one agent deep-dives on vscode-gcode while another on a different project, both must eventually merge and resolve naming/linking conflicts.

**Verdict**: Works well for <500 pages when projects share similar architectures (all LSP, all TypeScript, all Obsidian tooling). Breaks down if domain-specific knowledge (finance, medical) or competing conventions emerge.

---

### Option 2: Per-Project Vault Committed to Repo

**Structure**: Each project gets its own Obsidian vault committed to the repo (e.g., `.claude/wiki/` in vscode-gcode-extension). Travels with code, isolated by default.

**How it looks**:
```
vscode-gcode-extension/
├── .claude/
│   ├── CLAUDE.md
│   ├── docs/
│   └── wiki/                    ← project-specific vault
│       ├── README.md
│       ├── index.md
│       ├── solutions/
│       │   ├── workspace-symbol-architecture.md
│       │   └── lsp-file-watcher-linux.md
│       ├── entities/
│       │   └── vscode-gcode-extension.md
│       └── concepts/
│           └── gcode-lsp-architecture.md
```

**Advantages**:
- **Isolation**: Project-specific knowledge never leaks between repos; no cross-project pollution.
- **Travel**: Clone the repo → full knowledge base available. No separate MCP setup required.
- **Versioning**: Wiki history tracked in git; revert broken knowledge with commits.
- **Multi-team**: Different teams can maintain separate wikis for similar projects without merge conflicts.
- **Proven pattern**: [[Ar9av-obsidian-wiki]] framework designed to support this.

**Disadvantages**:
- **No network effects**: A formatter pattern in vscode-gcode won't help you on the next LSP extension.
- **Duplication**: Solved TypeScript/LSP problems documented three times across three projects.
- **MCP overhead**: Each project's MCP config points to a different vault location; agents must reconfigure on context-switch.
- **Large repos**: Adds ~100-500 KB of .md files to git history per mature project.
- **Discovery friction**: Must navigate to the right repo to find solutions.

**Verdict**: Ideal for independent, proprietary, or domain-specific projects (medical device firmware, finance modeling) where knowledge transfer risk is real. Poor fit for patterns that cross many projects.

---

### Option 3: Hybrid (Recommended)

**Structure**: 
- **Shared vault** (`~/Projects/claude-config/memory/wiki/`) holds reusable architectural patterns, generic knowledge, and cross-project insights (LSP, TypeScript, Obsidian MCP, debugging, performance).
- **Per-project wiki** (`.claude/wiki/` in each repo) holds project-specific decisions, solution docs, codebase snapshots, and domain knowledge unique to that codebase.

**How they interoperate**:
1. **Shared patterns flow down**: New LSP pattern discovered in project A is documented in the central wiki, available to all projects.
2. **Project insights flow up**: A clever solution from vscode-gcode's edge-case handling gets abstracted and generalized into shared wiki once it proves broadly useful.
3. **MCP points to both**: Agent can search shared wiki for patterns, then navigate to project wiki for codebase specifics.

**Example split**:
- **Shared wiki**: [[gcode-lsp-architecture]] (applies to any LSP extension), [[TypeScript Typing Patterns]], [[Obsidian MCP Wiring]]
- **Project wiki**: workspace-symbol-architecture (vscode-gcode specific), visualizer variable-resolution-pipeline, Linux file-watcher race condition (implementation detail)

**Advantages**:
- **Best of both**: Reuse + isolation. Shared patterns accelerate new projects; project-specific knowledge doesn't bloat the shared vault.
- **MCP scalability**: Two-vault search works at ~40 shared pages + 30-50 per-project pages without performance cliff.
- **Natural growth**: Start centralized (Option 1), split when a project becomes large enough (>50 pages) or needs privacy.
- **Knowledge migration**: Move knowledge up to shared vault over time as understanding matures.
- **Team onboarding**: New team members start with shared patterns, then drill into project wiki.

**Disadvantages**:
- **More complex**: Agents must decide "shared or project-specific?" on every page creation.
- **Boundary creep**: Temptation to keep everything in shared vault for convenience.
- **Naming collisions**: "Architecture" in shared wiki vs. "architecture" in project wiki (mitigated by namespacing: `wiki/entities/vscode-gcode-architecture.md`).

**How to govern the split**:
- **Ask: "Will the next N projects benefit?"** If yes, shared wiki. If no or "maybe," project wiki.
- **Shared wiki criteria**: Cross-functional patterns (LSP, testing, TypeScript traps), technologies, architectures, debugging strategies.
- **Project wiki criteria**: Domain knowledge, codebase-specific decisions, ADRs, performance notes tied to specific code locations, visualizer optimization secrets.
- **Rule of thumb**: If it references `src/` paths, it belongs in project wiki. If it's abstract (patterns, principles), shared wiki.

---

## Implementation Path for vscode-gcode-extension

Given the current state:
- Shared wiki has 39 pages with 7 vscode-gcode-specific solutions already ingested
- vscode-gcode is a flagship project with reusable LSP/TypeScript patterns
- Other projects (future Haas dialect plugin, G-code post-processor) will likely reuse architecture

**Recommended approach**: **Hybrid** starting point:

1. **Keep current shared wiki structure** (don't refactor yet).
2. **Create `.claude/wiki/` in vscode-gcode-extension** for future project-specific knowledge (e.g., visualizer optimization traces, dialect-specific bugs, manufacturing-domain notes).
3. **Apply this rule going forward**:
   - New solution docs that apply to "any LSP extension" → shared wiki
   - Docs about "vscode-gcode's visualizer coordinate system" or "Haas dialect quirks" → project wiki
4. **Audit in 6 months**: Once project wiki reaches 30+ pages, refactor shared wiki to extract pure patterns (Option 3 fully realized).

**MCP setup**: Update vscode-gcode's CLAUDE.md to point to both:
```markdown
## Knowledge Management

- Shared patterns, architecture, and cross-project solutions: `~/Projects/claude-config/memory/wiki/`
- vscode-gcode-specific codebase knowledge: `./.claude/wiki/`

Use `/wiki-query` from shared vault, `./.claude/wiki/` from project-specific.
```

---

## Karpathy's Original Pattern

Karpathy's LLM Wiki gist (2024) emphasizes:
- **Centralized vault** (one location, not per-project) to maximize reuse
- **Layered structure**: `sources/` (raw inputs), `entities/` (extracted), `concepts/` (synthesized), `solutions/` (applied)
- **Single MCP agent** ("research librarian") maintaining the vault
- **Committed to git** with branch protections and peer review (implies one shared repo)

**Key insight**: Karpathy's pattern assumes homogeneous knowledge (personal research notes) in one domain. For heterogeneous codebases (LSP extensions vs. cloud platforms vs. embedded systems), adaptation to hybrid is natural.

---

## Decision Matrix

| Criterion | Shared (Option 1) | Per-Project (Option 2) | Hybrid (Option 3) |
|-----------|-------------------|------------------------|-------------------|
| **Cross-project reuse** | Excellent | Poor | Excellent |
| **Isolation / Privacy** | Poor | Excellent | Good |
| **Setup complexity** | Simple | Moderate | Moderate |
| **Search performance** | Fast | Fast | Fast (two vaults) |
| **Duplication risk** | Low | High | Low |
| **Scalability** | <500 pages | Unlimited per project | <1000 shared + per-project |
| **Team adoption** | Easiest | Hardest | Balanced |
| **Best for** | Homogeneous patterns | Private/domain-specific | Mixed ecosystem |

---

## Related Research

- [[LLM Wiki Pattern]] — Karpathy's foundational pattern
- [[Ar9av-obsidian-wiki]] — Multi-agent framework supporting per-project wikis
- [[claude-obsidian-ecosystem]] — Feature comparison (16 projects analyzed)

---

## Sources

- Karpathy, A. (2024). LLM Wiki Gist. https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
- Medium. (2025). "From Chaos to Clarity: My Multi-Vault Approach to Obsidian Knowledge Management" by PTKM. https://medium.com/obsidian-observer/from-chaos-to-clarity-my-multi-vault-approach-to-obsidian-knowledge-management-6868e5597a8c
- MindStudio. (2026). "What Is Andrej Karpathy's LLM Wiki?" https://www.mindstudio.ai/blog/andrej-karpathy-llm-wiki-knowledge-base-claude-code
- DEV Community. (2024-2026). Various LLM Wiki implementations and extensions. https://dev.to/
