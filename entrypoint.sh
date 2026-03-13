#!/bin/sh

# Build the doh-proxy command with required arguments
CMD="doh-proxy \
    -H ${VIRTUAL_HOST} \
    -l ${LISTEN_HOST}:${LISTEN_PORT} \
    -c ${MAX_CONCURRENT_CLIENTS} \
    -C ${MAX_CONCURRENT_CONNECTIONS} \
    -X ${MAX_TTL} \
    -T ${MIN_TTL} \
    -E ${ERR_TTL} \
    -p ${URI} \
    -g ${PUBLIC_IP} \
    -u ${UPSTREAM_DNS_HOST}:${UPSTREAM_DNS_PORT} \
    -t ${TIMEOUT}"

# Optional: local bind address
if [ -n "${LOCAL_BIND_ADDRESS}" ]; then
    CMD="${CMD} -b ${LOCAL_BIND_ADDRESS}"
fi

# Optional: public port (if not 443)
if [ -n "${PUBLIC_PORT}" ]; then
    CMD="${CMD} -j ${PUBLIC_PORT}"
fi

# Feature flags
if [ "${DISABLE_POST}" = "true" ]; then
    CMD="${CMD} -P"
fi

if [ "${DISABLE_KEEPALIVE}" = "true" ]; then
    CMD="${CMD} -K"
fi

if [ "${ALLOW_ODOH_POST}" = "true" ]; then
    CMD="${CMD} -O"
fi

# EDNS Client Subnet (ECS)
if [ "${ENABLE_ECS}" = "true" ]; then
    CMD="${CMD} --enable-ecs --ecs-prefix-v4 ${ECS_PREFIX_V4} --ecs-prefix-v6 ${ECS_PREFIX_V6}"
fi

# Execute the command
exec ${CMD}
