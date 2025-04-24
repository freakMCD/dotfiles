
#!/usr/bin/env bash

# Define your playlists (multi can be comma-separated)
playlists=(
  "Ethereal"
  "The Hall,Vault"
)

state_file="${XDG_CACHE_HOME:-$HOME/.cache}/current_playlist_index"

# Read current index or default to -1
if [[ -f "$state_file" ]]; then
  index=$(<"$state_file")
else
  index=-1
fi

# Determine direction
direction="next"
[[ "$1" == "--prev" ]] && direction="prev"

# Update index
if [[ "$direction" == "next" ]]; then
  ((index=(index+1)%${#playlists[@]}))
else
  ((index=(index-1+${#playlists[@]})%${#playlists[@]}))
fi

# Save new index
echo "$index" > "$state_file"

# Clear playlist
mpc clear

# Add each playlist (split on comma)
IFS=',' read -ra current <<< "${playlists[$index]}"
for pl in "${current[@]}"; do
  mpc add "$pl"
done

mpc play
