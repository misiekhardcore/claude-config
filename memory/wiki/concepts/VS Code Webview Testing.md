---
type: concept
title: "VS Code Webview Testing"
created: 2026-04-19
updated: 2026-04-19
tags:
  - vscode
  - testing
  - webview
  - automation
status: current
confidence: high
related:
  - "[[FrameLocator Chaining for Nested Iframes]]"
  - "[[VS Code Screenshot Determinism]]"
  - "[[wdio-vscode-service]]"
  - "[[vscode-extension-tester]]"
  - "[[@vscode/test-electron]]"
  - "[[Playwright]]"
  - "[[vscode-gcode-extension]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
sources:
  - "[[wdio-vscode-service-docs]]"
  - "[[vscode-extension-tester-extester]]"
  - "[[playwright-electron-vscode-testing]]"
  - "[[vscode-test-electron-cli]]"
---

# VS Code Webview Testing

> Webviews are VS Code's escape hatch for rich UIs — but they run inside nested iframes, so tests can't reach them from the extension host. You need a browser-automation layer that drives VS Code from the outside.

## The nested iframe problem

A VS Code webview is **two iframes deep**:

```
VS Code window (Electron)
 └── <iframe class="webview ready">          ← outer container, managed by VS Code
      └── <iframe name="active-frame"         ← inner sandbox with extension HTML
              src="vscode-webview://...">
           └── (your webview DOM)
```

Tests that run inside the extension host (via `@vscode/test-electron`) can only talk to the webview through `WebviewPanel.webview.postMessage()` / `onDidReceiveMessage()`. They cannot query the DOM, click buttons, or capture a screenshot.

## Three automation options

| Option | Drives VS Code how? | Webview access | Screenshots | Good for |
|---|---|---|---|---|
| **wdio-vscode-service** | WebDriver | `webview.open()` / `close()` — switches context | `browser.saveScreenshot()` (WDIO) | Full-IDE flows with workbench page objects |
| **vscode-extension-tester (ExTester)** | Selenium WebDriver | `new WebView().switchToFrame()` / `switchBack()` | `driver.takeScreenshot()` | Teams already using Selenium/Red Hat stack |
| **Playwright + Electron** | CDP | Chained `frameLocator('iframe.webview').frameLocator('iframe[name="active-frame"]')` | `page.screenshot()` | Rich tooling (trace, codegen), webview-only shots |

## Standard test pattern

Regardless of framework, the flow is:

1. Launch VS Code as Electron with the extension loaded (via `extensionPath` / `--extensionDevelopmentPath`).
2. Trigger the command that opens the webview (e.g. `workbench.executeCommand('extension.showVisualizer')`).
3. Wait for the webview to register (poll `getAllWebviews()` or the frame locator).
4. Switch into it (or chain frame locators).
5. Assert / screenshot.
6. Switch out before using other page objects.

## Critical gotcha

**The Welcome page is itself a webview.** If it's open, the first webview returned by `getAllWebviews()` will be Welcome, not your extension's webview. Close all editors before querying:

```ts
await workbench.executeCommand('View: Close All Editors');
// or in ExTester:
await new EditorView().closeAllEditors();
```

## Webview-only vs full-IDE screenshots

If you want just the webview UI (no IDE chrome) for documentation, two approaches:

- **Screenshot inside webview context.** Switch in, call `saveScreenshot`, switch out. Captures the full window but the active frame is the webview.
- **Render in plain Playwright.** If the webview is mostly self-contained HTML, load it in a Chromium browser outside VS Code. Cleaner. Doesn't exercise the vscode-webview API bridge, so not useful for verifying integration.

The raw plan at `vscode-webview-testing.md:271-272` surfaces this split. The research confirms it.

## For vscode-gcode-extension specifically

The extension has a **3D G-code visualizer** webview (Three.js). To screenshot it:

1. Open a fixture `.gcode` file.
2. Run the visualizer command (check `package.json` for the exact command id).
3. `getAllWebviews()`, filter by title or panel id, `open()`.
4. Pause 1-2s for Three.js first frame render.
5. `saveScreenshot('visualizer-cube.png')`.
6. `close()`.

The Three.js canvas is WebGL — GPU acceleration in CI can produce blank canvases. See [[VS Code Screenshot Determinism]] for `disable-hardware-acceleration` workaround.

## Related
- [[FrameLocator Chaining for Nested Iframes]]
- [[VS Code Screenshot Determinism]]
- [[Electron Headless via Xvfb]]
