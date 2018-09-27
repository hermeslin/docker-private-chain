FROM node:8.12.0-alpine

WORKDIR /root

RUN apk add --no-cache git

RUN git clone https://github.com/hermeslin/eth-net-intelligence-api
RUN cd eth-net-intelligence-api \
    && npm install

COPY ./entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]