---
type: entity
title: "@vscode/test-electron + @vscode/test-cli"
entity_type: tool
created: 2026-04-19
updated: 2026-04-20
tags:
  - testing
  - vscode
  - official
  - microsoft
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[vscode-test-electron-cli]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[wdio-vscode-service]]"
  - "[[vscode-extension-tester]]"
sources:
  - "[[vscode-test-electron-cli]]"
---

# @vscode/test-electron + @vscode/test-cli

Microsoft's official test runners for VS Code extensions. Supersedes the legacy `vscode-test` package.

## The pair
- `@vscode/test-electron` — low-level. Downloads and launches VS Code, runs a Mocha entry point via `runTests()`.
- `@vscode/test-cli` — high-level. Config-file wrapper (`.vscode-test.mjs`) exposing the `vscode-test` CLI. Depends on `test-electron`.

Keep both pinned together — version divergence has broken test runs (e.g. `0.0.9` + `2.4.0` → broken; bumping to matching minors fixed it).

## Scope
- **Good for:** integration tests that run *inside* the extension host, with full `vscode` API access (command registration, language features, diagnostics, workspace edits).
- **Not suitable for:** screenshots, UI driving, webview DOM assertions. No browser handle exists; you're running Node inside the extension host process.

For anything UI-level you layer [[wdio-vscode-service]], [[vscode-extension-tester]], or [[Playwright]] on top — they spawn VS Code externally and drive it via WebDriver/CDP.

## Relationship to the screenshot pipeline
In the raw plan for `vscode-gcode-extension`, `@vscode/test-electron` is the underlying downloader used by wdio-vscode-service. You don't interact with it directly; wdio delegates. If you wrote screenshots without wdio, you'd call `downloadAndUnzipVSCode()` yourself and hand the resolved path to Playwright's `electron.launch({ executablePath })`.
