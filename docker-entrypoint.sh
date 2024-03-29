#!/bin/bash
set -e

if [ -z "${PASSWORD}" ]; then
    PASSWORD="$(ssservice genkey --encrypt-method "${METHOD}")"
fi

SERVER_DNS=""
if [ ! -z "${DNS}" ]; then
    SERVER_DNS="--dns ${DNS}"
fi

SERVER_NETWORK=""
if [ ! -z "${NETWORK}" ]; then
    if [[ "${NETWORK}" == "tcp_and_udp" ]]; then
        SERVER_NETWORK="-U"
    fi

    if [[ "${NETWORK}" == "udp" ]]; then
        SERVER_NETWORK="-u"
    fi
fi

if [ ! -z "${OBFS}" ]; then
    if [[ "${OBFS}" == "ws" ]]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server"
    fi

    if [[ "${OBFS}" == "wss" ]]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server;tls"
    fi

    if [[ "${OBFS}" == "quic" ]]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server;mode=quic"
    fi
fi

SERVER_PLUGIN=""
if [ ! -z "${PLUGIN}" ]; then
    SERVER_PLUGIN="--plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS}"
fi

echo ""
echo -e "\033[32m [!] Server Port:\033[0m ${SERVER_PORT}"
echo -e "\033[32m [!] Encryption Method:\033[0m ${METHOD}"
echo -e "\033[32m [!] Password:\033[0m ${PASSWORD}"
if [ ! -z "${DNS}" ]; then
    echo -e "\033[32m [!] DNS Server:\033[0m ${DNS}"
fi
if [ ! -z "${OBFS}" ]; then
    echo -e "\033[32m [!] Plugin:\033[0m ${OBFS}"
fi
echo -e "\033[32m [+] Enjoy :)\033[0m"
echo ""

ssserver \
--server-addr "${SERVER_ADDR}:${SERVER_PORT}" \
--password "${PASSWORD}" \
--encrypt-method "${METHOD}" \
--timeout "${TIMEOUT}" \
--tcp-fast-open \
--tcp-no-delay \
${SERVER_DNS} \
${SERVER_NETWORK} \
${SERVER_PLUGIN} \
"$@"
