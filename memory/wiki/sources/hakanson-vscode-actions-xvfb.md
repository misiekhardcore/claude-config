---
type: source
title: "Testing a VS Code Extension inside GitHub Actions"
source_type: blog
author: Kevin Hakanson
date_published: 2024-02-12
url: "https://kevinhakanson.com/2024-02-12-testing-a-visual-studio-code-extension-inside-github-actions/"
date_accessed: 2026-04-19
source_reliability: high
tags:
  - github-actions
  - ci
  - vscode
  - xvfb
status: current
confidence: EXTRACTED
key_claims:
  - "Cache .vscode-test to avoid re-downloading VS Code on every CI run"
  - "D-Bus session must be started before xvfb-run to avoid 'Failed to connect to the bus'"
  - "disable-hardware-acceleration in argv.json prevents GPU init errors"
  - "Matrix across OSes with xvfb-run -a only on Linux is the canonical pattern"
related:
  - "[[Electron Headless via Xvfb]]"
  - "[[Research: VS Code Webview Testing and Screenshots]]"
evidence: []
---

# GitHub Actions for VS Code extension tests

Practical CI recipes — especially the unobvious fixes for GPU and D-Bus errors on `ubuntu-latest`.

## Canonical workflow (official VS Code docs)

```yaml
jobs:
  build:
    strategy:
      matrix:
        os: [macos-latest, ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20 }
      - run: npm ci
      - run: npm run compile
      - run: xvfb-run -a npm test
        if: runner.os == 'Linux'
      - run: npm test
        if: runner.os != 'Linux'
```

## Cache the VS Code download

Without caching, every run re-downloads the ~200MB VS Code binary:

```yaml
- id: code-stable
  run: echo "VSCODE_VERSION=$(node -p "require('vscode-versions').stable")" >> $GITHUB_OUTPUT
- uses: actions/cache@v4
  with:
    path: .vscode-test
    key: vscode-test-${{ runner.os }}-${{ steps.code-stable.outputs.VSCODE_VERSION }}
```

## Fix D-Bus + GPU errors

Common failure messages on `ubuntu-latest`:

- `Failed to connect to the bus: Failed to connect to socket /run/dbus/...`
- `Exiting GPU process due to errors during initialization`

Mitigation before `xvfb-run`:

```yaml
- run: |
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    mkdir -p $XDG_RUNTIME_DIR
    dbus-daemon --session --address="unix:path=$XDG_RUNTIME_DIR/bus" &
    export DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
    xvfb-run -a npm run test
```

Or ship an `argv.json` disabling GPU:

```json
{ "disable-hardware-acceleration": true }
```

…and point VS Code at it via `--user-data-dir`.

## Screenshot-specific note

For **reproducible screenshots** on Linux CI, pin Xvfb resolution explicitly rather than letting `xvfb-run -a` guess:

```bash
xvfb-run --auto-servernum --server-args='-screen 0 1920x1080x24' npm run test:docs
```

Inconsistent screen sizes between local and CI are the #1 cause of screenshot diff churn.

## Sources

- [Kevin Hakanson blog (2024-02-12)](https://kevinhakanson.com/2024-02-12-testing-a-visual-studio-code-extension-inside-github-actions/)
- [VS Code CI docs](https://code.visualstudio.com/api/working-with-extensions/continuous-integration)
- [Troubleshooting dev.to (May 2025)](https://dev.to/generatecodedev/how-to-troubleshoot-vs-code-extension-tests-in-github-actions-4dec)
