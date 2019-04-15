FROM golang

RUN go get github.com/aktau/github-release

FROM centos

COPY --from=0 /go/bin/github-release /usr/local/bin/

ADD wandisco.repo /etc/yum.repos.d/

RUN yum install -y yum-plugin-ovl subversion git gawk gettext time \
		which ncurses-devel zlib-devel openssl-devel libxslt wget && \
	yum group install -y "Development Tools" && \
	yum clean all

WORKDIR /src

ENV GIT_REPO=trinhpham/xiaomi-r3g-openwrt-builder

ADD start.sh /src/

CMD ["/src/start.sh"]