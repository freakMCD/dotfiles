#!/bin/sh

# Check if a file argument is provided
if [ -z "$1" ]; then
    echo "No file provided. Usage: $0 <file>"
    exit 1
fi

# Determine the MIME type of the file
FILETYPE=$(xdg-mime query filetype "$1")
if [ -z "$FILETYPE" ]; then
    echo "Could not determine file type for $1"
    exit 1
fi

# Use fzf to select the default application
APP=$(find -L /usr/share -type f -name "*.desktop"| fzf --prompt="Select default app: ")

# Check if an application was selected
if [ -z "$APP" ]; then
    echo "No application selected"
    exit 1
fi

# Extract the basename of the selected .desktop file
APP=$(basename "$APP")

# Set the selected application as the default for the file type
xdg-mime default "$APP" "$FILETYPE"

# Confirm the change
echo "$APP set as default application to open $FILETYPE"
