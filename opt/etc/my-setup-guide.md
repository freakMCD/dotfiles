# My Setup Guide (after Arch Install)

**1. Install essential packages**
```bash
# Configures Git to globally store authentication credentials
sudo pacman -Syu git
touch ~/.config/git/config
git config --global credential.helper "store --file ~/.config/git/git-credentials"

# Install yadm
sudo pacman -Syu yadm
cd ~
yadm clone https://github.com/freakMCD/dotfiles.git 

sudo pacman -S --needed base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
yay hyprland-git yambar-wayland
sudo pacman -S libnotify fnott foot vifm qt6-wayland qutebrowser python-adblock
```
**2. Restart, and run 'yadm bootstrap' to install the rest**

**Keybindings are in ~/.config/hypr/hyprland.conf**

## Autologin

**Create a drop-in file (Edit it with your username)**

    $ cat /etc/systemd/system/getty@tty1.service.d/override.conf
    [Service]
    ExecStart=
    ExecStart=-/usr/bin/agetty --autologin edwin --noclear %I $TERM

## Tuning

**Storage Devices**

    - Disable coredump (See https://wiki.archlinux.org/title/Core_dump#Disabling_automatic_core_dumps)
    - Set "noatime,commit=60" in /etc/fstab (ext4 options)

**Gaming**

    - Add "tsc=reliable clocksource=tsc" -> GRUB_CMDLINE_LINUX_DEFAULT= -> /etc/default/grub

**Puddletag**

    - run 'qt5ct' to customize theme
    
## Unclutter .config

**pulse**

    Edit cookie-file in /etc/pulse/client.conf
    > cookie-file = /tmp/pulse-cookie

# vim: set nowrap :
