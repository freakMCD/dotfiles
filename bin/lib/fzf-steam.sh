#!/usr/bin/env bash

# Credits to: https://github.com/gennarocc/fzf-steam
# Generates .desktop entries for all installed Steam games with box art for
# the icons to be used with a specifically configured Rofi launcher


if [[ "$1" == "update" ]]; then

# Change to your steam library
STEAM_ROOT=$HOME/.local/share/Steam/steamapps
APP_PATH=$HOME/.local/share/applications/steam

# Fetch all Steam library folders.
steam-libraries() {
    echo "$STEAM_ROOT"

    # Additional library folders are recorded in libraryfolders.vdf
    libraryfolders=~$STEAM_ROOT/steamapps/libraryfolders.vdf
    if [ -e "$libraryfolders" ]; then
        ec
        awk -F\" '/^[[:space:]]*"[[:digit:]]+"/ {print $4}' "$libraryfolders"
    fi
}

# Generate the contents of a .desktop file for a Steam game.
# Expects appid, title, and box art file to be given as arguments
env-entry() {
cat << EOF
GAME_ID="$1"
GAME_NAME="$2"
EOF
}
	mkdir -p "$APP_PATH"
	for library in $(steam-libraries); do
	    # All installed Steam games correspond with an appmanifest_<appid>.acf file
	    for manifest in "$library"/appmanifest_*.acf; do
	        appid=$(basename "$manifest" | tr -dc "[0-9]")
	        title=$(awk -F\" '/"name"/ {print $4}' "$manifest" | tr -d "™®")
	        entry=$APP_PATH/${title}.env
	        # Filter out non-game entries (e.g. Proton versions or soundtracks) by
	        # checking for boxart and other criteria
	        if echo "$title" | grep -qe 'Soundtrack\|Proton\|Runtime\|Steamworks'; then
	            continue
	        fi
	
	        env-entry "$appid" "$title"> "$entry"
	    done
	done
fi

cd ~/.local/share/applications/steam && eval $(cat "$(ls -1 | sed -e 's/\.env$//' | fzf ).env")

if [[ "$GAME_ID" != "" ]]; then
    setsid /bin/sh -c "steamlx steam://rungameid/$GAME_ID" &>/dev/null &
    sleep 0.01
fi
