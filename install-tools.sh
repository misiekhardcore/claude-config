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

# ── rudel (session analytics) ─────────────────────────────────────────────────
if command -v rudel &>/dev/null; then
	_ok "rudel already installed"
else
	if _confirm "Install rudel (session analytics dashboard)? Note: uploads full transcripts"; then
		npm install -g rudel
		_ok "rudel installed — run: rudel login && rudel enable"
	else
		_skip "rudel"
	fi
fi

# ── pi-self-learning (recurring learnings promoted to CORE.md) ────────────────
if command -v pi &>/dev/null; then
	_ok "pi CLI already installed"
else
	if _confirm "Install pi-self-learning (promotes recurring learnings across sessions)?"; then
		npm install -g @mariozechner/pi-coding-agent
		pi install npm:pi-self-learning
		_ok "pi-self-learning installed"
		echo "      Commands: /learning-now (session), /learning-month (promote recurring to CORE.md)"
	else
		_skip "pi-self-learning"
	fi
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "========================================"
echo " Done. Other tools to evaluate:"
echo "========================================"
echo ""
echo "  rtk discover     — find missed token savings in Claude Code history"
echo "  rtk gain          — show token savings analytics"
echo ""
