---
type: source
title: "vscode-extension-tester (ExTester) docs and repo"
source_type: documentation
author: Red Hat Developer
date_published: 2025-ongoing
url: "https://github.com/redhat-developer/vscode-extension-tester"
date_accessed: 2026-04-19
source_reliability: high
tags:
  - vscode
  - testing
  - selenium
  - webview
status: current
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
key_claims:
  - "ExTester is a Selenium WebDriver-based UI tester for VS Code extensions"
  - "Latest version 8.23.0 (March 2026)"
  - "WebView page object switches into the active iframe for assertions"
  - "Welcome page is itself a webview and must be closed before interacting with extension webviews"
related:
  - "[[vscode-extension-tester]]"
  - "[[VS Code Webview Testing]]"
  - "[[wdio-vscode-service]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
evidence: []
---

# ExTester (vscode-extension-tester)

Red Hat's Selenium WebDriver-based UI test framework for VS Code extensions. Alternative to `wdio-vscode-service`.

## What it provides

- Uses **Selenium WebDriver** (not WebdriverIO) to drive VS Code.
- Ships an `extest` CLI for downloading Chromedriver, launching VS Code, and running Mocha test suites.
- Page objects for workbench, editors, views, activity bar, webviews.
- Integrates with Mocha 5.2+. Tests are plain BDD-style Mocha.
- Environment-configurable via `CODE_VERSION` and `TEST_RESOURCES`.

## WebView page object

From `page-objects/src/components/editor/WebView.ts`:

- Locates the active webview iframe (default 5s timeout).
- `switchToFrame()` — switch WebDriver context into the webview.
- `switchBack()` — return to the main VS Code frame.

Test pattern mirrors wdio-vscode-service:

```ts
const webview = new WebView();
await webview.switchToFrame();
// Selenium assertions run inside the webview DOM
await webview.switchBack();
```

## Gotchas (January 2025 discussion #1690)

- **Welcome page is a webview.** If the VS Code Welcome page is open, `new WebView()` may bind to it instead of the extension's webview. Fix: `await new EditorView().closeAllEditors();` before locating the webview.
- **Flaky webview handling** in some edge cases — an open bug tracked by the Red Hat team.
- **Shared macOS limitation** with wdio: native context menus can be opened programmatically but clicks on menu items don't work.

## Screenshots

ExTester exposes raw Selenium APIs. Standard Selenium screenshot calls apply:

```ts
const driver = VSBrowser.instance.driver;
await driver.takeScreenshot().then(png => fs.writeFileSync('shot.png', png, 'base64'));
```

No built-in `takeScreenshot` on the WebView page object — call through the driver instead.

## When to pick ExTester over wdio-vscode-service

- **Existing Selenium WebDriver expertise** on the team.
- **Red Hat ecosystem alignment** (used by Quarkus, OpenShift tooling extensions).
- **Mocha-only preference** without the WebdriverIO runner opinionation.

Otherwise `wdio-vscode-service` is the more active, better-documented default.

## Sources

- [ExTester GitHub](https://github.com/redhat-developer/vscode-extension-tester)
- [Wiki: Writing Simple Tests](https://github.com/redhat-developer/vscode-extension-tester/wiki/Writing-Simple-Tests)
- [Wiki: Test Setup](https://github.com/redhat-developer/vscode-extension-tester/wiki/Test-Setup)
- [Discussion #1690 on sidebar webviews (Jan 2025)](https://github.com/redhat-developer/vscode-extension-tester/discussions/1690)
- [WebView.ts source](https://github.com/redhat-developer/vscode-extension-tester/blob/main/page-objects/src/components/editor/WebView.ts)
- [Example repo](https://github.com/redhat-developer/vscode-extension-tester-example)
