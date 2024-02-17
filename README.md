dotfiles
========

Overview
--------
This repository contains my dotfiles and system configuration. Below is a summary of what's included.

* **WM**: Hyprland
* **StatusBar** : Waybar
* **Terminal**: foot
* **Notifications**: Dunst
* **Launcher**: fzf
* **File Manager**: yazi
* **Text Editor**: neovim
* **Music player** ncmpcpp + mpd + mpc
* **Image Viewer** : feh
* **PDF Reader**: Zathura
* **RSS Reader**: Newsraft
* **Email Client**: Neomutt + Isync + msmtp
* **Screen capture**: grim + slurp + wf-recorder

## System Configuration
```bash
# Replace line in /etc/systemd/journald.conf
SystemMaxUse=50M

# Replace line in /etc/systemd/logind.conf 
HandlePowerKey=ignore

# Replace line in /etc/default/grub
# Fix Risk of Rain 2 slow load
GRUB_CMDLINE_LINUX="rhgb quiet clocksource=tsc tsc=reliable"
```

## Guide Installation (after Fedora Everything minimal install)

**1. Disable weak dependancies**
```bash
#Add lines in /etc/dnf/dnf.conf
install_weak_deps=false 
max_parallel_downloads=10 
```
**2. Install essential packages**
```bash
sudo dnf install hyprland xdg-portal-desktop-hyprland waybar dunst git qutebrowser 

## Run this first to save git credentials ##
git config --global credential.helper "store --file ~/.local/share/git-credentials"

# Install yadm
mkdir -p ~/.local/bin
curl -fLo ~/.local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm && chmod a+x ~/.local/bin/yadm
yadm clone https://github.com/freakMCD/dotfiles.git 
```
**3. Run 'yadm bootstrap' to install the rest**

<details><summary>
<h2>Notes</h2>
</summary>

**git and yadm examples**
```bash
# Set url to push commits
git remote set-url --push origin https://github.com/freakMCD/<reponame>.git

# Delete last commit from remote repo but keep it locally
git push origin +HEAD^:main

# Undo last commit
git reset --soft HEAD@{1}

# To commit all changes**
yadm add -u

# To untrack a file
yadm rm --cached <filename>

# For files you will never edit (e.g. "LICENSE")
yadm update-index --assume-unchanged <filepath>

# When you have local repo but lost refs from remote repo
yadm init
yadm remote add origin <url>
yadm fetch
yadm reset origin/master

# Delete build folder and test.txt file from all commits
$ git filter-repo --path build/ --path test.txt  --invert-paths
```
**Other**
```bash
# To change Drive permissions to username
sudo chown -v username:username /media/username/disk-name

# pass
PASSWORD_STORE_GPG_OPTS='--pinentry-mode=loopback --passphrase <passphrase>'
    
# nmcli
nmcli dev status
nmcli dev connect/disconnect <device>

# Newsraft Build - Instructions
git clone https://codeberg.org/grisha/newsraft.git
sudo dnf install gumbo-parser-devel yajl-devel expat-devel ncurses-devel sqlite-devel curl-devel

# PulseAudio Control (pactl) 
pactl list sinks # It list the sinks beggining with "SINK #INDEX"
pactl set-default-source <INDEX> # for example "pactl set-default-source 52"
```
</details>
