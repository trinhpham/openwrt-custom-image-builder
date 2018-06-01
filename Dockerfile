FROM golang

RUN go get github.com/aktau/github-release

FROM centos

RUN yum install -y yum-plugin-ovl subversion git gawk gettext time \
		which ncurses-devel zlib-devel openssl-devel libxslt wget && \
	yum group install -y "Development Tools" && \
	yum clean all

COPY --from=0 /go/bin/github-release /usr/local/bin/
ADD build_mir3g.sh /src/
	
WORKDIR /src

CMD ["/src/build_mir3g.sh"]