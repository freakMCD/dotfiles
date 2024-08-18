#!/bin/bash
cd ~
rclone -P sync 1erCICLO mega:1erCICLO
rclone -P sync Documents mega:Documents
rclone -P sync MediaHub mega:MediaHub

