#!/bin/bash

CHAIN_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CHAIN_DIR="$(dirname $CHAIN_DIR)"/lunch-chain

err_report() {
    echo "Error on line $1"
    exit -1
}

trap 'err_report $LINENO' ERR

node js/contract-admin-menu.js
