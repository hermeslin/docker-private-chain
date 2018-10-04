#!/bin/sh
exec env NODE_ENV=production \
RPC_HOST=$MACHINE_TYPE \
RPC_PORT=8400 \
WS_SERVER=http://monitor-view:3000 \
WS_SECRET=$MONITOR_VIEW_SECRET \
npm start --prefix /root/eth-net-intelligence-api