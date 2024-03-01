dotfiles
========

Overview
--------
This repository contains my dotfiles and system configuration. Below is a summary of what's included.

* **WM**: Hyprland
* **StatusBar** : Yambar
* **Terminal**: foot
* **Notifications**: fnott
* **Launcher**: fzf
* **File Manager**: vifm
* **Text Editor**: neovim
* **Music player** ncmpcpp + mpd + mpc
* **Image Viewer** : feh
* **PDF Reader**: Zathura
* **RSS Reader**: Newsraft
* **Email Client**: Neomutt + Isync + msmtp
* **Screen capture**: grim + slurp + wf-recorder


## Guide Installation (after Arch Installation Guide)

**1. Install essential packages**
```bash
# Configures Git to globally store authentication credentials
git config --global credential.helper "store --file ~/.local/share/git-credentials"

# Install yadm
sudo pacman -Syu yadm
cd ~
yadm clone https://github.com/freakMCD/dotfiles.git 

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay hyprland-git yambar-wayland
sudo pacman -S libnotify fnott foot vifm qt6-wayland qutebrowser python-adblock
```
**2. Restart, and run 'yadm bootstrap' to install the rest**

**Keybindings are in ~/.config/hypr/hyprland.conf 

## Autologin

**Create a drop-in file (Edit it with your username)**

    $ cat /etc/systemd/system/serial-getty@ttyS0.service.d/override.conf
    [Service]
    ExecStart=
    ExecStart=-/sbin/agetty -o '-p -f -- \\u' --keep-baud --autologin username 115200,57600,38400,9600 - $TERM

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

# PulseAudio Control (pactl) 
pactl list sinks # It list the sinks beggining with "SINK #INDEX"
pactl set-default-source <INDEX> # for example "pactl set-default-source 52"

# Systemd
systemctl --user mask/unmask <service-name>
```
</details>

# vim: set nowrap :
