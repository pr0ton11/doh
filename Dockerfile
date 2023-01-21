FROM ekidd/rust-musl-builder:latest as build
###
### DNS over HTTPs
###

# Compile DOH proxy without https support
# This image is intended to run behind a reverse proxy for tls termination
RUN cargo install doh-proxy --no-default-features --target x86_64-unknown-linux-musl

# Runtime container
FROM alpine:latest

# Metadata
LABEL version="1.0.0" \
    maintainer="ms <ms@pr0.tech>" \
    description="DNS over HTTPs"

# Environment variables to configure doh
ENV VIRTUAL_HOST doh.domain.local
ENV LISTEN_HOST 0.0.0.0
ENV LISTEN_PORT 3000
ENV MAX_CONCURRENT_CLIENTS 512
ENV MAX_CONCURRENT_CONNECTIONS 16
ENV MIN_TTL 10
ENV MAX_TTL 604800
ENV URI /
ENV PUBLIC_IP 100.100.100.100
ENV UPSTREAM_DNS_HOST 9.9.9.9
ENV UPSTREAM_DNS_PORT 53
ENV TIMEOUT 10

# Prepare doh-proxy service
COPY --chown=root:root --from=build /usr/local/cargo/bin/doh-proxy /usr/local/bin/doh-proxy
COPY --chown=root:root entrypoint.sh /
RUN chmod +x /usr/local/bin/doh-proxy && doh-proxy -V

# Expose default port
EXPOSE 3000

# Create entrypoint based on env variables
ENTRYPOINT ["/entrypoint.sh"]
