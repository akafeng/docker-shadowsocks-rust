FROM debian:bookworm-slim AS builder

ARG SS_VERSION="1.15.4"
ARG SS_URL="https://github.com/shadowsocks/shadowsocks-rust/releases/download/v${SS_VERSION}/"

ARG V2RAY_PLUGIN_VERSION="1.3.2"
ARG V2RAY_PLUGIN_URL="https://github.com/shadowsocks/v2ray-plugin/releases/download/v${V2RAY_PLUGIN_VERSION}/"

RUN set -eux \
    && apt-get update -qyy \
    && apt-get install -qyy --no-install-recommends --no-install-suggests \
        ca-certificates \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* /var/log/* \
    \
    && ARCH=`uname -m` \
    && case "$ARCH" in \
            "x86_64") \
                SS_FILENAME="shadowsocks-v${SS_VERSION}.x86_64-unknown-linux-gnu.tar.xz" \
                V2RAY_PLUGIN_FILENAME="v2ray-plugin-linux-amd64-v${V2RAY_PLUGIN_VERSION}.tar.gz" \
                ;; \
            "aarch64") \
                SS_FILENAME="shadowsocks-v${SS_VERSION}.aarch64-unknown-linux-gnu.tar.xz" \
                V2RAY_PLUGIN_FILENAME="v2ray-plugin-linux-arm64-v${V2RAY_PLUGIN_VERSION}.tar.gz" \
                ;; \
        esac \
    \
    && wget -O shadowsocks.tar.xz ${SS_URL}${SS_FILENAME} \
    && tar -xvf shadowsocks.tar.xz -C /usr/local/bin/ \
    \
    && wget -O v2ray_plugin.tar.gz ${V2RAY_PLUGIN_URL}${V2RAY_PLUGIN_FILENAME} \
    && tar -xzvf v2ray_plugin.tar.gz -C /usr/local/bin/ \
    && mv /usr/local/bin/v2ray-plugin* /usr/local/bin/v2ray-plugin \
    \
    && rm -rf shadowsocks.tar.xz v2ray_plugin.tar.gz

######

FROM debian:bookworm-slim

ENV SERVER_ADDR="0.0.0.0"
ENV SERVER_PORT="8388"
ENV PASSWORD=
ENV METHOD="aes-256-gcm"
ENV TIMEOUT="300"
ENV DNS=
ENV NETWORK=
ENV OBFS=
ENV PLUGIN=
ENV PLUGIN_OPTS=

COPY --from=builder /usr/local/bin/* /usr/local/bin/

RUN set -eux \
    && apt-get update -qyy \
    && apt-get install -qyy --no-install-recommends --no-install-suggests \
        ca-certificates \
        rng-tools \
    && rm -rf /var/lib/apt/lists/* /var/log/*

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE ${SERVER_PORT}/tcp
EXPOSE ${SERVER_PORT}/udp
