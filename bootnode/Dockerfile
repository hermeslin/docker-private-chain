FROM hermeslin/go-ethereum:v1.8.16 as geth-builder

##
FROM golang:1.10-alpine as go-builder
RUN apk add git
RUN git clone https://github.com/fedir/json_encode.git
RUN cd ./json_encode \
    && go build
RUN mv ./json_encode/json_encode /usr/local/bin/json_encode

## build final executable scenario
FROM alpine:latest

COPY --from=geth-builder /usr/local/bin/bootnode /usr/local/bin/bootnode
COPY --from=go-builder /usr/local/bin/json_encode /usr/local/bin/json_encode

# start bootnode
COPY ./entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]