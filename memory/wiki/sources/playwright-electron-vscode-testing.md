---
type: source
title: "Playwright + Electron for VS Code extension testing (Medium + docs)"
source_type: article
author: Azat Satklyčov (Broadcom Modern Mainframe) + Playwright docs + Kubeshop
date_published: 2024-2025
url: "https://medium.com/modern-mainframe/test-automation-with-playwright-for-vs-code-extensions-facilitating-the-growing-interest-in-dcc463f81efa"
date_accessed: 2026-04-19
source_reliability: medium
tags:
  - vscode
  - playwright
  - electron
  - webview
status: current
confidence: EXTRACTED
updated: 2026-04-19
created: 2026-04-19
key_claims:
  - "Playwright's Electron API can launch VS Code as an Electron app and drive it"
  - "Webviews are reached via chained frameLocator() calls (nested iframes)"
  - "Playwright has no true headless mode for Electron — Xvfb is required in CI"
  - "page.screenshot() captures the Electron window identically to a Chromium tab"
related:
  - "[[Playwright]]"
  - "[[VS Code Webview Testing]]"
  - "[[FrameLocator Chaining for Nested Iframes]]"
  - "[[Electron Headless via Xvfb]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
evidence: []
---

# Playwright + Electron for VS Code extension testing

Using Playwright's `_electron` API to launch VS Code directly is an **alternative to wdio-vscode-service and ExTester**. You lose the workbench page objects but gain Playwright's tooling (trace viewer, codegen, UI mode, frame locators).

## Launch pattern

```ts
import { _electron as electron } from "playwright";

const app = await electron.launch({
  executablePath: "/path/to/vscode",
  args: [
    "--extensionDevelopmentPath=" + path.resolve(__dirname, ".."),
    "--disable-workspace-trust",
    "--user-data-dir=/tmp/vscode-test-profile",
    path.resolve(__dirname, "fixtures"),
  ],
});
const window = await app.firstWindow();
await window.screenshot({ path: "shots/01.png" });
await app.close();
```

`executablePath` points at the actual `code` or `Code.exe` binary. Use `@vscode/test-electron`'s `downloadAndUnzipVSCode()` to provision a pinned VS Code and feed its resolved path into Playwright.

## Webview iframe chain

VS Code renders webviews as **nested iframes**:

```
<iframe class="webview ready">            ← outer container
   <iframe name="active-frame"             ← inner sandbox with extension HTML
       src="vscode-webview://...">
```

Playwright pattern:

```ts
const outer = window.frameLocator("iframe.webview");
const inner = outer.frameLocator('iframe[name="active-frame"]');
await expect(inner.locator("#my-button")).toBeVisible();
await window.screenshot({ path: "shots/webview.png" });
```

`frameLocator()` waits for the frame to load, which is the key advantage over `page.frame()`.

## Headless / CI

Playwright does **not** support true headless for Electron — Chromium's `--headless` flag isn't honored by Electron builds. Use Xvfb:

```bash
xvfb-run --auto-servernum --server-args='-screen 0 1920x1080x24' npx playwright test
```

Or in Docker:

```dockerfile
ENV DISPLAY=:99
RUN Xvfb :99 -screen 0 1920x1080x24 & npx playwright test
```

The Playwright VS Code extension itself has issues in devcontainers/SSH because it force-passes `--headed`; for Electron testing of VS Code that isn't the problem.

## Tradeoffs vs wdio-vscode-service

|                                | Playwright+Electron        | wdio-vscode-service                             |
| ------------------------------ | -------------------------- | ----------------------------------------------- |
| Workbench page objects         | None (roll your own)       | Built in (command palette, sidebar, status bar) |
| Frame locators                 | `frameLocator()` chain     | `webview.open()` / `close()`                    |
| Trace viewer / UI mode         | Yes                        | No                                              |
| Codegen (`playwright codegen`) | Works on Electron          | N/A                                             |
| Screenshot of webview-only     | Easy via frame element     | Switch context, screenshot, switch back         |
| Maturity for VS Code           | Less — no official service | More — dedicated maintained service             |

**Recommendation in the raw plan:** Playwright is cleaner for **webview-only screenshots rendered outside IDE chrome** (just load the webview HTML in plain Chromium); wdio wins for **full-IDE flows with workbench affordances**. The research confirms this split.

## Sources

- [Playwright VS Code extension tests (Medium)](https://medium.com/modern-mainframe/test-automation-with-playwright-for-vs-code-extensions-facilitating-the-growing-interest-in-dcc463f81efa)
- [Playwright FrameLocator API](https://playwright.dev/docs/api/class-framelocator)
- [Testing Electron with Playwright (Kubeshop)](https://medium.com/kubeshop-i/testing-electron-apps-with-playwright-kubeshop-839ff27cf376)
- [Playwright Electron headless issue #2609](https://github.com/microsoft/playwright/issues/2609)
- [VS Code as a Playwright target (issue #22351)](https://github.com/microsoft/playwright/issues/22351)
