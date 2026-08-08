#!/bin/bash
set -f
# Claude Code statusLine — starship-themed, single line, width-aware.
#  opus-4-7·high │ ✍ 76% │ workspace  main* │ ✎ session │  12m │ ◇ concise │ ◐ thinking   ⛅ 86°F · 30°C │ Austin │  3:14pm
#
# Drops segments in this order on narrow terminals:
#   weather → session name → duration → style/effort → thinking → git dirty marker

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

# ── Thinking flag, output style, effort ─────────────────────────
# Output style can change mid-session, so prefer the stdin payload and fall back
# to settings.json. Effort level isn't in the payload — settings.json only.
thinking_on=false
output_style=$(echo "$input" | jq -r '.output_style.name // empty' 2>/dev/null)
effort=""
settings_path="$HOME/.claude/settings.json"
if [ -f "$settings_path" ]; then
    # IFS=tab, not the default — style names may contain spaces.
    IFS=$'\t' read -r thinking_val settings_style effort <<<"$(jq -r '[(.alwaysThinkingEnabled // false), (.outputStyle // "-"), (.effortLevel // "-")] | @tsv' "$settings_path" 2>/dev/null)"
    [ "$thinking_val" = "true" ] && thinking_on=true
    [ -z "$output_style" ] && [ "$settings_style" != "-" ] && output_style="$settings_style"
    [ "$effort" = "-" ] && effort=""
    effort=$(printf "%s" "$effort" | tr '[:upper:]' '[:lower:]')
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
    # Refresh OUT OF BAND. A foreground fetch costs ~1s (ceiling 3s) and the
    # statusline renders synchronously, so a stale cache used to stall the first
    # render of every session started >1h after the last one. Instead: render
    # from the stale cache now, and let a detached child replace it for the next
    # render. First run ever shows no weather; it appears a render later.
    #
    # The attempt stamp throttles retries to once a minute — without it a failing
    # fetch would spawn a new curl on every single render.
    weather_stamp="/tmp/claude/statusline-weather-attempt"
    attempt_ok=true
    if [ -f "$weather_stamp" ]; then
        smtime=$(stat -f %m "$weather_stamp" 2>/dev/null || stat -c %Y "$weather_stamp" 2>/dev/null)
        [ -n "$smtime" ] && [ $(( $(date +%s) - smtime )) -lt 60 ] && attempt_ok=false
    fi
    if $attempt_ok; then
        : > "$weather_stamp"
        # Write to a PID-scoped temp and mv into place, so a concurrent render
        # never reads a half-written cache file.
        (
            tmp="${weather_cache}.$$.tmp"
            if curl -s --max-time 10 'https://wttr.in/?format=j1' > "$tmp" 2>/dev/null \
               && jq -e '.current_condition[0]' "$tmp" >/dev/null 2>&1; then
                mv -f "$tmp" "$weather_cache"
            else
                rm -f "$tmp"
            fi
        ) >/dev/null 2>&1 &
        disown 2>/dev/null || true
    fi
    # Render from the stale cache if we have one.
    [ -f "$weather_cache" ] && weather_json=$(cat "$weather_cache" 2>/dev/null)
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
[ -n "$effort" ] && seg_model+="${dim}·${reset}${accent}${effort}${reset}"
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
seg_style=""
style_txt=$(printf "%s" "$output_style" | tr '[:upper:]' '[:lower:]')
[ -n "$style_txt" ] && seg_style="${info}◇ ${style_txt}${reset}"

# Left side only — weather is right-aligned separately below.
build_left() {
    local inc_session=$1 inc_duration=$2 inc_style=$3 inc_thinking=$4 inc_dirty=$5
    local out="${seg_model}${sep}${seg_pct}${sep}${seg_dir}"
    if [ -n "$seg_branch" ]; then
        out+="$seg_branch"
        [ "$inc_dirty" = "1" ] && [ -n "$dirty_marker" ] && out+="$dirty_marker"
    fi
    [ "$inc_session"  = "1" ] && [ -n "$seg_session"  ] && out+="${sep}${seg_session}"
    [ "$inc_duration" = "1" ] && [ -n "$seg_duration" ] && out+="${sep}${seg_duration}"
    [ "$inc_style"    = "1" ] && [ -n "$seg_style"    ] && out+="${sep}${seg_style}"
    [ "$inc_thinking" = "1" ] && out+="${sep}${seg_thinking}"
    printf "%s" "$out"
}

# Decide whether the weather block can fit at all.
# Drop the entire block first if even the minimal left + 1 gap + weather > usable_cols.
inc_weather=1
weather_visible=0
if [ -n "$weather_block" ]; then
    weather_visible=$(visible_len "$weather_block")
    left_min_visible=$(visible_len "$(build_left 0 0 0 0 0)")
    [ $(( left_min_visible + 1 + weather_visible )) -gt "$usable_cols" ] && inc_weather=0
fi

# Width budget for the left side
if [ "$inc_weather" = "1" ] && [ -n "$weather_block" ]; then
    left_budget=$(( usable_cols - weather_visible - 1 ))
else
    left_budget=$usable_cols
fi

# Progressive drop on the left in user's chosen order.
inc_session=1; inc_duration=1; inc_style=1; inc_thinking=1; inc_dirty=1
left=$(build_left $inc_session $inc_duration $inc_style $inc_thinking $inc_dirty)
for drop in session duration style thinking dirty; do
    [ "$(visible_len "$left")" -le "$left_budget" ] && break
    case "$drop" in
        session)  inc_session=0 ;;
        duration) inc_duration=0 ;;
        style)    inc_style=0 ;;
        thinking) inc_thinking=0 ;;
        dirty)    inc_dirty=0 ;;
    esac
    left=$(build_left $inc_session $inc_duration $inc_style $inc_thinking $inc_dirty)
done

# Compose with right-aligned weather (or just left if weather dropped).
# Pad to usable_cols, NOT cols — leaves a buffer at the right edge so Claude
# Code's renderer doesn't ellipsize and the line doesn't wrap onto a second row.
if [ "$inc_weather" = "1" ] && [ -n "$weather_block" ]; then
    left_visible=$(visible_len "$left")
    gap=$(( usable_cols - left_visible - weather_visible ))
    [ "$gap" -lt 1 ] && gap=1
    pad=$(printf '%*s' "$gap" '')
    line1="${left}${pad}${weather_block}"
else
    line1="$left"
fi

# ── Output ──────────────────────────────────────────────────────
printf "%b" "$line1"
exit 0
