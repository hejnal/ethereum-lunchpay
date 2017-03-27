#!/bin/bash

CHAIN_DIR=./lunch-chain

err_report() {
    echo "Error on line $1"
    exit -1
}

trap 'err_report $LINENO' ERR

# exit if the chain dir exists
if [ ! -d "$CHAIN_DIR" ]; then
  echo "Chain does not yet exist."
  exit 0
fi

cd $CHAIN_DIR

echo "$(date) - Starting the private chain in the miner mode in background..."
nohup geth --identity "lunch-chain" --rpc --rpcport "8545" --datadir . --port "30303" --maxpeers 4 --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "admin,db,eth,net,personal,web3" --nodiscover --verbosity 3 --mine --minerthreads 1 &

echo "$(date) - Sleeping 5s..."
sleep 5

echo "$(date) - Checking the status of the private chain..."

listeninig_ports=$(netstat -ano | grep LISTENING | grep 30303 | wc -l)

if [ $listeninig_ports -gt 0 ]
then
    echo "$(date) - Chain is up and running!"
else
    echo "$(date) - Chain is not up and running, check for errors!"
fi
