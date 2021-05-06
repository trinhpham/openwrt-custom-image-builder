[![Build Status](https://travis-ci.com/trinhpham/xiaomi-r3g-openwrt-builder.svg?branch=master)](https://travis-ci.com/trinhpham/xiaomi-r3g-openwrt-builder)

[Latest build](https://github.com/trinhpham/xiaomi-r3g-openwrt-builder/releases/latest)

[Homepage](https://github.com/trinhpham/xiaomi-r3g-openwrt-builder)

# Introduction
**NOTE**: 
- *This repository helps generate OpenWrt firmware for <u>**any**</u> supported devices. I keep the old repo name, since it was first made to generate firmwares for my first OpenWrt router: Xiaomi Router Gen 3G.*
- *This repository is just for building the firmware. Any OpenWrt related issue should be posted to OpenWrt's forum.*
- *Read your device's instructions on OpenWrt wiki carefully and use my generated firmwares with <u>**your own risks**</u>.*

The OpenWRT project is perfect for powerful devices, .
However, its snapshot build is a very minimal version without the WebUI manager (LUCI) and some common useful tools like SAMBA, DLNA, OpenVPN, torrent,...
To be updated to the latest build, it takes time to do some of the most boring tasks: flash the update, install my needed components.
That's the reason for me to build this repository and make all thing be automated.

# Supported devices
## Xiaomi Router Gen 3G
Read this if you are interesting:
- The cheap but very powerful device: [Xiaomi Router Gen 3G](https://openwrt.org/toh/xiaomi/mir3g)
- Minimal OpenWRT Firmware [download page](https://downloads.lede-project.org/snapshots/targets/ramips/mt7621/)
- Padavan is providing support for this device also, take a look at [prometheus](http://prometheus.freize.net) if you are looking for another kind of firmware.

## TP-Link Archer C50
... Comming soon

# Help wanted
- [ ] Change the docker base image to [openwrtorg/imagebuilder](https://hub.docker.com/r/openwrtorg/imagebuilder) instead of centos 7 as current
- [x] Support build for both release/stable and snapshot version
- [x] Support build for other devices
- [ ] Move to Circle-CI, which allows us to have better Docker integration, and store build output as artifacts

# The docker image
Name: [trinhpham/xiaomi-r3g-openwrt-builder](https://hub.docker.com/r/trinhpham/xiaomi-r3g-openwrt-builder)

- This is a build-automated docker image that has all needed build tools and libraries installed.
- This also includes github-release tool for the script `build.sh` to automatic deploy new release files to Github

# The Travis-CI build
You can view my automated build at [travis-ci.com](https://travis-ci.com/trinhpham/xiaomi-r3g-openwrt-builder).
This build calls the build script `build.sh` inside a Docker container of Docker image above.

_Note:_ Travis-CI doesn't support Docker volume mounting (except its Enterprise plan, [ref](https://docs.travis-ci.com/user/enterprise/worker-configuration/#mounting-volumes-across-worker-jobs-on-enterprise)), so you cannot transfer neither source nor ouput files to/from the container. I chose to run all build tasks inside the Docker container, tell me if you have any better idea :). 

# Fork notes
There are some notes if you'd like to fork my build:
- You must pass the environment variable `GITHUB_TOKEN` for the github-release, `DOCKER_USERNAME` and `DOCKER_PASSWORD` for helping reduce [impact of Docker hub limit rate](https://blog.travis-ci.com/docker-rate-limits) 
- Add your preferred OpenWrt version and device's configs to `job.include` in `.travis.yml`
- Update your preferred modules into file `modules/<DeviceModel>.txt`, in which `DeviceModel` (named as `RELEASE_MODEL` in build env var) is the profile name that can be retrieve from command `make info`

# Debug
- Build the docker image by command `docker build -t testimage docker/`
- Run the build image with command 
```
docker run -it --rm -v $(pwd):/openwrt/ \
    -e OPENWRT_DOWNLOAD_HOST=sv1-di.getto.dev \
    -e RELEASE_MODEL=xiaomi_mir3g \
    -e OPENWRT_VERSION=stable \
    testimage /openwrt/docker/build.sh
```
