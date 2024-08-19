#!/bin/sh

userresources=$HOME/.Xresources

# merge in defaults
if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

#start i3

exec i3
