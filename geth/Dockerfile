FROM hermeslin/go-ethereum:v1.8.16 as geth-builder

## build final executable scenario
FROM alpine:3.8
RUN apk add --no-cache ca-certificates
COPY --from=geth-builder /usr/local/bin/geth /usr/local/bin/geth

# set timezone
RUN apk add --no-cache tzdata
ARG timezone
RUN cp /usr/share/zoneinfo/$timezone /etc/localtime \
    && echo $timezone > /etc/timezone \
    && apk del tzdata

# set entry point
COPY ./entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]