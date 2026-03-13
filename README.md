# Docker based DNS over HTTPs Server

This docker image can be used to easily create your own DNS over HTTPs proxy. 
It is very lightweight, based on Alpine Linux and [doh-server](https://github.com/DNSCrypt/doh-server).

<p align="center">
   <a aria-label="Latest doh-server version" href="https://github.com/DNSCrypt/doh-server/releases" target="_blank">
    <img alt="Latest doh-server version" src="https://img.shields.io/github/v/release/DNSCrypt/doh-server?color=success&display_name=tag&label=latest&logo=docker&logoColor=%23fff&sort=semver&style=flat-square">
  </a>
<a aria-label="Latest docker build" href="https://github.com/pr0ton11/doh/pkgs/container/doh" target="_blank">
    <img alt="Latest docker build" src="https://github.com/pr0ton11/doh/actions/workflows/build.yml/badge.svg">
  </a>
</p>

## Requirements

* A reverse proxy for TLS termination (eg. Traefik, Nginx, Caddy)
* A domain name
* Upstream DNS server (default 9.9.9.9)
* Containerd compatible runtime (eg. Docker)

## Configuration

All configuration values can be set by changing environment variables. In the Dockerfile, the defaults are set.

### Important configuration

The following configuration should be changed for your environment:

| Variable | Default | Description |
|---|---|---|
| `VIRTUAL_HOST` | `doh.domain.local` | Domain your DoH proxy can be reached at |
| `PUBLIC_IP` | `100.100.100.100` | Public IP of your DoH proxy |
| `UPSTREAM_DNS_HOST` | `9.9.9.9` | Upstream DNS server address |
| `UPSTREAM_DNS_PORT` | `53` | Upstream DNS server port |

### Server configuration

| Variable | Default | Description |
|---|---|---|
| `LISTEN_HOST` | `0.0.0.0` | Listen address, leave default for production |
| `LISTEN_PORT` | `3000` | Listen port, leave default for production |
| `URI` | `/dns-query` | URL path for DNS queries |
| `TIMEOUT` | `10` | Timeout for each request in seconds |

### Client limits

| Variable | Default | Description |
|---|---|---|
| `MAX_CONCURRENT_CLIENTS` | `512` | Maximum number of simultaneous clients |
| `MAX_CONCURRENT_CONNECTIONS` | `16` | Maximum number of concurrent requests per client |

### TTL configuration

| Variable | Default | Description |
|---|---|---|
| `MIN_TTL` | `10` | Minimum TTL for a DNS entry in seconds |
| `MAX_TTL` | `604800` | Maximum TTL for a DNS entry in seconds (default 7 days) |
| `ERR_TTL` | `2` | TTL for error responses in seconds |

### Optional configuration

| Variable | Default | Description |
|---|---|---|
| `LOCAL_BIND_ADDRESS` | _(empty)_ | Local address to connect from (omitted if empty) |
| `PUBLIC_PORT` | _(empty)_ | External port if not 443 (omitted if empty) |

### Feature flags

Set to `true` to enable, `false` to disable.

| Variable | Default | Description |
|---|---|---|
| `DISABLE_POST` | `false` | Disable POST queries for DoH |
| `DISABLE_KEEPALIVE` | `false` | Disable keepalive connections |
| `ALLOW_ODOH_POST` | `false` | Allow POST queries over ODoH even if disabled for DoH |

### EDNS Client Subnet (ECS)

ECS allows the proxy to forward truncated client IP information to upstream DNS resolvers,
enabling geo-optimized DNS responses.

| Variable | Default | Description |
|---|---|---|
| `ENABLE_ECS` | `false` | Enable EDNS Client Subnet functionality |
| `ECS_PREFIX_V4` | `24` | IPv4 prefix length for ECS |
| `ECS_PREFIX_V6` | `56` | IPv6 prefix length for ECS |

When running behind a reverse proxy with ECS enabled, make sure to pass the `X-Forwarded-For` or
`X-Real-IP` headers to the DoH proxy so it can extract the client's real IP address.

## How to use this image

This image can be used as a normal docker image with the following tag:

```
ghcr.io/pr0ton11/doh:latest
```

For example you could pull the image by:

```
docker pull ghcr.io/pr0ton11/doh:latest
```

### Docker Compose example

```yaml
services:
  doh:
    image: ghcr.io/pr0ton11/doh:latest
    environment:
      VIRTUAL_HOST: doh.example.com
      PUBLIC_IP: 203.0.113.1
      UPSTREAM_DNS_HOST: 9.9.9.9
      UPSTREAM_DNS_PORT: 53
    ports:
      - "3000:3000"
    restart: unless-stopped
```

### Docker Compose with ECS and ODoH

```yaml
services:
  doh:
    image: ghcr.io/pr0ton11/doh:latest
    environment:
      VIRTUAL_HOST: doh.example.com
      PUBLIC_IP: 203.0.113.1
      UPSTREAM_DNS_HOST: 9.9.9.9
      ENABLE_ECS: "true"
      ALLOW_ODOH_POST: "true"
    ports:
      - "3000:3000"
    restart: unless-stopped
```
