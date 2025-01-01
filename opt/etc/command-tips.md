# Git and yadm examples

- *Sets the URL to push commits to the specified remote repository.*:
  `git remote set-url --push origin https://github.com/freakMCD/<reponame>.git`
  
- *Deletes the last commit from the remote repository while keeping it locally.*:
  `git push origin +HEAD^:main`

- *Undoes the last commit locally, keeping the changes staged for commit.*:
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

# Other
- *To change Drive permissions to username*
  `sudo chown -v username:username /media/username/disk-name`

-  *pass*
  `PASSWORD_STORE_GPG_OPTS='--pinentry-mode=loopback --passphrase <passphrase>'`
    
-  *Systemd*
*  `systemctl --user mask/unmask <service-name>`

- *To format a device to Fat*
  *Install "dosfstools"*
  *To find the device run "lsblk"*
  `sudo mkfs.msdos -F 32 /dev/<device>`

