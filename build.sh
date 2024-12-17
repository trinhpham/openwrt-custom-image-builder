#!/bin/bash

set -xe
pwd

if [ -e 'setup.sh' ]; then
  ./setup.sh
fi

BUILTIN_PACKAGES=`make info | grep -A2 "^${1}:$" | grep -oP "Packages:\K.*" | tr " " "\n"`
echo "Builtin packages: $BUILTIN_PACKAGES"

ADDITIONAL_PACKAGES=`cat custom_scripts/profiles/$1/modules.txt`

export PACKAGES=`echo -e "${ADDITIONAL_PACKAGES}\n${BUILTIN_PACKAGES}" | sort | uniq | tr "\n" " "`
export PROFILE=$1

echo "Start building $PROFILE with these packages: $PACKAGES"

make image "PROFILE=$PROFILE" "PACKAGES=$PACKAGES"
