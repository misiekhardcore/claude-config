# Cross-Cutting Removals: Planning Pattern

When removing a pervasive concept from a codebase (e.g., scope labels, deprecated fields, legacy configs), scope underestimation is common. Spec lists ~15 files; reality hits 20+.

## Root Cause

Manual audits miss:
- Reference files and templates (examples in docs)
- Wiki pages created during design, with stale examples
- Nested package structures with repeated patterns
- Configuration schemas and validation rules
- Type definitions referenced transitively

## Corrective Pattern

**1. Exhaustive grep discovery (first step)**

Run grep for all occurrences before estimating scope:
```bash
grep -r "concept_name" . --include="*.java" --include="*.ts" --include="*.md" --include="*.json" | wc -l
```

Sort results by file type to identify hidden surfaces:
- `.md` files (wiki, docs, examples)
- `.json` schemas (Spring config, validation rules)
- Test fixtures and reference data
- Template files and generated stubs

**2. Enumerate all target files**

Build a definitive list from grep output — don't supplement with "probably also need to check":
```
[ ] file1.java (remove @Deprecated)
[ ] file2.ts (update interface)
[ ] docs/legacy-config.md (remove example)
...```

**3. Adjust task scope**

- If grep shows 20+ files, split by cohesion (controllers / services / tests) not by file count
- Batch mechanically similar tasks (remove-from-validators, remove-from-tests) into single subagent
- Flag reference/wiki files as a separate pass after code changes merge

**4. Post-merge consistency check**

After implementation, search wiki pages filed during design for stale examples:
```bash
grep -r "old_concept" /vault/ --include="*.md"
```

This catches design docs with hardcoded examples that became obsolete.

## When to Use

- Removing a field / type / label that spans multiple layers (controller → service → data)
- Deprecating a concept that appears in schemas, examples, and validation
- Refactoring that affects both code and reference materials

## When Not Needed

- Single-file fixes
- Renames isolated to one package
- Purely additive features
