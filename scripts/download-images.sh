#!/bin/bash

# Imports common functions.
source lib.sh

while read -r name address sha256hash; do 
    echo -e $okay "Starting $name download from $address."
    wget $address -qO ../images/$name
    echo -e $okay "ISO: $name downloaded."
    if sha256sum ../images/$name | grep -Ei $sha256hash;
        then 
        echo -e $okay "Sha256 checksums match."
        else
        echo -e $warn "Sums do not match. This could either be due to an update of the image or an unlikely sign of malicious modification. You should check and update the mirrorlist to ensure that the sha256sums are all up to date. Would you like to continue anyway? (Y\N)"
        read answer;
        if [[ "$answer" == "n" ]]; then
            exit
        fi
    fi 
    if echo "$address" | grep -Ei '.gz'; then
        mv ../images/$name "../images/$name.gz";
        gzip -d ../images/$name 
    fi 

done < "./mirrorlist"


