#!/bin/bash

set -xe

RELEASE_NAME=v0.2-$(date +%Y%m%d_%H%M%S)
RELEASE_MODULES=`cat modules.txt`
GIT_USER=${GIT_REPO%%/*}
GIT_REPO_NAME=${GIT_REPO##*/}

echo "Begin build ${RELEASE_NAME} with modules ${RELEASE_MODULES}"

scl enable rh-python36 bash

wget https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
tar -xvf openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz >/dev/null
rm -f openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
cd openwrt-imagebuilder-ramips-mt7621.Linux-x86_64
make image PROFILE=xiaomi_mir3g "PACKAGES=${RELEASE_MODULES}"

echo "Current ouput dir"
ls -laR bin/targets/ramips/mt7621/

if [ $? -eq 0 ] ; then
	if [[ ! -z "$GITHUB_TOKEN" ]] ; then
		echo "Begin upload the release: $RELEASE_NAME"

		github-release release \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name $RELEASE_NAME \
			--description "CI build includes: ${RELEASE_MODULES}"
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-ramips-mt7621-device-xiaomi-mir3g.manifest \
			--file bin/targets/ramips/mt7621/openwrt-ramips-mt7621-device-xiaomi-mir3g.manifest
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-rootfs0.bin \
			--file bin/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-rootfs0.bin
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name sha256sums \
			--file bin/targets/ramips/mt7621/sha256sums

		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-kernel1.bin \
			--file bin/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-kernel1.bin
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-sysupgrade.bin \
			--file bin/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mir3g-squashfs-sysupgrade.bin
	else
		echo "Skip github release uploading"
	fi
else
	echo "Build has been failed or Github token not found!"
	exit 2
fi
