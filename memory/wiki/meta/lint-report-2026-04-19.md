---
type: meta
title: "Lint Report 2026-04-19"
created: 2026-04-19
updated: 2026-04-19
tags:
  - meta
  - lint
  - audit
status: current
---

# Lint Report: 2026-04-19

Follow-up to [[lint-report-2026-04-17]]. The vault grew from 49 → 93 pages across two big ingest waves (2026-04-17 webview-testing, 2026-04-19 workflow/skills research). Several pages were added with incomplete frontmatter and a handful of wikilinks regressed.

## Summary

- Pages scanned: 93 (`.md`), plus 1 `.canvas` and 1 `.base`
- Unique wikilink targets: 100
- Dead links (true): 7 distinct targets across ~10 call-sites
- Orphan pages: 0 (one false positive from alias mismatch — see Findings)
- Frontmatter gaps: 30 pages missing `updated`, 5 missing `created`, 1 missing both
- Empty sections flagged: ~50 (largely structural h2→h3 nesting; content gaps, not lint issues)
- Auto-fixed: 0
- Needs review: see below

## Dead Links

True broken wikilinks (target does not resolve to any `.md`/`.canvas`/`.base` file or alias):

1. **`[[G-code LSP Architecture]]`** — actual file is `concepts/gcode-lsp-architecture.md`. Referenced in:
   - `log.md` (log entry for 2026-04-17 ingest)
   - `concepts/Structured Parse Error Location.md`
   - Suggest: rewrite to `[[gcode-lsp-architecture]]`, or add `aliases: ["G-code LSP Architecture"]` to the target file's frontmatter.

2. **`[[Plugin Root Variable in Skills]]`** — no file with this name exists. The [[lint-report-2026-04-17]] claimed it was created, but it is not in the vault. Referenced in:
   - `hot.md` line 40
   - `log.md` lines 69–70 (entry header + "Pages created:")
   - `index.md` line 67
   - Suggest: create a stub concept page (the content is summarized in `hot.md`), or unlink all three references.

3. **`[[Research: VS Code Webview Testing and Screenshots]]`** — actual file is `questions/Research VS Code Webview Testing and Screenshots.md` (no colon — filesystem-safe). Referenced in:
   - `sources/vscode-test-electron-cli.md`
   - `sources/vscode-extension-tester-extester.md`
   - `sources/wdio-vscode-service-docs.md`
   - Suggest: rewrite to `[[Research VS Code Webview Testing and Screenshots]]` (drop the colon).

4. **`[[grill-me]]`, `[[new-skill]]`** — skill references with no wiki pages. In `concepts/AskUserQuestion-in-skill-interviews.md`. These are claude-workflow plugin skill names, not vault concepts. Suggest: unlink (plain text) or wrap in backticks; creating stubs would duplicate plugin docs.

5. **`[[wiki-ingest]]`** — in `sources/llm-wiki-karpathy-gist.md`. Same pattern — a claude-obsidian plugin skill name. Suggest: unlink or backtick.

6. **`[[@vscode/test-electron]]`** — actual file is `entities/vscode-test-electron.md` whose H1 title is `@vscode/test-electron + @vscode/test-cli`. The `/` in the wikilink breaks basename resolution in Obsidian. Referenced in `log.md`, `questions/Research VS Code Webview Testing and Screenshots.md`, `entities/wdio-vscode-service.md`. Suggest: add `aliases: ["@vscode/test-electron"]` to `entities/vscode-test-electron.md` frontmatter, OR rewrite callers to `[[vscode-test-electron|@vscode/test-electron]]`.

7. **`[[wikilinks]]`, `[[claude-obsidian-presentation]]`** — only referenced inside the old [[lint-report-2026-04-17]] report itself (as examples of what was previously fixed). Not a real issue — the report is a historical artifact. Suggest: leave as-is.

## Orphan Pages

None. Initial basename scan surfaced `entities/vscode-test-electron.md` as orphan — false positive: it is linked as `[[@vscode/test-electron]]` (see Dead Links #6). Fix that one and the orphan disappears.

## Missing Pages

The [[lint-report-2026-04-17]] index claimed `Plugin Root Variable in Skills` was created but the file is absent. Treat this as "missing page" rather than "dead link" since three separate callers (hot, log, index) all assume the page exists. The content captured in `hot.md` line 40 is enough to seed the stub.

## Frontmatter Gaps

### Missing `updated:`

Concepts (batch from 2026-04-19 ingests):

- `concepts/agent-handoff-artifact-pattern.md`
- `concepts/seed-brief-pattern.md`
- `concepts/claude-skill-anatomy.md`
- `concepts/skill-invocation-model.md`
- `concepts/skill-frontmatter-reference.md`
- `concepts/claude-workflow-phase-shape.md`
- `concepts/skill-vs-subagent-tool-fields.md`
- `concepts/multiskill-workflow-patterns.md`
- `concepts/hierarchical-agent-decomposition.md`
- `concepts/skill-creation-patterns.md`
- `concepts/allowed-tools-for-multi-agent-plugins.md`
- `concepts/allowed-tools-semantics.md`

Entities:

- `entities/Superpowers Plugin.md`
- `entities/skill-creator-plugin.md`
- `entities/Microsoft Agent Framework.md`

Sources:

- `sources/Superpowers GitHub.md`
- `sources/MindStudio Skill Collaboration Pattern.md`
- `sources/Microsoft Agent Framework Handoff Workflows.md`
- `sources/Beam Multi-Agent Orchestration Patterns.md`
- `sources/Addy Osmani Code Agent Orchestra.md`
- `sources/claude-code-skills-official-docs.md`
- `sources/agent-skills-best-practices-anthropic.md`
- `sources/ClaudeFast Agent Teams Guide.md`

### Missing `created:` and `updated:`

- `sources/vscode-test-electron-cli.md`
- `sources/vscode-extension-tester-extester.md`
- `sources/wdio-vscode-service-docs.md`
- `sources/playwright-electron-vscode-testing.md`
- `sources/hakanson-vscode-actions-xvfb.md`

### Missing `created:` only

- `log.md` (created field absent; has `updated`).

Suggest: auto-backfill `created: 2026-04-17` for the webview batch, `created: 2026-04-19` for the workflow batch, and `updated: 2026-04-19` for everything. Safe to auto-fix.

## Stale Claims

1. `concepts/claude-workflow-composition-codification.md` self-flags that `concepts/seed-brief-pattern.md` uses the **old** field names (`Technology stack`, `Module structure`, etc.) while `_shared/composition.md` is now the authoritative shorter set (`tech_stack`, `module_map`, `patterns`, `prior_art`, `open_questions`). Suggest: update `seed-brief-pattern.md` to match, or add a deprecation note.

2. `meta/lint-report-2026-04-17.md` states "Vault is ready for use. All critical and warning-level issues resolved." — stale. This report is now superseded. Suggest: leave the 2026-04-17 report intact as a historical artifact; this new report is the current source of truth.

## Cross-Reference Gaps

Spot-check only — no systematic scan for unlinked entity mentions in this pass. Recommend running a dedicated entity-mention scan next lint cycle.

## Empty Sections

~50 headings flagged by a naive scanner, but most are structural h2 → h3 nesting (the h2 acts as a group heading for following h3 subsections). True content gaps that appeared in the 2026-04-17 report ("Key Innovations", "Key Features", entity shells) remain untouched and are content-ingest tasks, not lint issues. No action required.

## Naming / Wikilink Conventions

Current mismatches to address:

- **Titles with colons** — Obsidian filesystem convention drops `:` from filenames; wikilinks must also drop it. Three `Research:` wikilinks break this rule.
- **`/` in wikilinks** — breaks basename resolution. `[[@vscode/test-electron]]` needs an alias or pipe form.
- **Case-sensitive basename mismatch** — `[[G-code LSP Architecture]]` vs file `gcode-lsp-architecture.md`. Either rename the file to preserve the human-readable title, or add an alias.

## Suggested Auto-Fix Batch

Safe (pure additions, no semantic changes):

- Backfill missing `created:` / `updated:` frontmatter on the 30 flagged pages.
- Add `aliases: ["@vscode/test-electron"]` to `entities/vscode-test-electron.md`.
- Add `aliases: ["G-code LSP Architecture"]` to `concepts/gcode-lsp-architecture.md`.

Needs review (touches prose):

- Rewriting 3 `Research:` wikilinks to drop the colon (trivial but edits content).
- Unlinking or stubbing `[[Plugin Root Variable in Skills]]`, `[[grill-me]]`, `[[new-skill]]`, `[[wiki-ingest]]`.
- Updating `seed-brief-pattern.md` field names to match `_shared/composition.md`.

## Resolution (auto-fixed 2026-04-19)

All flagged issues closed in the same session:

- **Frontmatter backfill** — 30 pages updated: `updated: 2026-04-19` added to the 25 missing it; `created:` backfilled on the 5 webview-batch sources (`2026-04-19`) and on `log.md` (`2026-04-17`).
- **Alias additions** — `entities/vscode-test-electron.md` gained `aliases: ["@vscode/test-electron"]`; `concepts/gcode-lsp-architecture.md` gained `aliases: ["G-code LSP Architecture"]`. Both dead-link classes now resolve via Obsidian alias lookup.
- **Colon wikilinks** — six call-sites of `[[Research: VS Code Webview Testing and Screenshots]]` rewritten to `[[Research VS Code Webview Testing and Screenshots]]` (filename has no colon). Patched files: `sources/vscode-test-electron-cli.md`, `sources/vscode-extension-tester-extester.md`, `sources/wdio-vscode-service-docs.md`, `sources/playwright-electron-vscode-testing.md`, `sources/hakanson-vscode-actions-xvfb.md`, `concepts/VS Code Webview Testing.md`.
- **Plugin-skill wikilinks** — `[[grill-me]]`, `[[new-skill]]`, `[[wiki-ingest]]` unlinked (wrapped in backticks) in `concepts/AskUserQuestion-in-skill-interviews.md` and `sources/llm-wiki-karpathy-gist.md`. These are plugin-skill names, not vault concepts.
- **Missing page created** — `concepts/Plugin Root Variable in Skills.md` written from the `hot.md` summary plus claude-workflow context. Three upstream callers (`hot.md`, `log.md`, `index.md`) now resolve.
- **Stale claim fixed** — `concepts/seed-brief-pattern.md` "Contract Requirements" section updated to use the canonical `_shared/composition.md` field names (`tech_stack`, `module_map`, etc.) with a note on the prior naming.

Remaining apparent dead links (`[[grill-me]]`, `[[wiki-ingest]]`, `[[Research: VS Code Webview Testing and Screenshots]]`) appear only inside lint reports as illustrative examples — not true linkage.

---

**Scan completed:** 2026-04-19 | **Checks run:** 8/8 | **Auto-fix pass completed:** 2026-04-19.
