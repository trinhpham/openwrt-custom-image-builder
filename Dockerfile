FROM centos

RUN yum install -y subversion git gawk gettext time \
		ncurses-devel zlib-devel openssl-devel libxslt wget && \
	yum group install -y "Development Tools" && \
	yum clean all

RUN wget https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz \
	&& tar -xvf openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz \
	&& rm -f openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz

WORKDIR /openwrt-imagebuilder-ramips-mt7621.Linux-x86_64

#RUN make image PROFILE=mir3g PACKAGES="luci minidlna luci-app-minidlna samba36-server transmission-web openvpn-openssl openssl-util luci-app-openvpn kmod-usb-storage kmod-fs-ext4 kmod-fs-vfat kmod-nls-cp437 kmod-nls-iso8859-1 kmod-fs-msdos kmod-fs-ntfs block-mount"
