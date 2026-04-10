#!/usr/bin/env bash
# PostToolUse hook — runs linter on files after Edit/Write tool calls.
# Outputs lint errors as user-visible feedback so the agent self-corrects.
#
# Supports: ESLint (JS/TS), Maven Spotless (Java)
# Design: single-file lint, timeout 2s, silent on success or missing config.

if ! command -v jq &>/dev/null; then
  exit 0
fi

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

# Only run on Edit or Write
case "$TOOL_NAME" in
  Edit|Write) ;;
  *) exit 0 ;;
esac

FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

EXT="${FILE_PATH##*.}"

# --- JS/TS: ESLint ---
case "$EXT" in
  ts|tsx|js|jsx|mjs|cjs)
    # Walk up to find project root (nearest package.json)
    DIR=$(dirname "$FILE_PATH")
    PROJECT_ROOT=""
    while [ "$DIR" != "/" ]; do
      if [ -f "$DIR/package.json" ]; then
        PROJECT_ROOT="$DIR"
        break
      fi
      DIR=$(dirname "$DIR")
    done

    if [ -z "$PROJECT_ROOT" ]; then
      exit 0
    fi

    # Check for ESLint config
    HAS_CONFIG=false
    for pattern in "$PROJECT_ROOT"/eslint.config.* "$PROJECT_ROOT"/.eslintrc*; do
      if [ -e "$pattern" ]; then
        HAS_CONFIG=true
        break
      fi
    done

    if [ "$HAS_CONFIG" = false ]; then
      exit 0
    fi

    ESLINT_BIN="$PROJECT_ROOT/node_modules/.bin/eslint"
    if [ ! -x "$ESLINT_BIN" ]; then
      exit 0
    fi

    OUTPUT=$(cd "$PROJECT_ROOT" && timeout 2s "$ESLINT_BIN" --no-warn-ignored --max-warnings=0 "$FILE_PATH" 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 124 ]; then
      exit 0  # timed out, skip silently
    fi

    if [ $EXIT_CODE -ne 0 ] && [ -n "$OUTPUT" ]; then
      echo "[lint] ESLint errors in $(basename "$FILE_PATH"):"
      echo "$OUTPUT" | head -30
    fi
    ;;

  # --- Java: Maven Spotless ---
  java)
    DIR=$(dirname "$FILE_PATH")
    PROJECT_ROOT=""
    while [ "$DIR" != "/" ]; do
      if [ -f "$DIR/pom.xml" ]; then
        PROJECT_ROOT="$DIR"
        break
      fi
      DIR=$(dirname "$DIR")
    done

    if [ -z "$PROJECT_ROOT" ]; then
      exit 0
    fi

    # Spotless single-file check with strict timeout (JVM startup is slow)
    REL_PATH=$(realpath --relative-to="$PROJECT_ROOT" "$FILE_PATH" 2>/dev/null || echo "$FILE_PATH")
    OUTPUT=$(cd "$PROJECT_ROOT" && timeout 2s mvn spotless:check -DspotlessFiles="$REL_PATH" -q 2>&1)
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 124 ]; then
      exit 0  # timed out, skip silently
    fi

    if [ $EXIT_CODE -ne 0 ] && [ -n "$OUTPUT" ]; then
      echo "[lint] Spotless errors in $(basename "$FILE_PATH"):"
      echo "$OUTPUT" | head -20
    fi
    ;;
esac

exit 0
