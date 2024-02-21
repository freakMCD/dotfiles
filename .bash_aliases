alias aliasrc="nvim ~/.bash_aliases && source ~/.bash_aliases"
alias bashrc="nvim ~/.bashrc && source ~/.bashrc"
alias dus='du -h --max-depth=1 | sort -hr' # Disk Usage Sorted
alias rclone="rclone -P"
alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'
alias df='df -h'

alias mymusic='mpv --shuffle --volume=67 --save-position-on-quit=no "https://www.youtube.com/playlist?list=PL4CmunqMOJjLhWvgQUXWvewHEOoPAVAkt"'
alias mp3dl='yt-dlp --restrict-filenames --extract-audio --audio-format mp3 --no-playlist'
alias litedlp="yt-dlp -f 'bestvideo[height<=720]+bestaudio/best'"

# gpg aliases
alias gpg-list="gpg --list-secret-keys --keyid-format LONG"
alias gpg-backup="gpg -o private.gpg --export-options backup --export-secret-keys"
alias gpg-restore="gpg --import-options restore --import private.gpg"

# Custom dnf alias
alias pacu='sudo pacman -Syu' # Update the system
alias paci='sudo pacman -S'
alias pacr='sudo pacman -Rs'
alias pacs='sudo pacman -Ss'
alias paclist='pacman -Q'
alias pacinfo='pacman -Qi'
alias pacorphans='pacman -Qtd'
alias pacclean='sudo pacman -Sc'

alias update-grub='sudo grub2-mkconfig -o /boot/grub2/grub.cfg'

stage () {
    printf "First argument: yadm or git\nSecond argument: modified or deleted\n\n"
    $1 ls-files -z --$2 | xargs -0 $1 add  
}

dict () { 
    curl -s 'dict://dict.org/d:'"$@"'' | nvim +Man!
}

mpv() {
    nohup /usr/bin/mpv --force-window=yes "$@" &>/dev/null & exit
}

function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
