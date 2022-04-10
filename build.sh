#!/bin/bash

pwd

BUILTIN_PACKAGES=`make info | grep -A2 "^${1}:$" | grep -oP "Packages:\K.*" | tr " " "\n"`
echo "Builtin packages: $BUILTIN_PACKAGES"

ADDITIONAL_PACKAGES=`cat custom_scripts/profiles/$1/modules.txt`

export RELEASE_PACKAGES=`echo -e $ADDITIONAL_PACKAGES\n$BUILTIN_PACKAGES | sort | uniq | tr "\n" " "`

echo "Start building with these packages: $RELEASE_PACKAGES"

make image PROFILE=$1 PACKAGES=$RELEASE_PACKAGES