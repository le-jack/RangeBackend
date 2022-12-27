#!/bin/bash

internet=$(ping -q -w1 -c1 8.8.8.8 > /dev/null && echo online || echo offline)

if [[ "$internet" = "online" ]]; then
	echo "Internet connection online..."

elif [[ "$internet" = "offline" ]]; then
	echo 'No internet connection found. Please check your connection. If you know what you are doing then feel free to comment out this check.' && exit 1 
	


#@TODO Option for no internet.

else

	echo "Critical unknown error: $internet"

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
		echo "$package package verified..."

	elif [[ "$verified" = "error" ]]; then
		echo "$package package not found. Please install this package using:	
		'sudo apt-get install $package'" && exit 1

	else
		echo "Critical unknown error: $package" && exit 1

	fi

done


