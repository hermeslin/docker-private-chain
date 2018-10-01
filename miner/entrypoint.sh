#!/bin/sh
DATA_DIR="/root/store/.ethereum"
DAG_DIR="/root/store/.ethash"
echo $MINER_PWD > /root/MINER_PWD

if [ ! -d ${DATA_DIR}/keystore ]; then
    echo "${DATA_DIR}/keystore not found, running 'geth init' ..."
    geth --datadir "${DATA_DIR}" init root/genesis.json
    echo "genesis initial complete"

    echo "create new account, running 'geth account new' ..."
    geth --datadir "${DATA_DIR}" account new --password /root/MINER_PWD
    echo "new account complete"
fi

## set static nodes
cp /root/static-nodes.json ${DATA_DIR}

## after create account
## unlock first account with index and password
geth "$@" -nodekey /root/node.key --unlock 0 --password /root/MINER_PWD --ipcpath "/root/geth.ipc" --datadir "${DATA_DIR}" --ethash.dagdir "${DAG_DIR}"