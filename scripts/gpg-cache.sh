#!/bin/bash

# Set the location of the gpg-preset-passphrase binary
GPG_PRESET_PASS="/usr/libexec/gpg-preset-passphrase"

# Get the keygrip for the specified key ID
KEY_GRIP=$(gpg --with-keygrip --list-secret-keys $KEY_ID | grep -Pom1 '^ *Keygrip += +\K.*')

# Read the passphrase from the secure file
PASSPHRASE=$(<~/.secrets/gpg-passphrase)

# If the passphrase is not empty, preset it into the gpg-agent
if [ -n "$PASSPHRASE" ]; then
    echo "$PASSPHRASE" | $GPG_PRESET_PASS -c "$KEY_GRIP"
    RETVAL=$?
    
    if [ $RETVAL -eq 0 ]; then
        echo "Passphrase cached successfully"
    else
        echo "Failed to cache passphrase"
    fi
else
    echo "No passphrase found in the file"
    exit 1
fi
