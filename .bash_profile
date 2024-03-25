# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:$HOME/bin/lib:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$HOME/bin/lib:$PATH"
fi
export PATH

set -a
    source ~/.local/share/linuxfedora
    XDG_CONFIG_HOME="$HOME/.config"
    XDG_CACHE_HOME="$HOME/.cache"
    XDG_DATA_HOME="$HOME/.local/share"
    XDG_STATE_HOME="$HOME/.local/state"
    CARGO_HOME="$HOME/.local/share/.cargo/"

    EDITOR='nvim'
    VISUAL='nvim'
    MANPAGER='nvim +Man!'
    BROWSER="qutebrowser"

    PASSWORD_STORE_DIR="/home/edwin/.PrivateHub/password-store/"
    GNUPGHOME="$XDG_DATA_HOME/gnupg"
    TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
    WINEPREFIX="/media/data/.wine"
    TMOUT=300
    XKB_DEFAULT_LAYOUT=es # For steam with gamescope
set +a

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  exec Hyprland
fi
