---
type: source
title: "@vscode/test-electron and @vscode/test-cli official docs"
source_type: documentation
author: Microsoft
date_published: 2025-ongoing
url: "https://code.visualstudio.com/api/working-with-extensions/testing-extension"
date_accessed: 2026-04-19
confidence: high
tags:
  - vscode
  - testing
  - mocha
  - official
status: current
key_claims:
  - "@vscode/test-electron is the low-level runner; @vscode/test-cli is the config-file wrapper"
  - "test-cli reads .vscode-test.js/mjs/cjs for its configuration"
  - "Tests run inside the extension host with full vscode API access"
  - "Neither ships screenshot helpers — screenshots require an external driver (Playwright, wdio)"
related:
  - "[[@vscode/test-electron]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
---

# @vscode/test-electron + @vscode/test-cli

Microsoft's official test runners for VS Code extensions. Supersedes the older `vscode-test` package.

## The two packages

| Package | Role |
|---|---|
| `@vscode/test-electron` | Low-level. Downloads VS Code, launches it with the extension loaded, runs a Mocha entry point. Exposed via `runTests()` API. |
| `@vscode/test-cli` | High-level. Config-file-driven wrapper over test-electron. Ships the `vscode-test` CLI. |

Typical dependency setup installs both — `test-cli` depends on `test-electron`.

## Config-file example

`.vscode-test.mjs`:

```js
import { defineConfig } from '@vscode/test-cli';
export default defineConfig({
  files: 'out/test/**/*.test.js',
  workspaceFolder: './test-fixtures',
  mocha: { ui: 'bdd', timeout: 60000 },
});
```

Multiple configs in an array run sequentially; `--label` selects one. `launchArgs` (passed through to test-electron) supports `--disable-extensions`, `--user-data-dir`, etc.

## What it's good for

- Running the extension's **integration test suite** from inside the extension host (unit-style tests with `vscode` API access).
- Asserting command registration, language-feature behavior, diagnostics, workspace edits.
- CI-friendly: well-supported on GitHub Actions with `xvfb-run -a` on Linux.

## What it's NOT good for

- **Screenshots.** The test runs inside the extension host — it has no browser/Electron window handle and can't call `saveScreenshot`.
- **Webview DOM assertions.** Tests cannot reach into webview iframes; they only see the webview from the extension API side (post/receive messages, check `webview.html`).
- **UI driving** (clicking buttons, typing in palette, etc).

For screenshots and UI flows, layer `wdio-vscode-service`, ExTester, or Playwright-Electron on top — they launch VS Code externally and drive it via WebDriver/CDP.

## Version pairing

Keep the two packages versioned together. Reported breakage when `@vscode/test-cli` and `@vscode/test-electron` diverge across minor versions (e.g. `0.0.9` + `2.4.0` broke; bumping both to `0.0.10` + `2.4.1` fixed it).

## Sources

- [VS Code Testing Extensions docs](https://code.visualstudio.com/api/working-with-extensions/testing-extension)
- [Continuous Integration docs](https://code.visualstudio.com/api/working-with-extensions/continuous-integration)
- [vscode-test (sample workflows)](https://github.com/microsoft/vscode-test)
