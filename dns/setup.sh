#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

okay="[ ${GREEN}OKAY${NC} ]:"
fail="[ ${RED}FAIL${NC} ]:"
warn="[ ${YELLOW}WARN${NC} ]:"

internet=$(ping -q -w1 -c1 8.8.8.8 > /dev/null && echo online || echo offline)

user="$(whoami)"

if [[ "$user" = "root" ]]; then
	echo -e "$okay Sudo permissions verified..."

elif [[ "$user" != "root" ]]; then
	echo -e "$warn Not run as root, directory creation may fail. Are you running with sudo?"

fi

if [[ "$internet" = "online" ]]; then
	echo -e "$okay Internet connection verified..."

elif [[ "$internet" = "offline" ]]; then
	echo -e "$fail No internet connection found. Please check your connection."
	exit 1


#@TODO Option for no internet.

else

	echo -e "$fail Critical unknown error: $internet"

fi


#List of packages to check for.
packageList=(
	"bind9"
	"dnsutils"
)

for package in "${packageList[@]}"
do
	verified="$(dpkg -s $package &> /dev/null && echo ok || echo error)"

	if [[ "$verified" =  "ok" ]]; then
		echo -e "$okay $package package verified..."

	elif [[ "$verified" = "error" ]]; then
		echo -e "$fail $package package not found. Please install this package using:	
		'sudo apt-get install $package'" && exit 1

	else
		echo -e "$fail Critical unknown error: $package" && exit 1

	fi

done


if [ -e "/etc/bind/named.conf.local.backup" ]; then
	echo -e "$warn named.conf.local.backup detected."

elif [ ! -e "/etc/bind/named.conf.local.backup" ]; then
	echo -e "$okay Creating backup named.conf.local. (/etc/bind/named.conf.local.backup)"
	cp /etc/bind/named.conf.local /etc/bind/named.conf.local.backup

else 
	echo -e "$fail Critical unknown error @ /etc/bind/named.conf.local.backup creation (line 72)"

fi

if [ -d "/etc/bind/zones" ]; then
	echo -e "$warn Zones directory already exists (/etc/bind/zones)..."
elif [ ! -d "/etc/bind/zones" ]; then
	echo -e "$okay Creating zones directory (/etc/bind/zones)..."
	mkdir /etc/bind/zones &> /dev/null
else
	echo -e "$fail Critical unknown error @ /etc/bind/zones creation (line 82)"
fi


echo -e "$okay Copying db.10.14 & db.auror.mil into /etc/bind/zones..."
cp ./db.10.14 /etc/bind/zones/db.10.14
cp ./db.auror.mil /etc/bind/zones/db.auror.mil


