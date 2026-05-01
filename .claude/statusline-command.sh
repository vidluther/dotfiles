#!/bin/bash
set -f
# Claude Code statusLine — starship-themed, 3-line layout, width-aware.
# Line 1:  opus-4-7 │ ✍ 76% │ workspace  main* │ ✎ session │  12m │ ⛅ 86°F · 30°C │ ◐ thinking
# Line 2: current ●●●○○○○○○○ 28%  ⟳ 7:00pm
# Line 3: weekly  ●●●●●●●●○○ 79%  ⟳ may 10, 10:00am
#
# Drops segments in this order on narrow terminals:
#   weather → session name → duration → thinking → git dirty marker

input=$(cat)
if [ -z "$input" ]; then
    printf "Claude"
    exit 0
fi

# ── Palette: GitHub theme from ~/.config/starship.toml ──────────
accent='\033[38;2;31;111;235m'    # #1f6feb  starship accent block
git_green='\033[38;2;63;185;80m'  # #3fb950  starship git_branch fg
warn='\033[38;2;247;129;102m'     # #f78166  starship git_status fg
info='\033[38;2;121;192;255m'     # #79c0ff  starship time fg
white='\033[38;2;255;255;255m'    # starship directory fg
red='\033[38;2;255;85;85m'
yellow='\033[38;2;230;200;0m'
orange='\033[38;2;255;176;85m'
green='\033[38;2;0;175;80m'
magenta='\033[38;2;180;140;255m'
dim='\033[2m'
reset='\033[0m'

sep=" ${dim}│${reset} "

# ── Helpers ─────────────────────────────────────────────────────
# Visible column width after rendering ANSI escapes.
# - printf %b expands literal `\033[...m` into real ESC sequences.
# - sed strips them.
# - ${#stripped} counts characters; we then add +1 for each "wide" emoji
#   that lacks a variation selector (those render as 2 columns but count as 1).
visible_len() {
    local rendered stripped wide
    rendered=$(printf "%b" "$1")
    stripped=$(printf "%s" "$rendered" | sed $'s/\E\\[[0-9;]*[A-Za-z]//g')
    wide=$(printf "%s" "$stripped" | grep -oE '⛅' 2>/dev/null | wc -l | tr -d ' ')
    echo $(( ${#stripped} + wide ))
}

# Parse "HH:MM AM/PM" → minutes since midnight. Returns 0 on bad input.
parse_ampm_to_minutes() {
    local t="$1" hhmm ampm h m
    [ -z "$t" ] && { echo 0; return; }
    hhmm="${t%% *}"
    ampm="${t##* }"
    h="${hhmm%:*}"
    m="${hhmm#*:}"
    h=$((10#${h:-0}))
    m=$((10#${m:-0}))
    if [ "$ampm" = "AM" ]; then
        [ "$h" -eq 12 ] && h=0
    elif [ "$ampm" = "PM" ]; then
        [ "$h" -ne 12 ] && h=$(( h + 12 ))
    fi
    echo $(( h * 60 + m ))
}

color_for_pct() {
    local pct=$1
    if [ "$pct" -ge 90 ]; then printf "$red"
    elif [ "$pct" -ge 70 ]; then printf "$yellow"
    elif [ "$pct" -ge 50 ]; then printf "$orange"
    else printf "$green"
    fi
}

build_bar() {
    local pct=$1 width=$2
    [ "$pct" -lt 0 ] 2>/dev/null && pct=0
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar_color filled_str="" empty_str=""
    bar_color=$(color_for_pct "$pct")
    for ((i=0; i<filled; i++)); do filled_str+="●"; done
    for ((i=0; i<empty; i++)); do empty_str+="○"; done
    printf "${bar_color}${filled_str}${dim}${empty_str}${reset}"
}

iso_to_epoch() {
    local iso_str="$1" epoch
    epoch=$(date -d "${iso_str}" +%s 2>/dev/null)
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    local stripped="${iso_str%%.*}"
    stripped="${stripped%%Z}"
    stripped="${stripped%%+*}"
    stripped="${stripped%%-[0-9][0-9]:[0-9][0-9]}"
    if [[ "$iso_str" == *"Z"* ]] || [[ "$iso_str" == *"+00:00"* ]] || [[ "$iso_str" == *"-00:00"* ]]; then
        epoch=$(env TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    else
        epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null)
    fi
    [ -n "$epoch" ] && { echo "$epoch"; return 0; }
    return 1
}

format_reset_time() {
    local iso_str="$1" style="$2"
    [ -z "$iso_str" ] || [ "$iso_str" = "null" ] && return
    local epoch
    epoch=$(iso_to_epoch "$iso_str")
    [ -z "$epoch" ] && return
    case "$style" in
        time)
            date -j -r "$epoch" +"%l:%M%p" 2>/dev/null | sed 's/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]' \
              || date -d "@$epoch" +"%l:%M%P" 2>/dev/null | sed 's/^ //; s/\.//g'
            ;;
        datetime)
            date -j -r "$epoch" +"%b %-d, %l:%M%p" 2>/dev/null | sed 's/  / /g; s/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]' \
              || date -d "@$epoch" +"%b %-d, %l:%M%P" 2>/dev/null | sed 's/  / /g; s/^ //; s/\.//g'
            ;;
    esac
}

# Map wttr.in WMO weatherCode → emoji.
weather_icon() {
    case "$1" in
        113) echo "☀️" ;;
        116) echo "⛅" ;;
        119|122) echo "☁️" ;;
        143|248|260) echo "🌫️" ;;
        176|263|266|293|296|353) echo "🌦️" ;;
        179|182|185|281|284|311|314|317|350|362|365|374|377) echo "🌧️" ;;
        200|386|389) echo "⛈️" ;;
        227|230|320|323|326|329|332|335|338|368|371|392|395) echo "🌨️" ;;
        299|302|305|308|356|359) echo "🌧️" ;;
        *) echo "🌡️" ;;
    esac
}

# ── Terminal width detection ────────────────────────────────────
# Claude Code spawns this script with a controlling TTY, so /dev/tty works.
# The outer { ... } 2>/dev/null swallows the shell's own redirect error when
# /dev/tty isn't available (e.g. when piping in tests).
cols=$( { stty size </dev/tty | awk '{print $2}'; } 2>/dev/null )
[ -z "$cols" ] && cols="${COLUMNS:-80}"
[ "$cols" -lt 1 ] 2>/dev/null && cols=80

# Claude Code's renderer reserves some right-edge chrome; padding right up to
# `cols` causes truncation ("Hyderabad 12…") and can consume the row budget,
# eating subsequent lines. Reserve a buffer so we never write the rightmost
# few columns. Tune via $CLAUDE_STATUSLINE_RIGHT_MARGIN.
right_margin="${CLAUDE_STATUSLINE_RIGHT_MARGIN:-6}"
usable_cols=$(( cols - right_margin ))
[ "$usable_cols" -lt 20 ] && usable_cols=20

# ── Extract JSON ────────────────────────────────────────────────
model_name=$(echo "$input"   | jq -r '.model.display_name // "Claude"' 2>/dev/null)
used_pct=$(echo "$input"     | jq -r '.context_window.used_percentage // 0' 2>/dev/null)
cwd=$(echo "$input"          | jq -r '.workspace.current_dir // .cwd // ""' 2>/dev/null)
session_name=$(echo "$input" | jq -r '.session.name // empty' 2>/dev/null)
session_start=$(echo "$input"| jq -r '.session.start_time // empty' 2>/dev/null)

[ -z "$model_name" ] && model_name="Claude"
[[ "$used_pct" =~ ^[0-9]+$ ]] || used_pct=0

[ -z "$cwd" ] || [ "$cwd" = "null" ] && cwd=$(pwd)
dir_name=$(basename "$cwd")

# ── Git ─────────────────────────────────────────────────────────
branch=""
dirty_marker=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | head -1)" ]; then
            dirty_marker="${warn}*${reset}"
        fi
    fi
fi

# ── Session duration ────────────────────────────────────────────
session_duration=""
if [ -n "$session_start" ] && [ "$session_start" != "null" ]; then
    start_epoch=$(iso_to_epoch "$session_start")
    if [ -n "$start_epoch" ]; then
        now_epoch=$(date +%s)
        elapsed=$(( now_epoch - start_epoch ))
        [ "$elapsed" -lt 0 ] && elapsed=0
        if [ "$elapsed" -ge 3600 ]; then
            session_duration="$(( elapsed / 3600 ))h$(( (elapsed % 3600) / 60 ))m"
        elif [ "$elapsed" -ge 60 ]; then
            session_duration="$(( elapsed / 60 ))m"
        else
            session_duration="${elapsed}s"
        fi
    fi
fi

# ── Thinking flag ───────────────────────────────────────────────
thinking_on=false
settings_path="$HOME/.claude/settings.json"
if [ -f "$settings_path" ]; then
    thinking_val=$(jq -r '.alwaysThinkingEnabled // false' "$settings_path" 2>/dev/null)
    [ "$thinking_val" = "true" ] && thinking_on=true
fi

# ── Weather (cached 1h) ─────────────────────────────────────────
weather_cache="/tmp/claude/statusline-weather-cache.json"
weather_max_age=3600
mkdir -p /tmp/claude

weather_needs_refresh=true
weather_json=""
if [ -f "$weather_cache" ]; then
    wmtime=$(stat -f %m "$weather_cache" 2>/dev/null || stat -c %Y "$weather_cache" 2>/dev/null)
    wnow=$(date +%s)
    wage=$(( wnow - wmtime ))
    if [ "$wage" -lt "$weather_max_age" ]; then
        weather_needs_refresh=false
        weather_json=$(cat "$weather_cache" 2>/dev/null)
    fi
fi

if $weather_needs_refresh; then
    fresh=$(curl -s --max-time 3 'https://wttr.in/?format=j1' 2>/dev/null)
    if [ -n "$fresh" ] && echo "$fresh" | jq -e '.current_condition[0]' >/dev/null 2>&1; then
        weather_json="$fresh"
        echo "$fresh" > "$weather_cache"
    fi
    if [ -z "$weather_json" ] && [ -f "$weather_cache" ]; then
        weather_json=$(cat "$weather_cache" 2>/dev/null)
    fi
fi

weather_block=""
if [ -n "$weather_json" ] && echo "$weather_json" | jq -e '.current_condition[0]' >/dev/null 2>&1; then
    code=$(echo "$weather_json"      | jq -r '.current_condition[0].weatherCode // empty')
    tempF=$(echo "$weather_json"     | jq -r '.current_condition[0].temp_F // empty')
    tempC=$(echo "$weather_json"     | jq -r '.current_condition[0].temp_C // empty')
    city=$(echo "$weather_json"      | jq -r '.nearest_area[0].areaName[0].value // empty')
    obs_utc=$(echo "$weather_json"   | jq -r '.current_condition[0].observation_time // empty')
    obs_local=$(echo "$weather_json" | jq -r '.current_condition[0].localObsDateTime // empty')

    # Derive UTC offset from the (UTC, local) observation pair.
    city_time=""
    if [ -n "$obs_utc" ] && [ -n "$obs_local" ]; then
        obs_local_time="${obs_local#* }"   # strip "YYYY-MM-DD " prefix
        utc_min=$(parse_ampm_to_minutes "$obs_utc")
        local_min=$(parse_ampm_to_minutes "$obs_local_time")
        offset_min=$(( local_min - utc_min ))
        [ "$offset_min" -gt 720 ]   && offset_min=$(( offset_min - 1440 ))
        [ "$offset_min" -lt -720 ]  && offset_min=$(( offset_min + 1440 ))
        # POSIX TZ uses inverted sign: +5:30 east of UTC → TZ='UTC-5:30'.
        tz_sign='-'; abs_off=$offset_min
        [ "$abs_off" -lt 0 ] && { tz_sign='+'; abs_off=$(( -abs_off )); }
        tz_hh=$(( abs_off / 60 ))
        tz_mm=$(( abs_off % 60 ))
        city_time=$(TZ="UTC${tz_sign}${tz_hh}:$(printf '%02d' $tz_mm)" date +"%l:%M%p" \
                    | sed 's/^ //; s/\.//g' | tr '[:upper:]' '[:lower:]')
    fi

    if [ -n "$tempF" ] && [ -n "$tempC" ]; then
        icon=$(weather_icon "$code")
        weather_block="${info}${icon} ${tempF}°F ${dim}·${reset}${info} ${tempC}°C${reset}"
        if [ -n "$city" ]; then
            weather_block+="${sep}${white}${city}${reset}"
            [ -n "$city_time" ] && weather_block+=" ${dim}${reset}${white} ${city_time}${reset}"
        fi
    fi
fi

# ── Build line 1 with progressive drop ──────────────────────────
seg_model="${accent} ${model_name}${reset}"
pct_color=$(color_for_pct "$used_pct")
seg_pct="${dim}✍${reset} ${pct_color}${used_pct}%${reset}"
seg_dir="${white}${dir_name}${reset}"
seg_branch=""
[ -n "$branch" ] && seg_branch=" ${git_green} ${branch}${reset}"
seg_session=""
[ -n "$session_name" ] && [ "$session_name" != "null" ] && seg_session="${white}✎ ${session_name}${reset}"
seg_duration=""
[ -n "$session_duration" ] && seg_duration="${dim}${reset} ${white}${session_duration}${reset}"
if $thinking_on; then
    seg_thinking="${magenta}◐ thinking${reset}"
else
    seg_thinking="${dim}◑ thinking${reset}"
fi

# Left side only — weather is right-aligned separately below.
build_left() {
    local inc_session=$1 inc_duration=$2 inc_thinking=$3 inc_dirty=$4
    local out="${seg_model}${sep}${seg_pct}${sep}${seg_dir}"
    if [ -n "$seg_branch" ]; then
        out+="$seg_branch"
        [ "$inc_dirty" = "1" ] && [ -n "$dirty_marker" ] && out+="$dirty_marker"
    fi
    [ "$inc_session"  = "1" ] && [ -n "$seg_session"  ] && out+="${sep}${seg_session}"
    [ "$inc_duration" = "1" ] && [ -n "$seg_duration" ] && out+="${sep}${seg_duration}"
    [ "$inc_thinking" = "1" ] && out+="${sep}${seg_thinking}"
    printf "%s" "$out"
}

# Decide whether the weather block can fit at all.
# Drop the entire block first if even the minimal left + 1 gap + weather > usable_cols.
inc_weather=1
weather_visible=0
if [ -n "$weather_block" ]; then
    weather_visible=$(visible_len "$weather_block")
    left_min_visible=$(visible_len "$(build_left 0 0 0 0)")
    [ $(( left_min_visible + 1 + weather_visible )) -gt "$usable_cols" ] && inc_weather=0
fi

# Width budget for the left side
if [ "$inc_weather" = "1" ] && [ -n "$weather_block" ]; then
    left_budget=$(( usable_cols - weather_visible - 1 ))
else
    left_budget=$usable_cols
fi

# Progressive drop on the left in user's chosen order.
inc_session=1; inc_duration=1; inc_thinking=1; inc_dirty=1
left=$(build_left $inc_session $inc_duration $inc_thinking $inc_dirty)
for drop in session duration thinking dirty; do
    [ "$(visible_len "$left")" -le "$left_budget" ] && break
    case "$drop" in
        session)  inc_session=0 ;;
        duration) inc_duration=0 ;;
        thinking) inc_thinking=0 ;;
        dirty)    inc_dirty=0 ;;
    esac
    left=$(build_left $inc_session $inc_duration $inc_thinking $inc_dirty)
done

# Compose with right-aligned weather (or just left if weather dropped).
# Pad to usable_cols, NOT cols — leaves a buffer at the right edge so Claude
# Code's renderer doesn't ellipsize and (more importantly) so the line doesn't
# wrap into the row reserved for usage bars.
if [ "$inc_weather" = "1" ] && [ -n "$weather_block" ]; then
    left_visible=$(visible_len "$left")
    gap=$(( usable_cols - left_visible - weather_visible ))
    [ "$gap" -lt 1 ] && gap=1
    pad=$(printf '%*s' "$gap" '')
    line1="${left}${pad}${weather_block}"
else
    line1="$left"
fi

# ── OAuth token resolution ──────────────────────────────────────
get_oauth_token() {
    if [ -n "$CLAUDE_CODE_OAUTH_TOKEN" ]; then
        echo "$CLAUDE_CODE_OAUTH_TOKEN"; return 0
    fi
    local token=""
    if command -v security >/dev/null 2>&1; then
        local blob
        blob=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
        if [ -n "$blob" ]; then
            token=$(echo "$blob" | jq -r '.claudeAiOauth.accessToken // empty' 2>/dev/null)
            [ -n "$token" ] && [ "$token" != "null" ] && { echo "$token"; return 0; }
        fi
    fi
    local creds_file="${HOME}/.claude/.credentials.json"
    if [ -f "$creds_file" ]; then
        token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds_file" 2>/dev/null)
        [ -n "$token" ] && [ "$token" != "null" ] && { echo "$token"; return 0; }
    fi
    echo ""
}

# ── Usage data (cached 5m) ──────────────────────────────────────
cache_file="/tmp/claude/statusline-usage-cache.json"
cache_max_age=300

needs_refresh=true
usage_data=""
if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -f %m "$cache_file" 2>/dev/null || stat -c %Y "$cache_file" 2>/dev/null)
    now=$(date +%s)
    cache_age=$(( now - cache_mtime ))
    if [ "$cache_age" -lt "$cache_max_age" ]; then
        needs_refresh=false
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

if $needs_refresh; then
    token=$(get_oauth_token)
    if [ -n "$token" ] && [ "$token" != "null" ]; then
        response=$(curl -s --max-time 5 \
            -H "Accept: application/json" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $token" \
            -H "anthropic-beta: oauth-2025-04-20" \
            "https://api.anthropic.com/api/oauth/usage" 2>/dev/null)
        if [ -n "$response" ] && echo "$response" | jq -e '.five_hour' >/dev/null 2>&1; then
            usage_data="$response"
            echo "$response" > "$cache_file"
        fi
    fi
    if [ -z "$usage_data" ] && [ -f "$cache_file" ]; then
        usage_data=$(cat "$cache_file" 2>/dev/null)
    fi
fi

# ── Usage bar lines (skip on narrow terminals) ──────────────────
rate_lines=""
bar_width=10
if [ "$usable_cols" -ge 40 ] && [ -n "$usage_data" ] && echo "$usage_data" | jq -e . >/dev/null 2>&1; then
    five_hour_pct=$(echo "$usage_data"       | jq -r '.five_hour.utilization // 0' | awk '{printf "%.0f", $1}')
    five_hour_reset_iso=$(echo "$usage_data" | jq -r '.five_hour.resets_at // empty')
    five_hour_reset=$(format_reset_time "$five_hour_reset_iso" "time")
    five_hour_bar=$(build_bar "$five_hour_pct" "$bar_width")
    five_hour_pct_color=$(color_for_pct "$five_hour_pct")
    five_hour_pct_fmt=$(printf "%3d" "$five_hour_pct")

    rate_lines+="${white}current${reset} ${five_hour_bar} ${five_hour_pct_color}${five_hour_pct_fmt}%${reset}"
    [ -n "$five_hour_reset" ] && rate_lines+=" ${dim}⟳${reset} ${info}${five_hour_reset}${reset}"

    seven_day_pct=$(echo "$usage_data"       | jq -r '.seven_day.utilization // 0' | awk '{printf "%.0f", $1}')
    seven_day_reset_iso=$(echo "$usage_data" | jq -r '.seven_day.resets_at // empty')
    seven_day_reset=$(format_reset_time "$seven_day_reset_iso" "datetime")
    seven_day_bar=$(build_bar "$seven_day_pct" "$bar_width")
    seven_day_pct_color=$(color_for_pct "$seven_day_pct")
    seven_day_pct_fmt=$(printf "%3d" "$seven_day_pct")

    rate_lines+="\n${white}weekly${reset}  ${seven_day_bar} ${seven_day_pct_color}${seven_day_pct_fmt}%${reset}"
    [ -n "$seven_day_reset" ] && rate_lines+=" ${dim}⟳${reset} ${info}${seven_day_reset}${reset}"
fi

# ── Output ──────────────────────────────────────────────────────
printf "%b" "$line1"
[ -n "$rate_lines" ] && printf "\n%b" "$rate_lines"
exit 0
