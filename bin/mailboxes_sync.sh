# Script from: https://github.com/jpmenil/dotfiles/blob/master/bin/mailboxes_sync.sh

[ ! -r ~/.mbsyncrc ] && exit 0

# Download new mail
if ps -C mbsync > /dev/null; then
    exit 0
fi

mbsync gmail
prefix="${HOME}/.local/share/email/gmail"

for file in "$prefix"/*; do
    # Only for specified mailboxes
    folder="${file#"$prefix"/}"
    if [[ "$folder" =~ (INBOX|Github|Interbank) ]]; then
        # Find all unread mail whose file is newer that the last time this script was run and count them
        newcount=$(find "$file"/new -type f -newer ~/.config/neomutt/.mailsynclast 2> /dev/null | wc -l)
        # Send notification if there are new mail
        if [ "$newcount" -gt "0" ]; then
            for newemail in "$file"/new/*; do
                sender=$(sed -n '/^From: /s/^From: //p' "$newemail" \
                        | perl -pe 'use MIME::EncWords(decode_mimewords); $_=decode_mimewords($_);')
                subject=$(sed -n '/^Subject: /s/^Subject: //p' "$newemail" \
                        | perl -pe 'use MIME::EncWords(decode_mimewords); $_=decode_mimewords($_);')
                notify-send -t 30000 "$sender" "$subject" 
                #/usr/bin/notify-send -t 120000 "New email" "$newcount new messages in =$folder" 
            done
        fi
    fi
done

# Update access time of a marker file
touch ~/.config/neomutt/.mailsynclast



