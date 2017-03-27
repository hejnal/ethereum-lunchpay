#!/bin/bash

CHAIN_DIR=./lunch-chain

err_report() {
    echo "Error on line $1"
    exit -1
}

trap 'err_report $LINENO' ERR

echo "$(date) - Checking the status of the private chain..."

listeninig_ports=$(netstat -ano | grep LISTEN* | grep 8545 | wc -l)

if [ $listeninig_ports -gt 0 ]
then
    echo "$(date) - Chain is up and running!"
else
    echo "$(date) - Chain is not up and running, check for errors!"
fi
