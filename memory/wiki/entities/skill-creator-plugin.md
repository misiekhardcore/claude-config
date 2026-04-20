---
name: Skill Creator Plugin
description: The official Anthropic skill-creator plugin for interactive skill creation, evaluation, and optimization
type: entity
tags: [claude-code, skills, plugin, official]
status: evergreen
tier: semantic
reviewed_at: 2026-04-20
created: 2026-04-17
updated: 2026-04-20
confidence: INFERRED
evidence: []
related:
  - "[[claude-skill-anatomy]]"
  - "[[skill-creation-patterns]]"
  - "[[claude-code-skills-official-docs]]"
---

# Skill Creator Plugin

The **skill-creator** is an official Anthropic plugin that guides interactive skill creation, testing, evaluation, and optimization. It's designed for both beginners (step-by-step guidance) and experienced skill developers (rapid iteration).

**Status**: Installed and available  
**Source**: claude-plugins-official  
**Location**: `/home/michal/.claude/plugins/cache/claude-plugins-official/skill-creator/`

## What It Does

The skill-creator plugin automates the skill development loop:

1. **Interview** — Understand what the skill should do and when to use it
2. **Draft** — Generate the SKILL.md file with frontmatter and content
3. **Test** — Run test cases with the skill and without (baseline)
4. **Evaluate** — Grade outputs against assertions; create benchmark reports
5. **Improve** — Iterate based on feedback; re-run tests
6. **Optimize** — Auto-tune the description for better triggering accuracy
7. **Package** — Bundle the final skill for distribution

## Core Workflow

### Phase 1: Capture Intent

The skill-creator asks questions to understand:

1. What should this skill enable Claude to do?
2. When should this skill trigger? (user phrases, contexts)
3. What's the expected output format?
4. Should we set up test cases? (Yes for deterministic outputs; optional for subjective)

## Phase 2: Draft the Skill

Based on intent capture, the plugin generates:

- **`name`** field (identifier)
- **`description`** field (triggers, use cases)
- **Markdown content** (instructions Claude follows)
- **Directory structure** (with optional supporting files)

### Phase 3: Test with Evals

The plugin:

1. Spawns **with-skill** and **baseline** (without-skill) subagents in parallel for each test case
2. Captures timing and token data
3. Runs quantitative grading via assertions
4. Launches an interactive HTML viewer for reviewing outputs

**Key insight**: Test cases run in parallel (with-skill AND baseline in same turn) so they finish around the same time.

### Phase 4: Evaluate and Review

The viewer provides two tabs:

- **Outputs** — Shows each test case's prompt, output, previous output (if iteration 2+), formal grades, and space for user feedback
- **Benchmark** — Shows pass rates, timing, token usage per test case with mean/stddev, delta between with-skill and baseline, and analyst observations

User reviews outputs and leaves feedback on what works and what needs improvement.

### Phase 5: Improve and Iterate

Based on user feedback:

1. Apply improvements to the skill
2. Re-run all test cases into `iteration-<N+1>/` directory
3. Launch viewer with `--previous-workspace` to show diffs
4. Loop until user is satisfied or no meaningful progress

**Generalization principle**: Avoid overfitting to test cases. Improve the skill to work across many scenarios, not just the few examples you're testing.

### Phase 6: Optimize Description

Once the skill is stable:

1. Create 20 trigger eval queries (mix of should-trigger and should-not-trigger)
2. User reviews and approves queries
3. Run optimization loop: automatically tries 5 iterations of description tweaks, testing on train/eval split
4. Plugin returns `best_description` (selected by test score, avoiding overfitting)
5. Apply to skill and commit

The optimization loop:
- Splits eval set into 60% train, 40% test
- Evaluates current description (3 runs per query for reliability)
- Uses extended thinking to propose improvements based on failures
- Re-evaluates each new description
- Returns description with highest test score

**Trigger eval queries** must be:
- Realistic (concrete, specific, with context)
- Substantive (Claude should benefit from consulting a skill)
- Mixed difficulty (both clear-cut and edge cases)
- Include keywords, abbreviations, and casual speech

**Bad example**: "Format this data"  
**Good example**: "ok so my boss just sent me this xlsx file in downloads (Q4_sales_final_v2.xlsx) with revenue in column C and costs in D, and she wants me to add profit margin as a percentage column"

### Phase 7: Package

The plugin can package the skill as a `.skill` file for distribution:

```bash
python -m scripts.package_skill <path/to/skill-folder>
```

Result: A `.skill` file the user can install in another Claude Code instance.

## Key Patterns from skill-creator

### Lean SKILL.md

Keep the main file under 500 lines. Move:
- Detailed API documentation → `reference.md`
- Example outputs → `examples/`
- Helper scripts → `scripts/`

### Make Descriptions "Pushy"

Claude undertriggers skills. Be explicit:

**Bad**: "Code explanation tool"  
**Good**: "Explains code using visual diagrams and analogies. Use when explaining how code works, teaching a codebase, or when user asks 'how does this work?'"

### Bundle Repeated Work

If every test case regenerates the same helper script, move it to `scripts/` and execute it once.

### Explain the Why

Don't just give rules; explain reasoning so Claude can generalize:

**Weak**: "ALWAYS use this format: #Title ##Summary ##Details"  
**Strong**: "Use this structure because readers scan top-to-bottom. Lead with title and summary so they know immediately what they're reading. Details come after."

### Progressive Disclosure

Load content in three layers:

1. **Metadata** (always): name + description
2. **SKILL.md** (on invoke): full instructions
3. **Supporting files** (on demand): reference, examples, templates

## Testing and Evaluation

### Assertion Format

Assertions are objective, verifiable conditions. Example:

```json
{
  "id": 1,
  "prompt": "User task",
  "expected_output": "Description of result",
  "assertions": [
    {
      "text": "Output includes all three sections",
      "passed": true,
      "evidence": "Found Introduction, Analysis, Recommendations"
    },
    {
      "text": "Report is under 500 words",
      "passed": false,
      "evidence": "Report is 687 words"
    }
  ]
}
```

### Benchmark.json

Aggregated results across all test cases:

```json
{
  "skill_name": "my-skill",
  "with_skill": {
    "pass_rate": 0.85,
    "avg_tokens": 2500,
    "avg_duration_ms": 15000
  },
  "without_skill": {
    "pass_rate": 0.60,
    "avg_tokens": 1800,
    "avg_duration_ms": 10000
  },
  "delta": {
    "pass_rate_improvement": 0.25,
    "token_overhead": 700
  }
}
```

## Cloud vs. Offline Variants

### In Claude Code (full features)
- Subagents for parallel execution
- Browser-based eval viewer
- Description optimization via `claude -p` subprocess
- Packaging support

### In Claude.ai (limited)
- No subagents; run test cases sequentially
- No browser viewer; present results inline
- No description optimization (no `claude -p` CLI)
- No baseline runs (no subagent comparison)

### In Cowork (headless)
- Subagents available (use for parallel execution)
- No browser; use `--static` for standalone HTML viewer
- Feedback downloads as `feedback.json` (not live browser)
- Description optimization works (subprocess, no display needed)

## Configuration and Execution

The plugin is invoked via the `/skill-creator` command:

```
/skill-creator
```

The user describes what they want to build, and the plugin guides through the workflow. The plugin can:
- Create a skill from scratch
- Improve an existing skill
- Run evals on a skill
- Optimize the skill's description
- Benchmark performance with variance analysis

## Key Files and Scripts

From the installed skill-creator plugin:

| File | Purpose |
|------|---------|
| `SKILL.md` | Main instructions (31KB) |
| `agents/grader.md` | Grader subagent instructions |
| `agents/comparator.md` | Blind A/B comparison logic |
| `agents/analyzer.md` | Benchmark analysis patterns |
| `references/schemas.md` | JSON schemas for evals.json, grading.json, benchmark.json |
| `eval-viewer/generate_review.py` | Creates interactive viewer HTML |
| `scripts/aggregate_benchmark.py` | Aggregates results into benchmark.json |
| `scripts/run_loop.py` | Runs description optimization loop |
| `scripts/package_skill.py` | Packages skill as .skill file |

## Related Concepts

- **Progressive disclosure** — Three-layer loading (metadata → content → supporting files)
- **Test-driven skill development** — Draft → test → review → improve → repeat
- **Generalization** — Write skills that work across many scenarios, not just test cases
- **Trigger optimization** — Systematically improve skill descriptions for auto-invocation

## Notes

- The skill-creator plugin follows a "theory of mind" approach: explain the **why** behind everything, not just rules
- Skills created with skill-creator can be distributed as `.skill` files or committed to `.claude/skills/`
- The evaluation loop is optional; experienced developers can skip to testing/packaging
- Description optimization is the most advanced feature; many users won't need it

---

## Related

- **[[skill-creation-patterns]]** — Best practices for effective skills
- **[[claude-skill-anatomy]]** — Skill file structure and anatomy
- **[[claude-code-skills-official-docs]]** — Official documentation
