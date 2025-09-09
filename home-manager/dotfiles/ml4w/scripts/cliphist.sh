#!/bin/sh
#   ____ _ _       _     _     _
#  / ___| (_)_ __ | |__ (_)___| |_
# | |   | | | '_ \| '_ \| / __| __|
# | |___| | | |_) | | | | \__ \ |_
#  \____|_|_| .__/|_| |_|_|___/\__|
#           |_|
#

case $1 in
    d)
        cliphist list | fuzzel --dmenu --config ~/.config/fuzzel/cliphist.ini | cliphist delete
        ;;

    w)
        if [ $(echo -e "Clear\nCancel" | fuzzel --dmenu --config ~/.config/fuzzel/cliphist.ini) == "Clear" ]; then
            cliphist wipe
        fi
        ;;

    *)
        cliphist list | fuzzel --dmenu --config ~/.config/fuzzel/cliphist.ini | cliphist decode | wl-copy
        ;;
esac
