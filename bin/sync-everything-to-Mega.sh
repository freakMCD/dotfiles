#!/bin/bash
cd ~
rclone -P sync 2doCiclo mega:2doCiclo
rclone -P sync Documents mega:Documents
rclone -P sync MediaHub mega:MediaHub
rclone -P sync MathCareer mega:MathCareer

