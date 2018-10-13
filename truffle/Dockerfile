FROM node:8.12.0-alpine

# set timezone
RUN apk add --no-cache tzdata
ARG timezone
RUN cp /usr/share/zoneinfo/$timezone /etc/localtime \
    && echo $timezone > /etc/timezone \
    && apk del tzdata

RUN npm install -g truffle