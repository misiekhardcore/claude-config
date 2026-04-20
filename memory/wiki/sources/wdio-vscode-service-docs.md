---
type: source
title: "wdio-vscode-service official docs"
source_type: documentation
author: WebdriverIO community
date_published: 2025-ongoing
url: "https://webdriver.io/docs/wdio-vscode-service/"
date_accessed: 2026-04-19
source_reliability: high
tags:
  - vscode
  - testing
  - webdriverio
  - screenshots
status: current
tier: episodic
reviewed_at: 2026-04-20
confidence: EXTRACTED
key_claims:
  - "Service downloads VS Code + matching Chromedriver and launches it as an Electron app"
  - "Webview testing uses WebView.open() / close() to switch frame context"
  - "Custom page objects decorate via PageDecorator + BasePage"
  - "executeWorkbench() runs code inside VS Code process with access to the vscode API"
related:
  - "[[wdio-vscode-service]]"
  - "[[VS Code Webview Testing]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
evidence: []
---

# wdio-vscode-service official docs

Canonical WebdriverIO service docs for end-to-end testing of VS Code extensions.

## What the service provides

- Downloads VS Code (`stable`, `insiders`, or pinned version) and a matching Chromedriver.
- Launches VS Code as an Electron app under WebDriver control.
- Applies custom `userSettings` (theme, font, minimap, etc.) on launch.
- Loads the local extension folder via `extensionPath`.
- Exposes `browser.getWorkbench()` returning page objects for command palette, editor, sidebar, status bar, notifications, webviews.
- Exposes `browser.executeWorkbench((vscode, ...args) => {...}, ...args)` for running code inside the extension host with full `vscode` API access.

## Webview API

From the generated TypeDoc at `webdriverio-community.github.io/wdio-vscode-service`:

- `WebView.getAllWebViews(locators)` — static, returns `Promise<WebView[]>`. Retrieves every open webview (sidebar + editor).
- `webview.open()` — switches WebDriver context into the webview iframe. Subsequent `$()` / `expect()` calls target webview DOM.
- `webview.close()` — switches back to the VS Code main frame. Required before using other page objects.
- `webview.activeFrame` — the active iframe element.
- `wait(timeout)` / `poll(timeout, interval)` — wait helpers.

Canonical webview test (`test/specs/webview.e2e.ts`):

```ts
const webviews = await workbench.getAllWebviews()
await webviews[0].open()
expect(await browser.getPageSource()).toContain('My WebView')
await expect($('h1')).toHaveText('Hello World!')
await webviews[0].close()
```

## Screenshots

Service has no dedicated screenshot helper. Since it builds on WebdriverIO, use standard WDIO commands:

- `browser.saveScreenshot('path.png')` — current viewport.
- `@wdio/visual-service` for visual regression (baseline + diff).

Screenshots captured during `open()` target the webview DOM, not the IDE chrome. Call `shot()` before `open()` or after `close()` for full-IDE shots; call during `open()` for webview-only shots.

## Capabilities config

```ts
capabilities: [{
  browserName: 'vscode',
  browserVersion: 'stable',     // or '1.86.0' to pin
  'wdio:enforceWebDriverClassic': true,  // required for WDIO v9
  'wdio:vscodeOptions': {
    extensionPath: path.join(__dirname, '..'),
    workspacePath: path.join(__dirname, 'fixtures'),
    userSettings: { 'workbench.colorTheme': 'Default Dark Modern', ... }
  }
}]
```

## Known limitations

- **macOS native context menus are not drivable** — programmatic open works, clicking items does not (shared bug with `vscode-extension-tester`).
- **Web-mode gotcha** — if `browserName` is anything other than `'vscode'` (e.g. `'chrome'`), the extension is served as a web extension rather than launched in desktop VS Code.

## Sources

- [wdio-vscode-service docs](https://webdriver.io/docs/wdio-vscode-service/)
- [GitHub repo](https://github.com/webdriverio-community/wdio-vscode-service)
- [TypeDoc API (v6.1.4)](https://webdriverio-community.github.io/wdio-vscode-service/)
- [Test specs including webview.e2e.ts](https://github.com/webdriverio-community/wdio-vscode-service/tree/main/test/specs)
- [Kameleoon integration report](https://medium.com/kameleoon/how-we-added-integration-tests-to-our-vscode-extension-using-wdio-vscode-service-9491f33ebc5c)
