#!/bin/sh
if [ ! -f /root/store/bootnode.key ]; then
    echo "/root/store/bootnode.key not found, running 'bootnode -nodekey'..."
    bootnode -genkey /root/store/bootnode.key
    bootnode -nodekey /root/store/bootnode.key -writeaddress > /root/store/bootnode.address
    echo "...done!"
fi

bootnode "$@" -nodekey /root/store/bootnode.key