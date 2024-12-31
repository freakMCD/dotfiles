#!/bin/bash
cd ~
rclone -P sync Documents mega:Documents
rclone -P sync MediaHub mega:MediaHub
rclone -P sync MathCareer mega:MathCareer

