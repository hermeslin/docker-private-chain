#!/bin/sh
DATA_DIR="/root/store/.ethereum"
DAG_DIR="/root/store/.ethash"

if [ ! -d ${DATA_DIR}/keystore ]; then
    echo "${DATA_DIR}/keystore not found, running 'geth init'..."
    geth --datadir "${DATA_DIR}" init root/genesis.json
    echo "...done!"
fi

## set static nodes
cp /root/static-nodes.json ${DATA_DIR}

## start geth
geth "$@" -nodekey /root/node.key --ipcpath "/root/geth.ipc" --datadir "${DATA_DIR}"  --ethash.dagdir "${DAG_DIR}"