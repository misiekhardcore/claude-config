---
type: concept
title: "CLAUDE.md Sizing"
created: 2026-04-21
updated: 2026-04-21
tags:
  - claude-code
  - tokens
  - claude-md
  - memory
status: current
confidence: EXTRACTED
evidence:
  - "[[claude-code-costs-docs]]"
  - "[[claude-code-token-optimization-2026]]"
related:
  - "[[claude-code-system-prompt-composition]]"
  - "[[sessionstart-hook-context-injection]]"
---

# CLAUDE.md Sizing

CLAUDE.md is the biggest manually-controllable contribution to the system-prompt token count. It is loaded verbatim at session start and repeated on every turn.

## Targets

| Scope | Recommended | Hard cap |
|---|---|---|
| Global `~/.claude/CLAUDE.md` | <50 lines | 100 lines |
| Project `./CLAUDE.md` | <200 lines | 300 lines |
| Subdirectory `./sub/CLAUDE.md` | <50 lines | 100 lines |

Official Anthropic guidance (code.claude.com/docs/en/costs): **"Aim to keep CLAUDE.md under 200 lines by including only essentials"**.

Community target (buildtolaunch 2026): **under 500 tokens** total for a minimal template; 200 tokens for the rules-and-pointers pattern.

## Content rules

**Include:**
- Hard preferences (tone, formatting, safety)
- Project-specific invariants ("never modify `/config` without confirm")
- Pointers to reference docs with conditional trigger ("read `REFERENCE.md` **only when** debugging X")
- Directory map if non-obvious

**Move out:**
- Long rule/schema blocks (>50 lines) → dedicated `REFERENCE.md`, read on demand
- Workflow-specific instructions (PR review, migration steps) → skills. Skills load only when invoked; CLAUDE.md text is paid every turn.
- Canonical style guides → external file linked from CLAUDE.md
- Any content not used in the majority of sessions

## Hierarchical compose

Claude reads **all CLAUDE.md files in the current path stack at once**:
- `~/.claude/CLAUDE.md` (global, every session)
- `./CLAUDE.md` (project root)
- `./subdir/CLAUDE.md` (if Claude enters that subdir)

Use this to scope rules:
- **Tone, formatting, global memory system** → global
- **Tech stack, build commands, conventions** → project
- **Subsystem quirks** → subdirectory

Do not duplicate across levels.

## Auto-memory vs CLAUDE.md

Two different systems, both loaded at session start:
- `~/.claude/CLAUDE.md` — user-authored, stable rules
- `~/.claude/projects/<project>/memory/MEMORY.md` + entries — harness-managed, short durable facts

Use CLAUDE.md for *policy*. Use auto-memory for *facts about the user and project state*. Do not merge them; they have different lifecycles.

## Compact instructions

Add a `## Compact instructions` section to CLAUDE.md to bias `/compact` toward what matters to you:

```markdown
## Compact instructions

When compacting, preserve test output, code changes, and open architecture questions. Drop tool-call transcripts.
```

## Sources

- [[claude-code-costs-docs]] — "under 200 lines" guidance
- [[claude-code-token-optimization-2026]] — <500 token target and template patterns
