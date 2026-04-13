#!/bin/sh
intern=eDP-1
extern=DP-1-1-6

if xrandr |grep "$extern disconnected"; then
    onemon.sh
else
    threemons.sh
fi
