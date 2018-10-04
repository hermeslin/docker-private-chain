FROM alpine:3.8 as solidity-builder

RUN apk --no-cache --update add build-base cmake boost-dev git \
    && sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp

## git clone repo and build
RUN git clone --depth 1 --recursive -b release https://github.com/ethereum/solidity
RUN cd /solidity \
    && git fetch --all --tags --prune \
    && git checkout tags/v0.4.25 \
    && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1

RUN cd /solidity \
    && make solc \
    && install -s solc/solc /usr/bin

FROM alpine:3.8

## install necessary libs
RUN apk add --no-cache tzdata libstdc++

## set timezone
ARG timezone
RUN cp /usr/share/zoneinfo/$timezone /etc/localtime \
    && echo $timezone > /etc/timezone \
    && apk del tzdata

## copy solidity bin
COPY --from=solidity-builder /usr/bin/solc /usr/local/bin/solc