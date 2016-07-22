#
# Dockerfile for shadowsocks-libev-client
#

FROM alpine
MAINTAINER Benjamin <zhangpeifeng@gmail.com>

ENV SS_VER 2.4.8
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER
ENV SS_DEP asciidoc autoconf build-base curl libtool linux-headers openssl-dev xmlto

RUN set -xe \
    && apk add -U curl privoxy \
    && curl -sSL https://github.com/tianon/gosu/releases/download/1.9/gosu-amd64 > /usr/sbin/gosu \
    && chmod +x /usr/sbin/gosu \
    && apk del curl \
    && rm -rf /var/cache/apk/*

RUN sed -i -e '/^listen-address/s/127.0.0.1/0.0.0.0/' \
           -e '/^accept-intercepted-requests/s/0/1/' \
           -e '/^enforce-blocks/s/0/1/' \
           -e '/^#debug/s/#//' /etc/privoxy/config
RUN echo "forward-socks5 / 127.0.0.1:1080 ." >> /etc/privoxy/config

VOLUME /etc/privoxy

RUN gosu privoxy privoxy --no-daemon /etc/privoxy/config

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

EXPOSE 8118

CMD ss-local  -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -l 1080 \
              -k ${PASSWORD:-$(hostname)} \
              -m $METHOD \
              -t $TIMEOUT
             
