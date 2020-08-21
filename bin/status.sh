#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`

find_process() {
    pid=`ps -ewf | grep ${POLY_HOME}.*${1} | grep -v grep | awk '{print $2}'`
    if [ -n "${pid}" ]
    then
        echo "running pid: "
        echo ${pid}
    else
        echo "not running"
    fi
}

for name in "run_btc_relayer" "run_eth_relayer" "run_ont_relayer" "run_gaia_relayer" "run_vendor" "bitcoind" "btctool" "geth" "ontology" "poly/poly" "gaiad"
do 
    echo "-----------------------------------------------------"
    echo "${name}'s status is: "
    find_process ${name}
    echo "-----------------------------------------------------"
done