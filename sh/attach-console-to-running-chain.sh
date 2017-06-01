#!/bin/bash

CHAIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHAIN_DIR="$(dirname $CHAIN_DIR)"/lunch-chain

echo $CHAIN_DIR

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
geth  --datadir $CHAIN_DIR attach ipc:/$CHAIN_DIR/geth.ipc
