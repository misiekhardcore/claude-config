---
type: concept
title: "FrameLocator Chaining for Nested Iframes"
created: 2026-04-19
updated: 2026-04-20
tags:
  - playwright
  - iframe
  - testing
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[playwright-electron-vscode-testing]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[Playwright]]"
sources:
  - "[[playwright-electron-vscode-testing]]"
---

# FrameLocator Chaining for Nested Iframes

> Playwright's `frameLocator()` waits for an iframe to load and returns a locator scoped to its content. Chain them to reach iframes nested inside iframes — exactly the shape of a VS Code webview.

## Two ways to reach an iframe

| | `page.frame(name|url)` | `page.frameLocator(selector)` |
|---|---|---|
| Returns | `Frame` (or `null`) | `FrameLocator` (always, lazy) |
| Waits for load | No | Yes |
| Nested support | Manual traversal via `frame.childFrames()` | Chain `.frameLocator(...)` directly |
| Recommended for | Static, named frames | Dynamic, async, nested (webviews) |

## Canonical VS Code webview chain

```ts
const outer = window.frameLocator('iframe.webview');
const inner = outer.frameLocator('iframe[name="active-frame"]');
await expect(inner.locator('#ready')).toBeVisible();
await inner.locator('button.start').click();
```

Selectors to know:
- `iframe.webview` — VS Code's outer webview wrapper.
- `iframe[name="active-frame"]` — the inner sandbox Chrome mounts the extension HTML in. Sometimes has `src="vscode-webview://..."`.

## Strictness

Frame locators are **strict**. If `iframe.webview` matches multiple elements (common when the Welcome page and your webview are both open), the call throws. Disambiguate with:

```ts
window.frameLocator('iframe.webview[src*="your-panel-id"]')
```

…or close other editors first.

## Converting between Locator and FrameLocator

- `locator.contentFrame()` → `FrameLocator` (when you have a handle on the iframe element).
- `frameLocator.owner()` → `Locator` (when you need to click/screenshot the iframe element itself, not its contents).

## WebdriverIO equivalent

WDIO's `switchFrame(url|element|fn)` (v9+) is imperative — it mutates the driver's context instead of returning a scoped locator. The `wdio-vscode-service` `WebView.open()` encapsulates this, switching into the webview's active frame.

Known WDIO v9 bug: after `switchFrame()`, `click()` can fail while `isExisting()` works. Track WDIO issue #13763.

## Sources
- [Playwright FrameLocator docs](https://playwright.dev/docs/api/class-framelocator)
- [Playwright iframes tutorial](https://www.testmu.ai/learning-hub/handling-iframes-in-playwright/)
