#!/bin/bash

CHAIN_DIR=./lunch-chain

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

echo '{"nonce":"0x0000000000000042","timestamp":"0x0","parentHash":"0x0000000000000000000000000000000000000000000000000000000000000000","extraData":"0x0","gasLimit":"0x8000000","difficulty":"0x40000","mixhash":"0x0000000000000000000000000000000000000000000000000000000000000000","coinbase":"0x3333333333333333333333333333333333333333","alloc":{}}' > CustomGenesis.json
geth --datadir . init CustomGenesis.json

echo "$(date) - Creating 4 initial accounts..."
echo "test" > account_password.txt

for i in $(seq 1 4);
do
    geth --datadir . --password account_password.txt account new
done
