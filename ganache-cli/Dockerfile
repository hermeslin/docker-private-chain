FROM mhart/alpine-node:8 as builder

## add package
RUN apk add --no-cache make gcc g++ python git bash

## clone ganache-cli
RUN cd /root \
    && git clone https://github.com/trufflesuite/ganache-cli.git \
    && cd /root/ganache-cli

## build ganache-cli
WORKDIR /root/ganache-cli
RUN npm install
RUN npm run build

## make minimum runtime stage
FROM mhart/alpine-node:8 as runtime

WORKDIR /root/ganache-cli

COPY --from=builder "/root/ganache-cli/node_modules/ganache-core/node_modules/scrypt/build/Release" "./node_modules/ganache-core/node_modules/scrypt/build/Release/"
COPY --from=builder "/root/ganache-cli/node_modules/ganache-core/node_modules/secp256k1/build/Release" "./node_modules/ganache-core/node_modules/secp256k1/build/Release/"
COPY --from=builder "/root/ganache-cli/node_modules/ganache-core/node_modules/keccak/build/Release" "./node_modules/ganache-core/node_modules/keccak/build/Release/"
COPY --from=builder "/root/ganache-cli/node_modules/ganache-core/node_modules/sha3/build/Release" "./node_modules/ganache-core/node_modules/sha3/build/Release/"
COPY --from=builder "/root/ganache-cli/node_modules/ganache-core/node_modules/websocket/build/Release" "./node_modules/ganache-core/node_modules/websocket/build/Release/"
COPY --from=builder "/root/ganache-cli/docker/build/ganache.core.cli.js" "./ganache.core.cli.js"
COPY --from=builder "/root/ganache-cli/docker/build/ganache.core.cli.js.map" "./ganache.core.cli.js.map"

ENV DOCKER true

# set entry point
COPY ./entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]