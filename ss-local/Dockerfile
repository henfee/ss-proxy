#
# Dockerfile for shadowsocks-libev-client
#

FROM alpine
MAINTAINER Benjamin <zhangpeifeng@gmail.com>

ENV SS_VER 2.4.4
ENV SS_URL https://github.com/shadowsocks/shadowsocks-libev/archive/v$SS_VER.tar.gz
ENV SS_DIR shadowsocks-libev-$SS_VER
ENV SS_DEP autoconf build-base curl libtool linux-headers openssl-dev

RUN set -ex \
    && apk add --update $SS_DEP \
    && curl -sSL $SS_URL | tar xz \
    && cd $SS_DIR \
        && ./configure \
        && make install \
        && cd .. \
        && rm -rf $SS_DIR \
    && apk del --purge $SS_DEP \
    && rm -rf /var/cache/apk/*

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 443
ENV LOCAL_PORT  1080
ENV PASSWORD    12345678
ENV METHOD      aes-256-cfb
ENV TIMEOUT     300

EXPOSE $LOCAL_PORT

CMD ss-local  -s $SERVER_ADDR \
              -p $SERVER_PORT \
              -l $LOCAL_PORT \
              -k $PASSWORD \
              -m $METHOD \
              -t $TIMEOUT
