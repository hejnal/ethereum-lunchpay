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

echo "$(date) - Attaching console to running chain..."
geth  --datadir $CHAIN_DIR attach
