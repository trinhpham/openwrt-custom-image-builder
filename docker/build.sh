#!/bin/bash

set -xe

# Prepare all needed environment variables
OPENWRT_VERSION=${OPENWRT_VERSION:-snapshots}
OPENWRT_DOWNLOAD_HOST=${OPENWRT_DOWNLOAD_HOST:-downloads.openwrt.org}
RELEASE_MODEL=${RELEASE_MODEL:-xiaomi_mi-router-3g}
RELEASE_ARCH=${RELEASE_ARCH:-ramips}
RELEASE_SOC=${RELEASE_SOC:-mt7621}

if [ "${OPENWRT_VERSION}" == "snapshots" ]; then 
	DOWNLOAD_URL=https://${OPENWRT_DOWNLOAD_HOST}/${OPENWRT_VERSION}/targets/${RELEASE_ARCH}/${RELEASE_SOC}/openwrt-imagebuilder-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz
	RELEASE_TYPE=--pre-release
elif [ "${OPENWRT_VERSION}" == "stable" ]; then 
	OPENWRT_VERSION=`curl -s https://openwrt.org/ | grep -oP 'Current Stable Release[^0-9]*\K[0-9]*\.[0-9]*\.[0-9]*'`
	if [ -z "$OPENWRT_VERSION" ]; then
		echo "Unable to find the stable version of OpenWrt"
		exit 2
	fi
	DOWNLOAD_URL=https://${OPENWRT_DOWNLOAD_HOST}/releases/${OPENWRT_VERSION}/targets/${RELEASE_ARCH}/${RELEASE_SOC}/openwrt-imagebuilder-${OPENWRT_VERSION}-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz
else
	DOWNLOAD_URL=https://${OPENWRT_DOWNLOAD_HOST}/releases/${OPENWRT_VERSION}/targets/${RELEASE_ARCH}/${RELEASE_SOC}/openwrt-imagebuilder-${OPENWRT_VERSION}-${RELEASE_ARCH}-${RELEASE_SOC}.Linux-x86_64.tar.xz
fi

RELEASE_NAME=${OPENWRT_VERSION}-${RELEASE_PREFIX:-v1.0}-$(date +%Y%m%d_%H%M%S)
RELEASE_MODULES=${RELEASE_MODULES:-`cat /openwrt/modules/${RELEASE_MODEL}.txt | tr '\n' ' '`}

GIT_USER=${GIT_REPO%%/*}
GIT_REPO_NAME=${GIT_REPO##*/}

echo "Begin build ${RELEASE_NAME}@${OPENWRT_VERSION} for ${RELEASE_MODEL} with modules: ${RELEASE_MODULES}"

# Save some debug time
if [ ! -f openwrt-imagebuilder.tar.xz ]; then
	wget $DOWNLOAD_URL -O openwrt-imagebuilder.tar.xz
fi
tar -xf openwrt-imagebuilder.tar.xz -C /tmp/
mv /tmp/openwrt-imagebuilder-* /tmp/openwrt-imagebuilder
cd /tmp/openwrt-imagebuilder

BIN_DIR=/openwrt/target/
mkdir -p $BIN_DIR
make info
make image PROFILE=${RELEASE_MODEL} "PACKAGES=${RELEASE_MODULES}" BIN_DIR=${BIN_DIR}

echo "Current ouput dir: $BIN_DIR"
ls -laR $BIN_DIR
cd $BIN_DIR

if [ $? -eq 0 ] ; then
	if [[ ! -z "$GITHUB_TOKEN" ]] ; then
		echo "Begin upload the release: $RELEASE_NAME"

		github-release release \
			--user $GIT_USER \
			--repo $GIT_REPO_NAME \
			--tag $RELEASE_NAME \
			--name $RELEASE_NAME \
			--description "CI build includes: ${RELEASE_MODULES}" \
			$RELEASE_TYPE

		for f in .
		do
			github-release upload \
				--user $GIT_USER \
				--repo $GIT_REPO_NAME \
				--tag $RELEASE_NAME \
				--name $f \
				--file $f
		done
	else
		echo "Skip github release uploading"
	fi
else
	echo "Build has been failed or Github token not found!"
	exit 2
fi
