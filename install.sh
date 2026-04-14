#!/usr/bin/env bash
# Symlinks Claude Code config files from this repo into ~/.claude/
# and generates templated configs (mcp.json) from templates.
# Run: bash install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude"

mkdir -p "$TARGET_DIR"

# ── Symlink static files ─────────────────────────────────────────────────────
files=(CLAUDE.md settings.json RTK.md REFERENCE.md)

for file in "${files[@]}"; do
	src="$SCRIPT_DIR/$file"
	dest="$TARGET_DIR/$file"

	if [ ! -f "$src" ]; then
		echo "skip: $file not found in repo"
		continue
	fi

	if [ -L "$dest" ]; then
		rm "$dest"
	elif [ -f "$dest" ]; then
		echo "backup: $dest -> $dest.bak"
		mv "$dest" "$dest.bak"
	fi

	ln -s "$src" "$dest"
	echo "linked: $dest -> $src"
done

# ── Symlink directories ──────────────────────────────────────────────────────
dirs=(hooks skills plugins)

for dir in "${dirs[@]}"; do
	src="$SCRIPT_DIR/$dir"
	dest="$TARGET_DIR/$dir"

	if [ ! -d "$src" ]; then
		echo "skip: $dir/ not found in repo"
		continue
	fi

	if [ -L "$dest" ]; then
		rm "$dest"
	elif [ -d "$dest" ]; then
		echo "backup: $dest -> $dest.bak"
		mv "$dest" "$dest.bak"
	fi

	ln -s "$src" "$dest"
	echo "linked: $dest -> $src"
done

# ── Install plugins from custom marketplaces ─────────────────────────────────
if command -v claude &>/dev/null; then
	echo ""
	echo "Installing plugins..."

	# Add custom marketplaces (idempotent — skips if already present)
	claude plugin marketplace add jarrodwatts/claude-hud 2>/dev/null || true
	claude plugin marketplace add max-sixty/worktrunk 2>/dev/null || true

	# Install plugins from custom marketplaces
	claude plugin install claude-hud@claude-hud 2>/dev/null || true
	claude plugin install worktrunk@worktrunk 2>/dev/null || true

	echo "plugins installed"
else
	echo "skip: claude CLI not found — install plugins manually with 'claude plugin install'"
fi

# ── Generate templated configs ────────────────────────────────────────────────
templates=(mcp.json.template)

for tmpl in "${templates[@]}"; do
	src="$SCRIPT_DIR/$tmpl"
	target="${tmpl%.template}" # mcp.json.template -> mcp.json
	dest="$TARGET_DIR/$target"

	if [ ! -f "$src" ]; then
		echo "skip: $tmpl not found in repo"
		continue
	fi

	if [ -f "$dest" ] && [ ! -L "$dest" ]; then
		echo "backup: $dest -> $dest.bak"
		cp "$dest" "$dest.bak"
	fi

	envsubst <"$src" >"$dest"
	echo "generated: $dest (from $tmpl)"
done

# ── CodeGraph ────────────────────────────────────────────────────────────────
echo ""
echo "CodeGraph: run these once to enable semantic code search:"
echo "  npm install -g @colbymchenry/codegraph"
echo "  claude mcp add codegraph 'codegraph serve --mcp' -s user"
echo "  Then in each project: codegraph init -i"

# ── Optional CLI tools ──────────────────────────────────────────────────────
echo ""
printf "[?] Install optional CLI tools (RTK, rudel, pi-self-learning)? (y/N) "
read -r reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
	bash "$SCRIPT_DIR/install-tools.sh"
fi
