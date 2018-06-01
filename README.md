[![Build Status](https://travis-ci.org/trinhpham/xiaomi-r3g-openwrt-builder.svg?branch=master)](https://travis-ci.org/trinhpham/xiaomi-r3g-openwrt-builder)

[Latest build](https://github.com/trinhpham/xiaomi-r3g-openwrt-builder/releases/latest)

[Homepage](https://github.com/trinhpham/xiaomi-r3g-openwrt-builder)

# Introduction
The OpenWRT project is supporting for the device Xiaomi Router Gen 3G.
However, the snapshot build is a minimal version without WebUI and some common components like SAMBA, DLNA, OpenVPN, torrent,...
To be updated to the latest build, it takes time to do the most boring tasks: flash the update, install my needed components.
That's the reason for me to build this repository.

Read this if you are interesting:
- The cheap but very powerful device: [Xiaomi Router Gen 3G](https://wiki.openwrt.org/toh/xiaomi/mir3g)
- Minimal OpenWRT Firmware [download page](https://downloads.lede-project.org/snapshots/targets/ramips/mt7621/)
- Padavan is providing support for this device also, take a look at [prometheus](http://prometheus.freize.net), etc.

# The docker image
Name: trinhpham/xiaomi-r3g-openwrt-builder

This is an build-automated docker image that have all needed build tools and libraries installed.
This also includes github-release tool for the script `build_mir3g.sh` to automatic deploy new release files to Github

# The Travis-CI build
You can view my automated build at [travis-ci.org](https://travis-ci.org/trinhpham/xiaomi-r3g-openwrt-builder).
This build call the build script `build_mir3g.sh` inside a Docker container of Docker image above.

There are two notes if you'd like to fork my build:
- You must pass the environment variable GITHUB_TOKEN for the github-release
- Travis-CI.org doesn't support Docker volume mounting (except its Enterprise plan), so you cannot transfer neither source nor ouput files to/from the container. I chose to run all build task inside the Docker container, tell me if you have any better idea :)