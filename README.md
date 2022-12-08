<p align="center">
    <img src="https://user-images.githubusercontent.com/2666735/50723896-0b22d000-111f-11e9-9ee4-32914e347219.png" width="150" />
</p>

<h1 align="center">Shadowsocks</h1>

<p align="center">A secure socks5 proxy, designed to protect your Internet traffic.</p>

<p align="center">
    <a href="https://ghcr.io/akafeng/shadowsocks-rust">Container Registry</a> ·
    <a href="https://github.com/shadowsocks/shadowsocks-rust">Project Source</a>
</p>

<p align="center">
    <img src="https://img.shields.io/github/workflow/status/akafeng/docker-shadowsocks-rust/Docker%20Build" />
    <img src="https://img.shields.io/github/last-commit/akafeng/docker-shadowsocks-rust" />
    <img src="https://img.shields.io/github/v/release/akafeng/docker-shadowsocks-rust" />
    <img src="https://img.shields.io/github/release-date/akafeng/docker-shadowsocks-rust" />
</p>

---

### Environment Variables

| Name | Value |
| --- | ---- |
| TZ | UTC |
| SERVER_ADDR | 0.0.0.0 |
| SERVER_PORT | 8388 |
| PASSWORD | [RANDOM] |
| METHOD | aes-256-gcm |
| TIMEOUT | 300 |
| DNS | 8.8.8.8,8.8.4.4 |
| OBFS | - |
| PLUGIN | - |
| PLUGIN_OBFS | - |

---

### Pull The Image

```bash
$ docker pull ghcr.io/akafeng/shadowsocks-rust
```

### Start Container

```bash
$ docker run -d \
  -p 8388:8388 \
  -p 8388:8388/udp \
  --restart always \
  --name shadowsocks \
  ghcr.io/akafeng/shadowsocks-rust
```

### Display Config

```bash
$ docker logs shadowsocks

 [!] Server Port: 8388
 [!] Encryption Method: aes-256-gcm
 [!] Password: TO56uVUvDMGe64Ss
 [!] DNS Server: 8.8.8.8,8.8.4.4
 [+] Enjoy :)

 2022-12-08T00:00:00.454882928+00:00 INFO  shadowsocks server 1.14.3 build 2022-04-04T17:10:43.001666678+00:00
 2022-12-08T00:00:00.455457220+00:00 INFO  shadowsocks tcp server listening on 0.0.0.0:8388, inbound address 0.0.0.0:8388
```

### With v2ray-plugin

```bash
$ docker run -d \
  -p 443:8388 \
  -p 443:8388/udp \
  -e OBFS=ws \
  --restart always \
  --name shadowsocks \
  ghcr.io/akafeng/shadowsocks-rust
```