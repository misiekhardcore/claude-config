---
type: entity
title: "Playwright"
entity_type: tool
created: 2026-04-19
updated: 2026-04-20
tags:
  - testing
  - browser-automation
  - microsoft
  - electron
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[playwright-electron-vscode-testing]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[FrameLocator Chaining for Nested Iframes]]"
  - "[[Electron Headless via Xvfb]]"
sources:
  - "[[playwright-electron-vscode-testing]]"
---

# Playwright

Microsoft's browser automation framework. Drives Chromium, Firefox, WebKit, and Electron apps via CDP.

- **Docs:** [playwright.dev](https://playwright.dev)

## Relevance to VS Code extension testing
Playwright's `_electron` API launches VS Code as a regular Electron app. You get:

- Chained `frameLocator()` for reaching nested webview iframes — see [[FrameLocator Chaining for Nested Iframes]].
- `page.screenshot()` — captures the full Electron window.
- Trace viewer (`playwright show-trace`), UI mode, codegen — the tooling that wdio-vscode-service and ExTester don't ship.

## Tradeoffs vs wdio-vscode-service
- **No workbench page objects.** You write your own helpers or navigate raw DOM.
- **No true headless mode for Electron** — use Xvfb on Linux CI.
- **Official Playwright VS Code extension** exists for running Playwright tests from within VS Code; unrelated to using Playwright to test VS Code extensions.

## Two-browser webview trick
Because webviews are mostly self-contained HTML, you can **render them in plain Chromium via Playwright** (without VS Code) to produce clean, chrome-free screenshots. Useful for docs when you want the webview UI only.
