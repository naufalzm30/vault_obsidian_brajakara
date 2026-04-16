#!/usr/bin/env bash
# caveman-statusline.sh — Claude Code status line with caveman mode indicator

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
dir=$(basename "$cwd")
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Caveman indicator
CAVEMAN="CAVEMAN"

# Context usage segment
ctx_seg=""
if [ -n "$used" ]; then
    ctx_int=$(printf "%.0f" "$used")
    ctx_seg=" | ctx:${ctx_int}%"
fi

# Build status line with ANSI colors (dimmed-friendly)
# Format: [CAVEMAN] model | dir | ctx%
printf "\033[1;33m[%s]\033[0m \033[0;36m%s\033[0m | \033[0;32m%s\033[0m%s" \
    "$CAVEMAN" "$model" "$dir" "$ctx_seg"
