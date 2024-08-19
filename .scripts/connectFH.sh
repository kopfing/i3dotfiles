#!/bin/sh

if [[ "$(whoami)" != "root" ]] ; then
   echo "Must run as root."
   exit 1
fi

systemctl start systemd-resolved
openconnect vpn.fh-joanneum.at
