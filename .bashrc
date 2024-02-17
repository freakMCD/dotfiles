if [ -e "$HOME/.bash_aliases" ]; then
    source "$HOME/.bash_aliases"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -a
HISTFILE="$XDG_STATE_HOME/bash/history"
HISTCONTROL=ignoreboth
LESSHISTFILE='-'
PS1='\[\e[0;3;90m\][\[\e[0;3;31m\]\u \[\e[0;1;95m\]\W\[\e[0;3;90m\]] \[\e[0m\]'
PS4='Line ${LINENO}: '
set +a

mem() { 
    ps -eo rss,pid,euser,args:100 --sort %mem | grep -v grep | grep -i $@ | awk '{printf $1/1024 "MB"; $1=""; print }'
}

### FZF ###
if [ -x "$(command -v fzf)" ]; then
	source /usr/share/fzf/shell/key-bindings.bash
	source /usr/share/fzf/shell/completion.bash
    fdExclude="-E '{*[Cc]ache,*.git,.local,r2modman*}'"
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

