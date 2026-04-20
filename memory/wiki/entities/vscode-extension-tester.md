---
type: entity
title: "vscode-extension-tester (ExTester)"
entity_type: tool
created: 2026-04-19
updated: 2026-04-19
tags:
  - testing
  - vscode
  - selenium
  - redhat
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
related:
  - "[[VS Code Webview Testing]]"
  - "[[wdio-vscode-service]]"
sources:
  - "[[vscode-extension-tester-extester]]"
---

# vscode-extension-tester (ExTester)

Red Hat's Selenium WebDriver-based UI test framework for VS Code extensions. Ships an `extest` CLI for Chromedriver management and test orchestration.

- **Repo:** [redhat-developer/vscode-extension-tester](https://github.com/redhat-developer/vscode-extension-tester)
- **Example:** [vscode-extension-tester-example](https://github.com/redhat-developer/vscode-extension-tester-example)
- **Latest:** 8.23.0 (March 2026)

## Design
- Uses **plain Selenium WebDriver** (no WebdriverIO runner).
- Mocha 5.2+ as the test framework.
- Env-configurable: `CODE_VERSION`, `TEST_RESOURCES`.
- Page objects (`Workbench`, `EditorView`, `WebView`, `SideBarView`, etc.) documented in the repo wiki.

## Webview handling
`WebView` page object locates the active webview iframe (5s default timeout) and exposes `switchToFrame()` / `switchBack()`.

Gotcha: the **Welcome page is a webview** — call `new EditorView().closeAllEditors()` before instantiating `WebView` to avoid binding to the wrong frame.

## When to pick it
- Team has Selenium expertise.
- Alignment with Red Hat ecosystem (Quarkus, OpenShift, etc.).
- Prefer Mocha over WebdriverIO's opinionated runner.

Otherwise [[wdio-vscode-service]] is the more active, better-documented default.
