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

* A reverse proxy for TLS termination (eg. Traefik, Nginx)
* A domain name
* Upstream DNS server (default 9.9.9.9)
* Containerd compatible runtime (eg. Docker)

## Configuration

All configuration values can be set by changing environment variables. In the Dockerfile, the defaults are set.

### Important configuration
The following configuration should be changed for your enviroment

```
VIRTUAL_HOST doh.domain.local  # Domain your DoH proxy can be reached
PUBLIC_IP 100.100.100.100  # Public IP of your DoH proxy
UPSTREAM_DNS_HOST 9.9.9.9  # Upstream DNS Server
UPSTREAM_DNS_PORT 53  # Upstream DNS Server Port
```

### Additional configuration
```
LISTEN_HOST 0.0.0.0  # Listen address, leave default for production
LISTEN_PORT 3000  # Listen port, leave default for production
MAX_CONCURRENT_CLIENTS 512  # How many clients can connect to the DoH at the same time
MAX_CONCURRENT_CONNECTIONS 16  # How many connection can be opened per client
MIN_TTL 10  # The least ammount of TTL for a DNS entry
MAX_TTL 604800  # The max ammount of TTL for a DNS entry
URI /dns  # URL the reverse proxy will resolve dns
TIMEOUT 10  # Timeout for each request
```

## How to use this image

This image can be used as a normal docker image with the following tag

```
ghcr.io/pr0ton11/doh:latest
```

For example you could pull the image by:

```
docker pull ghcr.io/pr0ton11/doh:latest
```
