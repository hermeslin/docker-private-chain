FROM hermeslin/go-ethereum:v1.8.16 as geth-builder

## build final executable scenario
FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=geth-builder /usr/local/bin/geth /usr/local/bin/geth


# on build stage, use ARG as file name
COPY ./entrypoint.sh /root/entrypoint.sh

# set entry point
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]