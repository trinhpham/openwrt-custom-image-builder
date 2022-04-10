#!/bin/bash

pwd

BUILTIN_PACKAGES=`make info | grep -A2 "^${1}:$" | grep -oP "Packages:\K.*" | tr " " "\n"`
echo "Builtin packages: $BUILTIN_PACKAGES"

ADDITIONAL_PACKAGES=`cat custom_scripts/profiles/$1/modules.txt`

export PACKAGES=`echo -e "${ADDITIONAL_PACKAGES}\n${BUILTIN_PACKAGES}" | sort | uniq | tr "\n" " "`
export PROFILE=$1

echo "Start building $PROFILE with these packages: $PACKAGES"
echo $PACKAGES > bin/target/$(cat custom_scripts/profiles/$1/arch_soc.txt | tr "-" "/")/${1}-packed_modules.txt

make image
