#!/usr/bin/env bash
# ~/nix/scripts/status.sh
# Prettified status popup — NO truncation of MPV titles.

# CONFIG
FUZZEL_WIDTH=50

# Gather info
time="$(date '+%H:%M  %d %b %Y')"
ram="$(free -g | awk '/Mem:/ {printf "%d/%d", $3, $2}')"
cpu="$(awk '/^cpu / {u=($2+$4)*100/($2+$4+$5); printf("%.1f%%", u)}' /proc/stat)"
song="$(playerctl metadata --format '{{artist}} - {{title}}' 2>/dev/null || echo 'No music')"

# --- MPV windows ---
mpvs=""
if [ -s /tmp/mpv_titles ] && [ -s /tmp/mpv_states ]; then
  mapfile -t _titles < /tmp/mpv_titles
  mapfile -t _states < /tmp/mpv_states

  for i in "${!_titles[@]}"; do
    title="${_titles[i]}"
    # skip if empty or only whitespace
    [[ -z "${title// }" ]] && continue

    idx=$((i+1))
    state="${_states[i]:-unknown}"

    case "$state" in
      playing) icon="▶" ;;
      paused)  icon="⏸" ;;
      *)       icon="?" ;;
    esac

    printf -v line "%2d. %-40s  %s" "$idx" "$title" "$icon"
    mpvs+=$'\n'"$line"
  done
fi

# only build MPV section if non-empty
if [ -n "$mpvs" ]; then
  mpv_section="$mpvs"
else
  mpv_section=""
fi

output=$(
cat <<EOF
🧠 $ram    🔥 $cpu

🎵 $song

$mpv_section
EOF
)

# Count lines for fuzzel (auto-fit)
lines=$(printf "%s\n" "$output" | wc -l)
[ "$lines" -lt 3 ] && lines=3

printf "%s\n" "$output" | fuzzel --dmenu \
  --width="$FUZZEL_WIDTH" \
  --lines="$lines" \
  --font="monospace:size=12" \
  --prompt="$time " \
  --prompt-color=fabd2fff \
  --background=121212ff \
  --text-color=ebdbb2ff \
  --selection-color=aaaaaa00 \
  --selection-text-color=ebdbb2ff \
  --border-width=1 \
  --border-radius=10 \
  --border-color=3c3836ff \
  --horizontal-pad=20 \
  --vertical-pad=12 \
  --layer=overlay

