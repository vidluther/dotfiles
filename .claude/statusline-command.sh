#!/usr/bin/env bash
# Claude Code statusLine command - mirrors fish_prompt style

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Colors (ANSI)
reset="\033[0m"
brgreen="\033[92m"
brpurple="\033[95m"
cyan="\033[36m"

# Shorten the path like fish's prompt_pwd (show full path, abbreviated parents)
short_cwd=$(echo "$cwd" | sed "s|$HOME|~|")

# Git branch (mirrors fish_vcs_prompt)
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        git_info=" (${branch})"
    fi
fi

# Context usage indicator
ctx_info=""
if [ -n "$used_pct" ]; then
    ctx_info=" [ctx: ${used_pct}%]"
fi

# Line 1: user@host cwd git_info  model ctx
printf "${brgreen}$(whoami)@$(hostname -s)${reset} ${cyan}${short_cwd}${reset}${brpurple}${git_info}${reset}  ${model}${ctx_info}\n"
