#!/bin/bash
 
calculator() {
    bc -l
}

sync_android() {
    ~/bin/lib/androidsync
}

appupdate() {
    ~/bin/lib/appupdate
}

dlclip() {
    ~/bin/lib/dlpart
}

while :
do
    clear
    cat<<EOF

 Please enter your choice:

   Calculator       (1)
   Sync Android     (2)
   appupdate        (3)
   dlclip           (4)
                    (Q)uit
EOF
    read -n1 -s
    clear
    case $REPLY in
    "1") calculator;;
    "2") sync_android;;
    "3") appupdate;;   
    "4") dlclip;;
    "Q") break;;
    "q") echo "case sensitive!"; sleep 1;;
    esac 
done
