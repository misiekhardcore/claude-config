#!/usr/bin/env bash
# Symlinks Claude Code config files from this repo into ~/.claude/
# and generates templated configs (mcp.json) from templates.
# Run: bash install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude"

mkdir -p "$TARGET_DIR"

# ── Symlink static files ─────────────────────────────────────────────────────
files=(CLAUDE.md settings.json RTK.md REFERENCE.md statusline.sh)

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
# `skills` contains personal repo-level skills (e.g. load-pr-guidelines, load-issue-guidelines).
# Workflow skills come from the claude-workflow plugin installed below.
dirs=(hooks plugins memory skills)

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

# ── Set up Obsidian vault ─────────────────────────────────────────────────────
VAULT_DIR="$SCRIPT_DIR/memory"
if [ -d "$VAULT_DIR" ] && [ -f "$VAULT_DIR/bin/setup-vault.sh" ]; then
	echo ""
	echo "Setting up Obsidian vault..."
	bash "$VAULT_DIR/bin/setup-vault.sh" "$VAULT_DIR"
else
	echo "skip: memory/bin/setup-vault.sh not found"
fi

# ── Install plugins from custom marketplaces ─────────────────────────────────
if command -v claude &>/dev/null; then
	echo ""
	echo "Installing plugins..."

	# Add custom marketplaces (idempotent — skips if already present)
	claude plugin marketplace add max-sixty/worktrunk 2>/dev/null || true
	claude plugin marketplace add misiekhardcore/claude-obsidian 2>/dev/null || true
	claude plugin marketplace add misiekhardcore/claude-workflow 2>/dev/null || true

	# Install plugins from custom marketplaces
	claude plugin install worktrunk@worktrunk 2>/dev/null || true
	claude plugin install claude-obsidian@claude-obsidian 2>/dev/null || true
	claude plugin install claude-workflow@claude-workflow 2>/dev/null || true

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

# ── Optional CLI tools ──────────────────────────────────────────────────────
echo ""
printf "[?] Install optional CLI tools (RTK)? (y/N) "
read -r reply
if [[ "$reply" =~ ^[Yy]$ ]]; then
	bash "$SCRIPT_DIR/install-tools.sh"
fi
