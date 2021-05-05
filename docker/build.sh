#!/bin/bash

# Prepare the bash context
set -xe
#source /opt/rh/rh-python38/enable

# Prepare all needed environment variables
OPENWRT_VERSION=${OPENWRT_VERSION:-snapshots}
RELEASE_NAME=${RELEASE_PREFIX:-v1.0}-$(date +%Y%m%d_%H%M%S)

RELEASE_MODEL=${RELEASE_MODEL:-xiaomi_mi-router-3g}
RELEASE_ARCH=${RELEASE_ARCH:-ramips}
RELEASE_SOC=${RELEASE_SOC:-mt7621}
RELEASE_MODULES=${RELEASE_MODULES:-`cat /openwrt/modules/${RELEASE_MODEL}.txt`}

GIT_USER=${GIT_REPO%%/*}
GIT_REPO_NAME=${GIT_REPO##*/}
OPENWRT_DOWNLOAD_HOST=${OPENWRT_DOWNLOAD_HOST:-downloads.openwrt.org}

echo "Begin build ${RELEASE_NAME}@${OPENWRT_VERSION} for ${RELEASE_MODEL} with modules: ${RELEASE_MODULES}"

if [ "${OPENWRT_VERSION}" == "snapshots" ]; then 
	DOWNLOAD_URL=https://${OPENWRT_DOWNLOAD_HOST}/${OPENWRT_VERSION}/openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz
else
	DOWNLOAD_URL=https://${OPENWRT_DOWNLOAD_HOST}/releases/${OPENWRT_VERSION}/openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz
fi

# Save some debug time
if [ ! -f openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz ]; then
	wget $DOWNLOAD_URL
fi
tar -xf openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz -C /tmp/
cd /tmp/openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64

BIN_DIR=/openwrt/target/
mkdir -p $BIN_DIR
make info
make image PROFILE=${RELEASE_MODEL} "PACKAGES=${MODULES}" BIN_DIR=${BIN_DIR}

echo "Current ouput dir: $BIN_DIR"
ls -laR $BIN_DIR

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
			--name openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}.manifest \
			--file $BIN_DIR/openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}.manifest
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-rootfs0.bin \
			--file $BIN_DIR/openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-rootfs0.bin
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name sha256sums \
			--file $BIN_DIR/sha256sums

		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-kernel1.bin \
			--file $BIN_DIR/openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-kernel1.bin
			
		github-release upload \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-sysupgrade.bin \
			--file $BIN_DIR/openwrt-${RELEASE_ARCH}-${RELEASE_SOC}-${RELEASE_MODEL}-squashfs-sysupgrade.bin
	else
		echo "Skip github release uploading"
	fi
else
	echo "Build has been failed or Github token not found!"
	exit 2
fi
