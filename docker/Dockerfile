FROM golang

RUN go get github.com/aktau/github-release

FROM centos:8

COPY --from=0 /go/bin/github-release /usr/local/bin/

RUN dnf install -y \
	bzip2 \
	diffutils \
	file \
	gawk \
	gcc \
	gettext \
	git \
	libxslt \
	make \
	ncurses-devel \
	openssl-devel \
	perl-Thread-Queue \
	python2 \
	python38 \
	rsync \
	time \
	unzip \
	wget \
	which \
	zlib-devel \
	&& dnf clean all

WORKDIR /openwrt
ADD build.sh /openwrt/

ENV GIT_REPO=trinhpham/xiaomi-r3g-openwrt-builder \
	OPENWRT_VERSION=snapshots \
	OPENWRT_DOWNLOAD_HOST=downloads.openwrt.org \
	RELEASE_PREFIX=v1.0 \
	RELEASE_MODEL=xiaomi_mi-router-3g \
	RELEASE_MODULES= \
	RELEASE_ARCH=ramips \
	RELEASE_SOC=mt7621

CMD ["/openwrt/build.sh"]
