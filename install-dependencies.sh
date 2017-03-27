#!/bin/bash

err_report() {
    echo "Error on line $1"
    exit -1
}

trap 'err_report $LINENO' ERR

npm install node-menu
npm install web3
