#!/usr/bin/env bash
# Install optional CLI tools that complement the Claude Code setup.
# Each tool asks for confirmation before installing. Safe to re-run.
# Run: bash install-tools.sh

set -uo pipefail

_confirm() {
	printf "\n[?] %s (y/N) " "$1"
	read -r reply
	[[ "$reply" =~ ^[Yy]$ ]]
}

_ok() { printf "  [ok] %s\n" "$1"; }
_skip() { printf "  [--] %s — skipped\n" "$1"; }

echo "========================================"
echo " Claude Code — tool installer"
echo " OS: $(uname -s)"
echo "========================================"

# ── RTK (Rust Token Killer) ───────────────────────────────────────────────────
if command -v rtk &>/dev/null; then
	_ok "RTK already installed ($(rtk --version 2>/dev/null || echo '?'))"
else
	if _confirm "Install RTK (60-90% token savings on shell output)?"; then
		curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
		rtk init -g
		_ok "RTK installed and hooked into Claude Code"
	else
		_skip "RTK"
	fi
fi


echo ""
echo "Setup complete"
