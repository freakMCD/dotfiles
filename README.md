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

    $ cat /etc/systemd/system/getty@tty1.service.d/override.conf
    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin edwin --noclear %I $TERM

## Tuning**

**Storage Devices**

    - Disable coredump (See https://wiki.archlinux.org/title/Core_dump#Disabling_automatic_core_dumps)
    - Set "noatime,commit=60" in /etc/fstab (ext4 options)

**Gaming**

    - Add "vm.max_map_count=1048576" -> /etc/sysctl.d/80-gamecompatibility.conf
    - Add "tsc=reliable clocksource=tsc" -> GRUB_CMDLINE_LINUX_DEFAULT= -> /etc/default/grub

<details><summary>
<h2>Notes</h2>
</summary>
## Git and yadm examples

- *Sets the URL to push commits to the specified remote repository.*:
  `git remote set-url --push origin https://github.com/freakMCD/<reponame>.git`
  
- *Deletes the last commit from the remote repository while keeping it locally.*:
  `git push origin +HEAD^:main`

- *Undoes the last commit, keeping the changes staged for commit.*:
  `git reset --soft HEAD@{1}`

- *Commits all changes in the repository.*:
  `yadm add -u`

- *Untracks a specified file in the repository.*:
  `yadm rm --cached <filename>`

- *Marks a file as assumed unchanged, useful for files that will not be edited.*:
  `yadm update-index --assume-unchanged <filepath>`

- *Initializes a yadm repository in the current directory.*:
  `yadm init
  yadm remote add origin <url>
  yadm fetch
  yadm reset origin/master`

- *Deletes the build folder and test.txt file from all commits in the repository.*:
  `git filter-repo --path build/ --path test.txt --invert-paths`# Other

## Other
- *To change Drive permissions to username*
  `sudo chown -v username:username /media/username/disk-name`

-  *pass*
  `PASSWORD_STORE_GPG_OPTS='--pinentry-mode=loopback --passphrase <passphrase>'`
    
-  *Systemd*
  `systemctl --user mask/unmask <service-name>`

</details>

# vim: set nowrap :
