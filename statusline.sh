#!/usr/bin/env bash
# Claude Code status line script
# Two-line full-width layout:
#   Line 1: cwd [session]                                git:(branch*)
#   Line 2: model | ctx | ⏱ duration     5h:N% 7d:N% | $session ($30d)

COST_DIR="$HOME/.claude/session-costs"
COST_LOG="$HOME/.claude/cost-history.log"

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
session_name=$(echo "$input" | jq -r '.session_name // ""')
session_id=$(echo "$input" | jq -r '.session_id // empty')

cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
api_ms=$(echo "$input" | jq -r '.cost.total_api_duration_ms // empty')
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // empty')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // empty')
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

# Sum token usage from the session transcript
tok_in=0
tok_out=0
tok_cache=0
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
	read -r tok_in tok_out tok_cache < <(
		jq -r 'select(.message.usage) | [
        .message.usage.input_tokens // 0,
        .message.usage.output_tokens // 0,
        (.message.usage.cache_creation_input_tokens // 0) + (.message.usage.cache_read_input_tokens // 0)
      ] | @tsv' "$transcript_path" 2>/dev/null |
			awk '{i+=$1; o+=$2; c+=$3} END{printf "%d %d %d", i+0, o+0, c+0}'
	)
fi

# Format token count: 1234567 -> 1.2M, 12345 -> 12k, 234 -> 234
fmt_tokens() {
	awk -v n="${1:-0}" 'BEGIN {
    if (n >= 1000000) printf "%.1fM", n/1000000;
    else if (n >= 1000) printf "%.0fk", n/1000;
    else printf "%d", n;
  }'
}

# Persist current session cost for the SessionEnd hook to pick up
if [ -n "$cost_usd" ] && [ -n "$session_id" ]; then
	mkdir -p "$COST_DIR"
	echo "$cost_usd" >"$COST_DIR/${session_id}.cost"
fi

# Calculate 30-day total from history log
thirty_day_total="0"
if [ -f "$COST_LOG" ]; then
	cutoff=$(date -u -d '30 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null)
	if [ -n "$cutoff" ]; then
		thirty_day_total=$(awk -F'\t' -v cutoff="$cutoff" '$1 >= cutoff { sum += $3 } END { printf "%.2f", sum }' "$COST_LOG")
	fi
fi
if [ -n "$cost_usd" ]; then
	thirty_day_total=$(awk "BEGIN { printf \"%.2f\", $thirty_day_total + $cost_usd }")
fi

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Replace $HOME with ~
home_escaped=$(printf '%s\n' "$HOME" | sed 's/[[\.*^$()+?{|]/\\&/g')
short_cwd=$(echo "$cwd" | sed "s|^$home_escaped|~|")

# Git branch + dirty marker
branch=""
dirty=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null ||
		git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
	if [ -n "$branch" ] && [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ]; then
		dirty="*"
	fi
fi

# Format duration (ms -> human-readable)
fmt_duration() {
	local ms=${1:-0}
	local s=$((ms / 1000))
	if [ "$s" -lt 60 ]; then
		printf '%ds' "$s"
	elif [ "$s" -lt 3600 ]; then
		printf '%dm' $((s / 60))
	else
		printf '%dh%dm' $((s / 3600)) $(((s % 3600) / 60))
	fi
}

# Helpers
strip_ansi() {
	printf '%s' "$1" | sed 's/\x1b\[[0-9;]*m//g'
}

pct_color() {
	local pct=$1
	if [ "$pct" -ge 75 ]; then
		printf '\033[31m' # red
	elif [ "$pct" -ge 50 ]; then
		printf '\033[38;5;208m' # orange
	elif [ "$pct" -ge 25 ]; then
		printf '\033[33m' # yellow
	elif [ "$pct" -ge 10 ]; then
		printf '\033[32m' # green
	else
		printf '\033[92m' # light green
	fi
}

# Render a percentage as a 10-cell bar; color of all filled cells based on pct.
fmt_pct_bar() {
	local pct=$1 width=10 i filled out="" color
	filled=$(((pct * width + 50) / 100))
	[ "$filled" -gt "$width" ] && filled=$width
	[ "$filled" -lt 0 ] && filled=0
	color=$(pct_color "$pct")
	for ((i = 0; i < width; i++)); do
		if [ "$i" -lt "$filled" ]; then
			out+="${color}"$'\xe2\x96\x86\033[0m'
		else
			out+=$'\033[2m\xe2\x96\x86\033[0m'
		fi
	done
	printf '%s' "$out"
}

# Pad left and right segments to fill terminal width
pad_line() {
	local left=$1 right=$2 cols=$3
	local lvis rvis lwidth rwidth space
	lvis=$(strip_ansi "$left")
	rvis=$(strip_ansi "$right")
	lwidth=${#lvis}
	rwidth=${#rvis}
	space=$((cols - lwidth - rwidth))
	if [ "$space" -lt 1 ]; then
		# Not enough space — drop padding, use single space if both present
		if [ -n "$left" ] && [ -n "$right" ]; then
			printf '%s %s' "$left" "$right"
		else
			printf '%s%s' "$left" "$right"
		fi
	else
		printf '%s%*s%s' "$left" "$space" "" "$right"
	fi
}

# Detect terminal width — Claude Code invokes with stdin/stdout piped,
# so COLUMNS is unset and `tput cols` returns 80. Read from /dev/tty if openable.
COLS=""
# if { exec 3</dev/tty; } 2>/dev/null; then
#   COLS=$(stty size <&3 2>/dev/null | awk '{print $2}')
#   [ -z "$COLS" ] && COLS=$(tput cols <&3 2>/dev/null)
#   exec 3<&-
# fi
[ -z "$COLS" ] && COLS=${COLUMNS:-120}
SEP="$(printf '\033[2m|\033[0m')"

# --- Line 1: cwd (branch*) [session]                                    ---
parts1=()
[ -n "$short_cwd" ] && parts1+=("$(printf '\033[34m%s\033[0m' "$short_cwd")")
if [ -n "$branch" ]; then
	if [ -n "$dirty" ]; then
		parts1+=("$(printf '\033[33m(%s%s)\033[0m' "$branch" "$dirty")")
	else
		parts1+=("$(printf '\033[2;32m(%s)\033[0m' "$branch")")
	fi
fi
if [ -n "$lines_added" ] && [ -n "$lines_removed" ] &&
	{ [ "$lines_added" != "0" ] || [ "$lines_removed" != "0" ]; }; then
	parts1+=("$(printf '\033[32m+%s\033[0m\033[2m/\033[0m\033[31m-%s\033[0m' "$lines_added" "$lines_removed")")
fi
[ -n "$session_name" ] && parts1+=("$(printf '\033[35m[%s]\033[0m' "$session_name")")

left1=""
for p in "${parts1[@]}"; do
	if [ -z "$left1" ]; then left1="$p"; else left1="$left1 $p"; fi
done
right1=""

# --- Line 2: model | ctx | ⏱ duration | +/-lines       5h 7d | $cost ($30d) ---
left_parts=()
right_parts=()

[ -n "$model" ] && left_parts+=("$(printf '\033[36m%s\033[0m' "$model")")

if [ -n "$used_pct" ]; then
	used_int=$(printf '%.0f' "$used_pct")
	left_parts+=("$(printf '%s %d%%' "$(fmt_pct_bar "$used_int")" "$used_int")")
fi

if [ -n "$duration_ms" ] && [ "$duration_ms" != "null" ]; then
	dur=$(fmt_duration "$duration_ms")
	left_parts+=("$(printf '\033[2m\xe2\x8f\xb1\033[0m %s' "$dur")")
fi

if { [ "$tok_in" != "0" ] || [ "$tok_out" != "0" ] || [ "$tok_cache" != "0" ]; }; then
	left_parts+=("$(printf '\033[2m\xe2\x86\x91\033[0m %s \033[2m\xe2\x86\x93\033[0m %s \033[2m\xe2\x86\xbb\033[0m %s' \
		"$(fmt_tokens "$tok_in")" "$(fmt_tokens "$tok_out")" "$(fmt_tokens "$tok_cache")")")
fi

rate_parts=()
if [ -n "$five_hour" ]; then
	pct=$(printf '%.0f' "$five_hour")
	color=$(pct_color "$pct")
	rate_parts+=("$(printf "5h:${color}%d%%\033[0m" "$pct")")
fi
if [ -n "$seven_day" ]; then
	pct=$(printf '%.0f' "$seven_day")
	color=$(pct_color "$pct")
	rate_parts+=("$(printf "7d:${color}%d%%\033[0m" "$pct")")
fi
[ ${#rate_parts[@]} -gt 0 ] && left_parts+=("$(
	IFS=' '
	echo "${rate_parts[*]}"
)")

if [ -n "$cost_usd" ]; then
	cost_fmt=$(printf '$%.2f' "$cost_usd")
	total_fmt=$(printf '$%.2f' "$thirty_day_total")
	left_parts+=("$(printf '\033[33m%s\033[0m \033[2m(%s/30d)\033[0m' "$cost_fmt" "$total_fmt")")
fi

# Join with separator
join_parts() {
	local out=""
	local p
	for p in "$@"; do
		[ -z "$p" ] && continue
		if [ -z "$out" ]; then
			out="$p"
		else
			out="$out $SEP $p"
		fi
	done
	printf '%s' "$out"
}

left2=$(join_parts "${left_parts[@]}")
right2=$(join_parts "${right_parts[@]}")

# Output — only pad when right side has content; otherwise just print left.
# Use COLS - 1 so we never exactly equal the pane width (some renderers truncate).
PAD_COLS=$((COLS - 1))
emit_line() {
	local left=$1 right=$2
	if [ -z "$left" ] && [ -z "$right" ]; then return; fi
	if [ -z "$right" ]; then
		printf '%s\n' "$left"
	elif [ -z "$left" ]; then
		printf '%s\n' "$right"
	else
		pad_line "$left" "$right" "$PAD_COLS"
		printf '\n'
	fi
}
emit_line "$left1" "$right1"
emit_line "$left2" "$right2"
