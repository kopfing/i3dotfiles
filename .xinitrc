#!/bin/sh

userresources=$HOME/.Xresources

# merge in defaults
if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

export XDG_CURRENT_DESKTOP=i3

dbus-update-activation-environment --systemd \
  DISPLAY \
  XAUTHORITY \
  XDG_CURRENT_DESKTOP \
  DBUS_SESSION_BUS_ADDRESS

systemctl --user import-environment \
  DISPLAY \
  XAUTHORITY \
  XDG_CURRENT_DESKTOP \
  DBUS_SESSION_BUS_ADDRESS

#start i3

exec i3
