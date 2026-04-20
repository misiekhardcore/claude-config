---
type: entity
title: "wdio-vscode-service"
entity_type: tool
created: 2026-04-19
updated: 2026-04-20
tags:
  - testing
  - vscode
  - webdriverio
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[wdio-vscode-service-docs]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[vscode-extension-tester]]"
  - "[[Playwright]]"
  - "[[@vscode/test-electron]]"
sources:
  - "[[wdio-vscode-service-docs]]"
---

# wdio-vscode-service

WebdriverIO service for end-to-end testing VS Code extensions. Launches VS Code as Electron, downloads a matching Chromedriver, exposes page objects for workbench chrome, and lets tests run code inside the extension host via `executeWorkbench()`.

- **Repo:** [webdriverio-community/wdio-vscode-service](https://github.com/webdriverio-community/wdio-vscode-service)
- **Docs:** [webdriver.io/docs/wdio-vscode-service](https://webdriver.io/docs/wdio-vscode-service/)
- **TypeDoc:** [webdriverio-community.github.io/wdio-vscode-service](https://webdriverio-community.github.io/wdio-vscode-service/) (v6.1.4 at time of research)

## Key capabilities
- Page objects for workbench, editor, sidebar, status bar, activity bar, notifications, settings, webviews.
- `executeWorkbench((vscode, ...args) => {...}, ...args)` — run arbitrary code with the `vscode` API.
- `getWorkbench().getAllWebviews()` + `WebView.open()` / `close()` for frame switching.
- Config-driven user settings (theme, fonts, zoom) at launch.

## Why pick it for vscode-gcode-extension
- Only option with a **maintained workbench page-object API**.
- Config fields map directly to the raw plan's `userSettings` block.
- `browser.saveScreenshot()` works for both IDE and webview contexts (depending on whether `webview.open()` is active).

## Limitations
- No native macOS context-menu driving.
- Webview-only screenshots (without IDE chrome) still capture the full window — crop in post or use plain Playwright for pure webview shots.
- WDIO v9 required `'wdio:enforceWebDriverClassic': true`.

## Alternatives
- [[vscode-extension-tester]] — Selenium-based, Red Hat maintained.
- [[Playwright]] + Electron — more tooling (trace, codegen) but no workbench page objects.
