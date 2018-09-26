#!/bin/sh
echo $MINER_PWD > /root/MINER_PWD
if [ ! -d /root/store/.ethereum/keystore ]; then
    echo "/root/store/.ethereum/keystore not found, running 'geth init' ..."
    geth --datadir "/root/store/.ethereum" init root/genesis.json
    echo "genesis initial complete"

    echo "create new account, running 'geth account new' ..."
    geth --datadir "/root/store/.ethereum" account new --password /root/MINER_PWD
    echo "new account complete"
fi

## after create account
## unlock first account with index and password
geth "$@" --unlock 0 --password /root/MINER_PWD --ipcpath "/root/geth.ipc" --datadir "/root/store/.ethereum" --ethash.dagdir "/root/store/.ethash"