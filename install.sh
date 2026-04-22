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
# Note: `skills` is intentionally omitted — workflow skills now come from the
# claude-workflow plugin (installed below). Any personal one-off skills can live
# directly under ~/.claude/skills/.
dirs=(hooks plugins memory)

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
	claude plugin marketplace add jarrodwatts/claude-hud 2>/dev/null || true
	claude plugin marketplace add max-sixty/worktrunk 2>/dev/null || true
	claude plugin marketplace add misiekhardcore/claude-obsidian 2>/dev/null || true
	claude plugin marketplace add misiekhardcore/claude-workflow 2>/dev/null || true

	# Install plugins from custom marketplaces
	claude plugin install claude-hud@claude-hud 2>/dev/null || true
	claude plugin install worktrunk@worktrunk 2>/dev/null || true
	claude plugin install claude-obsidian@claude-obsidian 2>/dev/null || true
	claude plugin install claude-workflow@claude-workflow 2>/dev/null || true

	echo "plugins installed"
else
	echo "skip: claude CLI not found — install plugins manually with 'claude plugin install'"
fi

# ── Register Obsidian vault MCP server ────────────────────────────────────────
if command -v claude &>/dev/null && [ -d "$VAULT_DIR" ]; then
	echo ""
	echo "Obsidian MCP setup:"
	echo "  1. Open Obsidian → Settings → Community Plugins → turn off Restricted Mode"
	echo "  2. Browse → search 'Local REST API' → Install → Enable"
	echo "  3. Settings → Local REST API → copy the API key"
	echo ""
	printf "[?] Paste your Obsidian Local REST API key (leave blank to skip): "
	read -r OBSIDIAN_API_KEY

	if [ -n "$OBSIDIAN_API_KEY" ]; then
		claude mcp add-json obsidian-vault "{
  \"type\": \"stdio\",
  \"command\": \"uvx\",
  \"args\": [\"mcp-obsidian\"],
  \"env\": {
    \"OBSIDIAN_API_KEY\": \"$OBSIDIAN_API_KEY\",
    \"OBSIDIAN_HOST\": \"127.0.0.1\",
    \"OBSIDIAN_PORT\": \"27124\",
    \"NODE_TLS_REJECT_UNAUTHORIZED\": \"0\"
  }
}" --scope user 2>/dev/null || true
		echo "obsidian-vault MCP server registered (REST API mode)"
		echo "  Verify: claude mcp get obsidian-vault"
	else
		echo "skip: no API key provided — run 'claude mcp add-json obsidian-vault ...' manually later"
		echo "  See: memory/skills/wiki/references/mcp-setup.md"
	fi
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
