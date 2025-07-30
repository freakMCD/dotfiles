#!/usr/bin/env bash
set -e

OUT=~/nix/system/hosts/social/hosts
URL=https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social-only/hosts

echo "Downloading StevenBlack social list…"
curl -fsSL $URL > $OUT.tmp

echo "Removing the ‘# Whatsapp’ section…"
awk '
  # When we see "# Whatsapp", start skipping
  /^# *Whatsapp/ { skipping=1; next }
  # If we hit any other header (line starting with "# ") and we were skipping, stop skipping
  /^# / && skipping { skipping=0 }
  # Print lines only when not skipping
  !skipping
' $OUT.tmp > $OUT

rm $OUT.tmp
echo "Done! Refreshed hosts at $OUT"

