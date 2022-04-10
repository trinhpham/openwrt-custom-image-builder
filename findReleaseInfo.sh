#!/bin/bash

export RELEASE_ARCH_SOC=`cat profiles/$1/arch_soc.txt`

if [ "$2" == "stable" ]; then 
	export RELEASE_VER=`curl -s https://openwrt.org/ | grep -oP -m1 'Current Stable Release[^0-9]*\K[0-9]*\.[0-9]*\.[0-9]*'`
	if [ -z "$RELEASE_VER" ]; then
		echo "Unable to find the stable version of OpenWrt"
		exit 2
	fi
else
	export RELEASE_VER=$2
fi
