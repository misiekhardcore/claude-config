---
type: concept
title: "Electron Headless via Xvfb"
created: 2026-04-19
updated: 2026-04-20
tags:
  - electron
  - xvfb
  - ci
  - headless
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[playwright-electron-vscode-testing]]"
  - "[[hakanson-vscode-actions-xvfb]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[VS Code Screenshot Determinism]]"
sources:
  - "[[playwright-electron-vscode-testing]]"
  - "[[hakanson-vscode-actions-xvfb]]"
---

# Electron Headless via Xvfb

> Electron apps (VS Code, Discord, Slack) have **no honest headless mode**. Chromium's `--headless` flag is not implemented in Electron builds. On Linux CI, you run Electron against a virtual X server (Xvfb) instead.

## Why not just `--headless`?

Chromium's headless mode requires a custom build and is incompatible with how Electron ships. Issue [playwright#2609](https://github.com/microsoft/playwright/issues/2609) tracks the limitation — workaround is Xvfb.

## The standard invocation

```bash
xvfb-run \
  --auto-servernum \
  --server-args='-screen 0 1920x1080x24' \
  npx playwright test
```

- `--auto-servernum` — find a free display number automatically.
- `-screen 0 1920x1080x24` — screen index 0, resolution 1920×1080, 24-bit color.

**Pin the resolution** for reproducible screenshots. `xvfb-run -a` without `--server-args` picks a default (usually 1280×1024) that differs from local dev.

## Docker pattern

```dockerfile
FROM mcr.microsoft.com/playwright:jammy
ENV DISPLAY=:99
CMD Xvfb :99 -screen 0 1920x1080x24 & npx playwright test
```

## GitHub Actions pattern

Matrix-style, xvfb only on Linux:

```yaml
- run: xvfb-run -a --server-args='-screen 0 1920x1080x24' npm test
  if: runner.os == 'Linux'
- run: npm test
  if: runner.os != 'Linux'
```

## Failure modes

Common CI errors and fixes:

| Error | Cause | Fix |
|---|---|---|
| `Unable to open X display` | No Xvfb running | Wrap command in `xvfb-run` |
| `Failed to connect to the bus` | No D-Bus session | Start `dbus-daemon --session` and export `DBUS_SESSION_BUS_ADDRESS` before xvfb |
| `Exiting GPU process due to errors` | Chromium GPU probing fails in Xvfb | Set `disable-hardware-acceleration: true` in `argv.json` |
| Blank WebGL canvas in screenshots | Software rasterization issues | Add `--use-gl=swiftshader` Chromium flag, or skip GPU-dependent shots in CI |

See [[hakanson-vscode-actions-xvfb]] for the full GitHub Actions recipe with D-Bus setup.

## Headed vs true-headless: the Playwright VS Code extension quirk

The **Playwright VS Code extension** (the one that runs your Playwright tests from the IDE) always passes `--headed` — problematic in devcontainers/SSH without X. Not a problem when you're the one writing tests *for* VS Code, just when you're running tests *inside* VS Code over SSH. Tracked in playwright#23805 / playwright#29188.

## Sources
- [Playwright Electron headless issue #2609](https://github.com/microsoft/playwright/issues/2609)
- [Playwright Docker Electron issue #8198](https://github.com/microsoft/playwright/issues/8198)
- [Xvfb with Playwright CI/CD (TO THE NEW)](https://www.tothenew.com/blog/playwright-with-ci-cd-harnessing-headless-browsers-xvfb-for-seamless-automation-in-node-js/)
