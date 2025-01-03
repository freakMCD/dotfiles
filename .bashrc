if [ -e "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -a
HISTCONTROL=ignoreboth
LESSHISTFILE='-'

PS1='\[\e[38;2;102;92;84m\][\[\e[38;2;251;73;52m\]\u \[\e[38;2;184;187;38m\]\W\[\e[38;2;102;92;84m\]] \[\e[0m\]'
PS4='Line ${LINENO}: '
set +a

mem() { 
    ps -eo euser,rss,args --sort %mem | \
    grep -v grep | grep -i $@ | \
    awk 'BEGIN { printf "\033[1;34m%-10s %-10s %s\033[0m\n", "EUSER", "RSS(MB)", "COMMAND" }
         {rss=sprintf("%.2f", $2/1024); printf "%-10s %-10s %.80s\n", $1, rss, substr($0, index($0,$3))}'
}

### FZF ###
if [ -x "$(command -v fzf)" ]; then
    source /usr/share/fzf/key-bindings.bash
    source /usr/share/fzf/completion.bash
    fdExclude="-E '{*[Cc]ache,*.git,.local,opt,auxfiles}'"
    export FZF_DEFAULT_COMMAND="fd -t f -H -L "$fdExclude""
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd -t d -H -L "$fdExclude""
    export FZF_DEFAULT_OPTS="--height 60% --reverse \
    --color=bg+:#32302f,spinner:#e2d3ba,hl:#ef938e \
    --color=fg:#e2d3ba,header:#ef938e,info:#e1acbb,pointer:#e2d3ba \
    --color=marker:#e2d3ba,fg+:#e2d3ba,prompt:#e1acbb,hl+:#ef938e"
	
	# nvim ** 
	_fzf_compgen_path() {
        eval $FZF_DEFAULT_COMMAND . "$HOME"
	}
	# cd **
	_fzf_compgen_dir() {
        eval $FZF_ALT_C_COMMAND . "$HOME"
    }
	
	# fe [FUZZY PATTERN] - Open the selected file with the default editor
	#   - Bypass fuzzy finder if there's only one match (--select-1)
	#   - Exit if there's no match (--exit-0)
	fe() {
	  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
	  [[ -n "$files" ]] && $EDITOR "${files[@]}"
	}

	fman() {
	    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
	}

    fmpc() {
	  local song_position
	  song_position=$(mpc -f "%position%) %artist% - %title%" playlist | \
	    fzf --query="$1" --reverse --select-1 --exit-0 | \
	    sed -n 's/^\([0-9]\+\)).*/\1/p') || return 1
	  [ -n "$song_position" ] && mpc -q play $song_position
	}
fi


# Options for fzf alias selection
FZF_ALIAS_OPTS=${FZF_ALIAS_OPTS:-"--preview-window up:3:hidden:wrap"}

# Function to select an alias and insert it into the command line
fzf_alias() {
    local selection
    # Use sed with column to display aliases in a formatted way
    if selection=$(alias |
                       sed 's/alias \([^=]*\)=\(.*\)/\1\t\2/' |
                       column -t -s $'\t' |
                       FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_ALIAS_OPTS" fzf --preview "echo {2..}" --query="$READLINE_LINE" |
                       awk '{ print $1 }'); then
        # Insert the selected alias into the command line
        READLINE_LINE="$selection"
        READLINE_POINT=${#READLINE_LINE}
        # Refresh the command line manually
        reset
    fi
}

# Bind the fzf_alias function to a key combination (e.g., Ctrl-a)
bind -x '"\C-a": fzf_alias'
