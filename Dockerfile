FROM messense/rust-musl-cross:x86_64-musl as build
###
### DNS over HTTPs
###

# Compile DOH proxy without https support
# This image is intended to run behind a reverse proxy for tls termination
RUN cargo install doh-proxy --no-default-features --target x86_64-unknown-linux-musl

# Runtime container
FROM alpine:latest

# Environment variables to configure doh
# Required configuration
ENV VIRTUAL_HOST=doh.domain.local
ENV PUBLIC_IP=100.100.100.100
ENV UPSTREAM_DNS_HOST=9.9.9.9
ENV UPSTREAM_DNS_PORT=53

# Server configuration
ENV LISTEN_HOST=0.0.0.0
ENV LISTEN_PORT=3000
ENV URI=/dns-query
ENV TIMEOUT=10

# Client limits
ENV MAX_CONCURRENT_CLIENTS=512
ENV MAX_CONCURRENT_CONNECTIONS=16

# TTL configuration
ENV MIN_TTL=10
ENV MAX_TTL=604800
ENV ERR_TTL=2

# Optional configuration (leave empty to omit)
ENV LOCAL_BIND_ADDRESS=
ENV PUBLIC_PORT=

# Feature flags (set to "true" to enable)
ENV DISABLE_POST=false
ENV DISABLE_KEEPALIVE=false
ENV ALLOW_ODOH_POST=false

# EDNS Client Subnet (ECS) configuration
ENV ENABLE_ECS=false
ENV ECS_PREFIX_V4=24
ENV ECS_PREFIX_V6=56

# Prepare doh-proxy service
COPY --chown=root:root --from=build /root/.cargo/bin/doh-proxy /usr/local/bin/doh-proxy
COPY --chown=root:root entrypoint.sh /
RUN chmod +x /usr/local/bin/doh-proxy && chmod +x /entrypoint.sh && doh-proxy -V

# Expose default port
EXPOSE 3000

# Create entrypoint based on env variables
ENTRYPOINT ["/entrypoint.sh"]
