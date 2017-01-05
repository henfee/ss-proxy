#
# Dockerfile for shadowsocks-libev-client
#

FROM alpine
MAINTAINER Benjamin <zhangpeifeng@gmail.com>

ENV SS_VER 2.5.6
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER
ENV SS_DEP asciidoc autoconf build-base curl libtool linux-headers openssl-dev xmlto

RUN set -ex \
    && apk add --no-cache $SS_DEP \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR \
        && ./configure \
        && make install \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge $SS_DEP

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 443
ENV PASSWORD=
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300
ENV DNS_ADDR    8.8.8.8

EXPOSE $SERVER_PORT/tcp
EXPOSE $SERVER_PORT/udp

CMD ss-local  -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -l 1080 \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT
