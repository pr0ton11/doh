#!/bin/bash

./doh-proxy \
    -H ${VIRTUAL_HOST} \
    -l ${LISTEN_HOST}:${LISTEN_PORT} \
    -c ${MAX_CONCURRENT_CLIENTS} \
    -C ${MAX_CONCURRENT_CONNECTIONS} \
    -X ${MAX_TTL} \
    -T ${MIN_TTL} \
    -p ${URI} \
    -g ${PUBLIC_IP} \
    -u ${UPSTREAM_DNS_HOST}:${UPSTREAM_DNS_PORT} \
    -t ${TIMEOUT}