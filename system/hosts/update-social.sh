
#!/usr/bin/env bash
set -e

OUT=~/nix/system/hosts/social/hosts
URL=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social-only/hosts

echo "Downloading StevenBlack social list…"
curl -fsSL "$URL" > "$OUT.tmp"

echo "Removing the ‘# Whatsapp’ and ‘# Twitch’ sections…"
awk '
  # When we hit a removal header, start skipping and record its line number
  /^# *Whatsapp/ { skip=1; last_hdr=NR; next }

  # On any header while skipping:
  /^# / {
    if (skip) {
      # If it’s immediately adjacent to the last header, swallow it too
      if (NR == last_hdr + 1) {
        last_hdr = NR
        next
      }
      # Otherwise it’s the real next section—stop skipping
      skip = 0
    }
  }

  # Print only when not in skip mode
  !skip
' "$OUT.tmp" > "$OUT"

rm "$OUT.tmp"
echo "Done! Refreshed hosts at $OUT"

