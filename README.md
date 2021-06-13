# DOH

This docker image can be used to easily create your own DNS over HTTPs proxy. 
It is very lightweight, based on [doh-proxy](https://github.com/jedisct1/doh-server) and higly configurable over ronment variables.

## Requirements

* A reverse proxy for TLS termination (eg. Traefik, Nginx)
* A domain name
* Upstream DNS server (default 9.9.9.9)
* Containerd compatible runtime (eg. Docker)

## Configuration

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
ghcr.io/r3d00/doh:1.0.0
```

For example you could pull the image by:

```
docker pull ghcr.io/r3d00/doh:1.0.0
```