FROM node:8.12.0-alpine

WORKDIR /root

RUN apk add --no-cache git
RUN git clone https://github.com/cubedro/eth-netstats.git
RUN cd eth-netstats \
    && npm install \
    && npm install -g grunt-cli \
    && grunt

COPY ./entrypoint.sh /root/entrypoint.sh
RUN ["chmod", "+x", "/root/entrypoint.sh"]
ENTRYPOINT ["sh", "/root/entrypoint.sh"]