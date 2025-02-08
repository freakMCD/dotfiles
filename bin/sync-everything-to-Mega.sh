#!/bin/bash

RCLONE_OPTS="--transfers 45 --checkers 65 -P"

cd ~

rclone $RCLONE_OPTS sync Documents mega:Documents
rclone $RCLONE_OPTS --exclude "/Movies/**" sync MediaHub mega:MediaHub
rclone $RCLONE_OPTS sync MathCareer mega:MathCareer
rclone $RCLONE_OPTS sync Music mega:Music
