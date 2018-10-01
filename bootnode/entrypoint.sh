#!/bin/sh
if [[ -z "$1" ]]; then
   echo "input is empty"
   exit 1
fi

if [ ! -f /root/store/$1.key ]; then
    echo "/root/store/$1.key not found, running 'bootnode -nodekey'..."
    bootnode -genkey /root/store/$1.key

    ENODE_LINE=$(bootnode -nodekey /root/store/$1.key -writeaddress)

    echo "enode://${ENODE_LINE}@$2:$3" > /root/store/$1.address
    echo "...done!"
fi

echo "generate static_nodes.json ..."
cat /root/store/*.address | json_encode -p > /root/store/static-nodes.json
echo "...done!"