#!/bin/sh
mkdir -p "$HOME/.claude/usage-data"
printf '%s\t%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$(pwd)" \
    >> "$HOME/.claude/usage-data/cwd-trace.log" 2>/dev/null || true

input=$(cat)

case "$input" in
    *'"gh issue edit'* | *'"gh pr edit'* | *'"git push'*)
        case "$input" in
            *'--repo'*) ;;
            *)
                remote=$(git remote get-url origin 2>/dev/null || true)
                printf 'WARNING: cross-repo risk — CWD: %s, inferred repo: %s\n' "$(pwd)" "$remote" >&2
                ;;
        esac
        ;;
esac

exit 0
