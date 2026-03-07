#!/usr/bin/env bash
# Claude Code statusLine command - multiline with context bar and metadata

input=$(cat)

# Parse all fields in a single jq call for efficiency
eval "$(echo "$input" | jq -r '
  @sh "cwd=\(.cwd)",
  @sh "model=\(.model.display_name)",
  @sh "used_pct=\(.context_window.used_percentage // 0)",
  @sh "session_name=\(.session.name // "")",
  @sh "output_style=\(.output_style // "")",
  @sh "perm_mode=\(.permission_mode // "default")"
')"

# Colors (ANSI)
reset="\033[0m"
brgreen="\033[92m"
brpurple="\033[95m"
cyan="\033[36m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"
dim="\033[2m"

# Shorten home dir in path
short_cwd=$(echo "$cwd" | sed "s|$HOME|~|")

# Git branch
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info=" (${branch})"
    fi
fi

# --- Line 1: user@host cwd (branch) ---
# Use %b to interpret \033 escapes while keeping literal % safe
printf '%b\n' "${brgreen}$(whoami)@$(hostname -s)${reset} ${cyan}${short_cwd}${reset}${brpurple}${git_info}${reset}"

# --- Line 2: model │ context bar │ perm mode │ output style │ session ---

# Context bar: 10-char visual bar
filled=$(( used_pct * 10 / 100 ))
empty=$(( 10 - filled ))
bar=""
for ((i=0; i<filled; i++)); do bar+="█"; done
for ((i=0; i<empty; i++)); do bar+="░"; done

# Bar color based on usage threshold
if [ "$used_pct" -gt 75 ]; then
    bar_color="$red"
elif [ "$used_pct" -ge 50 ]; then
    bar_color="$yellow"
else
    bar_color="$green"
fi

# Permission mode icon + label
case "$perm_mode" in
    plan)    perm_display="📋 plan" ;;
    auto)    perm_display="⚡ auto" ;;
    *)       perm_display="🔒 default" ;;
esac

# Build line 2
line2="${model} ${dim}│${reset} ${bar_color}${bar}${reset} ${used_pct}% ${dim}│${reset} ${perm_display} ${dim}│${reset} ${output_style}"

# Conditionally append session name
if [ -n "$session_name" ]; then
    line2+=" ${dim}│${reset} ✎ ${session_name}"
fi

printf '%b\n' "$line2"
