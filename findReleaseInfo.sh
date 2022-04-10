#!/bin/bash

export RELEASE_ARCH_SOC=`cat profiles/$1/arch_soc.txt`

if [ "$2" == "stable" ]; then 
	RELEASE_VER=`curl -s https://openwrt.org/ | grep -oP 'Current Stable Release[^0-9]*\K[0-9]*\.[0-9]*' | head -1`
	if [ -z "$RELEASE_VER" ]; then
		echo "Unable to find the stable version of OpenWrt"
		exit 2
	fi
	export RELEASE_VER="openwrt-$RELEASE_VER"
else
	export RELEASE_VER=$2
fi

export SOURCE_DATE_EPOCH="$(git log -1 --format=%at $(git describe --abbrev=0))"