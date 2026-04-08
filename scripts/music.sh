#!/usr/bin/env bash

CHOICE=$(mpc ls | fuzzel --dmenu --prompt "Music: ")

[ -z "$CHOICE" ] && exit

mpc clear
mpc add "$CHOICE"
mpc random on
mpc play
