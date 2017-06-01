#!/bin/bash

CHAIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHAIN_DIR="$(dirname $CHAIN_DIR)"/lunch-chain

err_report() {
    echo "Error on line $1"
    exit -1
}

trap 'err_report $LINENO' ERR

# exit if the chain dir exists
if [ -d "$CHAIN_DIR" ]; then
  echo "Chain already exists."
  exit 0
fi

mkdir $CHAIN_DIR

cd $CHAIN_DIR

echo "$(date) - Performing a setup of the chain Genesis block..."


echo '{"nonce": "0x0000000000000042","timestamp": "0x00","parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000","extraData": "0x00","gasLimit": "0x8000000","difficulty": "0x0400","mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000","coinbase": "0x3333333333333333333333333333333333333333","alloc":{},"config":{"chainId":3141,"homesteadBlock":0,"eip155Block": 0,"eip158Block":0}}' > CustomGenesis.json
geth --datadir . init CustomGenesis.json
rm CustomGenesis.json

echo "$(date) - Creating 4 initial accounts..."
echo "test" > account_password.txt

for i in $(seq 1 4);
do
    geth --datadir . --password account_password.txt account new
done

rm account_password.txt
