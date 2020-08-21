#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`

killProcess(){
    pid=`ps -ewf | grep ${1} | grep -v grep | awk '{print $2}'`
    if [ ! -n "$pid" ]
    then
        echo "${1} is not running"
    fi

    kill -9 ${pid}
}

# stop all chains
for name in "run_btc_relayer" "run_eth_relayer" "run_ont_relayer" "run_gaia_relayer" "run_vendor" "bitcoind" "btctool" "geth" "ontology" "poly" "gaiad"
do 
    killProcess "${POLY_HOME}.*${name}"
done
echo "stop all processes for cross chain"
