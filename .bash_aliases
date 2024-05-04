alias shellevents="socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock  EXEC:'/home/edwin/.config/hypr/shellevents/shellevents /home/edwin/.config/hypr/shellevents/mpvwindows.sh',nofork"
alias reloadevent="killall shellevents -USR1"
alias aliasrc="nvim ~/.bash_aliases && source ~/.bash_aliases"
alias bashrc="nvim ~/.bashrc && source ~/.bashrc"
alias dus='du -h --max-depth=1 | sort -hr' # Disk Usage Sorted
alias rclone="rclone -P"
alias curl='curl -O'
alias df='df -h'

alias steam='gamescope -r 60 -o 24 -F fsr -e -- steamlx'
alias hdsteam='gamescope -h 1080 -e -- steamlx'
alias nocapsteam='gamescope -F fsr -e -- steamlx'

alias sortmusic='cd ~/Music/2015-2022 && stat --format="%W %n" * | sort -nr'
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
alias paclist='pacman -Qet'
alias pacinfo='pacman -Qi'
alias pacorphans='pacman -Qtd'
alias pacclean='sudo pacman -Sc'

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'

stage() {
    printf "First argument: yadm or git\nSecond argument: modified or deleted\n\n"
    $1 ls-files -z --$2 | xargs -0 $1 add  
}

dict() { 
    curl -s 'dict://dict.org/d:'"$@"'' | nvim +Man!
}

mpv() {
    nohup /usr/bin/mpv "$@" &>/dev/null & exit
}

fm()
{
    local dst="$(command vifm --choose-dir - "$@")"
    if [ -z "$dst" ]; then
        echo 'Directory picking cancelled/failed'
        return 1
    fi
    cd "$dst"
}
