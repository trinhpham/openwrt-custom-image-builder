[![CircleCI](https://circleci.com/gh/trinhpham/openwrt-custom-image-builder/tree/main.svg?style=svg)](https://circleci.com/gh/trinhpham/openwrt-custom-image-builder/tree/main)
[![Artifacts](https://img.shields.io/badge/CircleCI-artifacts-green)](https://app.circleci.com/pipelines/github/trinhpham/openwrt-custom-image-builder?branch=main&filter=all&status=none&status=success)
[![Homepage](https://img.shields.io/badge/Github-repo-green)](https://github.com/trinhpham/openwrt-custom-image-builder)

[![Open in Gitpod](https://img.shields.io/badge/Gitpod-Open-%230092CF.svg)](https://gitpod.io/#https://github.com/trinhpham/openwrt-custom-image-builder)

# Introduction
**NOTE**: 
- *This repository helps generate OpenWrt firmware for <u>**any**</u> supported devices. It was first made to generate firmwares for my first OpenWrt router: Xiaomi Router Gen 3G.*
- *This repository is just for building the firmware. Any OpenWrt related issue should be posted to OpenWrt's forum.*
- *Read your device's instructions on OpenWrt wiki carefully and use my generated firmwares with <u>**your own risks**</u>.*

The OpenWRT project is perfect for powerful devices (like my old-but-great Xiaomi R3G). However, the official release/snapshot builds are very minimal versions without the WebUI manager (LUCI) and some common useful packages like SAMBA, DLNA, OpenVPN, torrent,... 
To be updated to the latest build, it takes time to do some of the most boring tasks: flash the update, install my needed components. That's the reason for me to build this repository and make all thing be automated

# Supported devices
## Xiaomi Router Gen 3G
Read this if you are interesting:
- The cheap but very powerful device: [Xiaomi Router Gen 3G](https://openwrt.org/toh/xiaomi/mir3g)
- Minimal OpenWRT Firmware [download page](https://downloads.lede-project.org/snapshots/targets/ramips/mt7621/)
- Padavan is providing support for this device also, take a look at [prometheus](http://prometheus.freize.net) if you are looking for another kind of firmware.

## TP-Link Archer C50
... Comming soon

# Help wanted
- N/A

# Fork notes
There are some notes if you'd like to fork my build:
- You must CircleCI's context secrets named `DockerHub` which contains `DOCKERHUB_USERNAME` and `DOCKERHUB_PASS` to be able to pull the builder image due to Docker hub rate limits.
- Add your preferred OpenWrt version and device's configs to workflow matrix in `.circleci/config.yml`
- Find your device on [OpenWrt table of hardware](https://openwrt.org/toh). If it is supported, most of its required information below can be found in the firmware download URL. Make your device profile folder with rules:
  + Folder name is your device's PROFILE
  + `arch_soc.txt` contains your device architecture and System on Chip model
  + `modules.txt` contains list modules you want to pack into this custom build
  + For example, download URL of my device looks like [.../openwrt-21.02.2-ramips-mt7621-xiaomi_mi-router-3g-squashfs-rootfs0.bin](https://downloads.openwrt.org/releases/21.02.2/targets/ramips/mt7621/openwrt-21.02.2-ramips-mt7621-xiaomi_mi-router-3g-squashfs-rootfs0.bin), so its profile is `xiaomi_mi-router-3g`, arch is `ramips` and soc is `mt7621`

# Debug
- This project is ready for [![Open in Gitpod](https://img.shields.io/badge/Gitpod-Open-%230092CF.svg)](https://gitpod.io/#https://github.com/trinhpham/openwrt-custom-image-builder)
- Determine your needed arguments for your build or use command
```bash
source ./findReleaseInfo.sh xiaomi_mi-router-3g release
```
- Run the build image with command 
```
# Create output folder
mkdir bin
chmod 777 bin

# Run the build
docker run -it --rm \
    -e SOURCE_DATE_EPOCH=$SOURCE_DATE_EPOCH \
    -v $(pwd):/builder/custom_scripts \
    -v $(pwd)/bin:/builder/bin openwrt/imagebuilder:${RELEASE_ARCH_SOC}-${RELEASE_VER} \
    /builder/custom_scripts/build.sh xiaomi_mi-router-3g
```
- You might need to run `chmod -R 777 .` for your source directory if facing any permission errors 
