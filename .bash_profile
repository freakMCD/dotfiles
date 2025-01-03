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

    if [ ! -d "$XDG_STATE_HOME/bash" ]; then
      mkdir -p "$XDG_STATE_HOME/bash"
    fi

    W3M_DIR="$XDG_STATE_HOME/w3m"
    HISTFILE="$XDG_STATE_HOME/bash/history"

    CARGO_HOME="$HOME/.local/share/.cargo/"

    EDITOR='nvim'
    VISUAL='nvim'
    MANPAGER='nvim +Man!'

    PASSWORD_STORE_DIR="/home/edwin/.PrivateHub/password-store/"
    GNUPGHOME="$XDG_DATA_HOME/gnupg"
    TEXMFVAR="$XDG_CACHE_HOME/texlive/texmf-var"
    WINEPREFIX="/media/data/.wine"
    TMOUT=300
    _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
set +a

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
  echo "Press 's' within 2 seconds to skip launching Hyprland and go to the TTY."
  read -t 2 -n 1 key
  if [ "${key}" = "s" ]; then
    echo "Skipping Hyprland launch. You are now in the TTY."
  else
    exec Hyprland
  fi
fi

