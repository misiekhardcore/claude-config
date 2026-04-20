---
type: concept
title: "VS Code Screenshot Determinism"
created: 2026-04-19
updated: 2026-04-20
tags:
  - vscode
  - screenshots
  - reproducibility
  - documentation
status: current
tier: semantic
reviewed_at: 2026-04-20
confidence: high
confidence: INFERRED
evidence:
  - "[[hakanson-vscode-actions-xvfb]]"
  - "[[wdio-vscode-service-docs]]"
related:
  - "[[VS Code Webview Testing]]"
  - "[[Electron Headless via Xvfb]]"
sources:
  - "[[hakanson-vscode-actions-xvfb]]"
  - "[[wdio-vscode-service-docs]]"
---

# VS Code Screenshot Determinism

> Screenshots for documentation must be **bit-reproducible across machines** — otherwise every contributor's run produces a noisy diff. Determinism requires pinning five things.

## The five axes of drift

1. **VS Code version.** A minor VS Code update shifts icons, spacing, and theme tokens.
2. **Viewport size.** Local machines and CI runners default to different sizes.
3. **Theme.** Even within VS Code's own themes, version bumps tweak colors.
4. **Font family + size.** Missing local fonts fall back to system defaults; Linux and macOS render the same font differently.
5. **DPI / zoom.** `window.zoomLevel` and OS-level scaling change pixel counts silently.

## Pinning recipe

```ts
// wdio.conf.ts (or Playwright equivalent)
capabilities: [{
  browserName: 'vscode',
  browserVersion: '1.95.0',               // pin exact version, not 'stable'
  'wdio:vscodeOptions': {
    extensionPath: path.join(__dirname, '..'),
    workspacePath: path.join(__dirname, 'fixtures'),
    userSettings: {
      'workbench.colorTheme': 'Default Dark Modern',
      'editor.fontFamily': 'Droid Sans Mono',   // ship it as a test asset
      'editor.fontSize': 14,
      'editor.minimap.enabled': false,
      'editor.lineNumbers': 'on',
      'workbench.activityBar.location': 'default',
      'window.zoomLevel': 0,
    },
  },
}]
```

## Ship fonts as test assets

Don't rely on the system having your chosen font. Install it in the CI step:

```yaml
- name: Install test fonts
  run: |
    mkdir -p ~/.local/share/fonts
    cp test/fonts/DroidSansMono.ttf ~/.local/share/fonts/
    fc-cache -f
```

Or inside VS Code, set `editor.fontFamily` to a font you know is universally present (`monospace`, `Consolas` on Windows, `Menlo` on macOS — but these differ across OSes, so pick one and install it everywhere).

## Set the Xvfb resolution explicitly

Default `xvfb-run -a` picks 1280×1024. Force it:

```bash
xvfb-run --server-args='-screen 0 1920x1080x24' npm test
```

VS Code on Linux still has known DPI quirks where it renders fonts at 72 dpi instead of 96 dpi (microsoft/vscode#26453). If screenshots look pixelated, add the Chromium flag `--force-device-scale-factor=1` via `args` in the launch options.

## Dark vs light theme

Pick one. Don't interleave. The README should show one screenshot set per doc section. If you must support both, produce `foo-dark.png` and `foo-light.png` via two separate test runs with different `workbench.colorTheme` values.

## GPU-dependent content (WebGL, Three.js)

The G-code visualizer uses WebGL. Xvfb's software rasterizer can produce subtle diffs or blank frames. Options:

- Run WebGL screenshot tests on macOS/Windows CI runners (hardware GPU) instead of Linux.
- Use `--use-gl=swiftshader` flag for deterministic software GL.
- Or screenshot the **webview HTML in plain Playwright** (outside VS Code) where you control the Chromium build.

## Treat CI as the source of truth

Local runs are for iteration. Committed screenshots are the CI-generated ones. If a contributor commits locally-generated PNGs the diffs will be churn. Enforce via a CI check: regenerate, compare, fail if non-identical.

## Sources
- [VS Code DPI issue microsoft/vscode#26453](https://github.com/Microsoft/vscode/issues/26453)
- [VSCodium DPI differences](https://github.com/VSCodium/vscodium/issues/1044)
- [Kevin Hakanson: disable-hardware-acceleration via argv.json](https://kevinhakanson.com/2024-02-12-testing-a-visual-studio-code-extension-inside-github-actions/)
