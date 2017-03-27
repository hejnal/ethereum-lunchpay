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

echo "$(date) - Sleeping 5s... (for the first execution, a few minutes must elapse, as the complete DAG must be created)"
sleep 5

../sh/check_the_status.sh
