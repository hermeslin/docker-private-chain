FROM hermeslin/go-ethereum:v1.8.16 as geth-builder

## build final executable scenario
FROM alpine:latest

COPY --from=geth-builder /usr/local/bin/bootnode /usr/local/bin/bootnode

# start bootnode
COPY ./prepare/entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]