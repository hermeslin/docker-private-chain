#!/bin/sh
if [ ! -d /root/store/.ethereum/keystore ]; then
    echo "/root/store/.ethereum/keystore not found, running 'geth init'..."
    geth --datadir "/root/store/.ethereum" init root/genesis.json
    echo "...done!"
fi

geth "$@" --ipcpath "/root/geth.ipc" --datadir "/root/store/.ethereum"