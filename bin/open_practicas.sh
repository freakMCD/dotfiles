#!/bin/bash

# Run fzf to select a file
selected_file=$(fzf --query="2dociclopracticas" --height=-1)

# Open the selected file using nohup and redirect output to nohup.out
nohup xdg-open "$selected_file" >/dev/null 2>&1 &
sleep 0.2
# Close the terminal
exit
