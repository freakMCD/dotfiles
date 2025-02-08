#!/bin/sh
# wrap.sh
# usage: wrap.sh <program + args>

BIN=$1
export HOME="${HOME}/opt/$(basename "$BIN")"
[ -d "$HOME" ] || mkdir -p "$HOME"
# run
${BIN}
