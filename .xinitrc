#!/bin/sh
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
userresources=$HOME/.Xresources

# merge in defaults

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

# start i3

exec i3
xset r rate 200 50
