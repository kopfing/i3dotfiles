#!/bin/sh

#if [[ "$(whoami)" != "root" ]] ; then
#   echo "Must run as root."
#   exit 1
#fi

#systemctl start systemd-resolved
#openconnect -vvvvv -u jan.moser@edu.uni-graz.at univpn.uni-graz.at

export OPENSSL_CONF='/etc/openssl.conf'
openconnect-sso -s https://univpn.uni-graz.at
