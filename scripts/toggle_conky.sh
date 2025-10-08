#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.config/conky/extended.conf"
PIDFILE="$HOME/.cache/conky_extended.pid"

# ensure cache dir exists
mkdir -p "$(dirname "$PIDFILE")"

# find conky binary
CONKY_BIN="$(command -v conky || true)"
if [ -z "$CONKY_BIN" ]; then
  echo "conky not found in PATH" >&2
  exit 1
fi

# if pidfile exists and process is alive & matches our config -> kill it
if [ -f "$PIDFILE" ]; then
  pid="$(cat "$PIDFILE" 2>/dev/null || true)"
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
    if grep -qF "$CONFIG" /proc/"$pid"/cmdline 2>/dev/null; then
      kill "$pid" && rm -f "$PIDFILE"
      exit 0
    else
      # stale or mismatch
      rm -f "$PIDFILE"
    fi
  else
    rm -f "$PIDFILE"
  fi
fi

# start conky and record pid
"$CONKY_BIN" -c "$CONFIG" &>/dev/null &
echo $! > "$PIDFILE"
