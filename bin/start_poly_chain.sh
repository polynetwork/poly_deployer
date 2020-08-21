#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START POLY CHAIN: "
BORDER="----------------------------------------------"

echo "${BORDER} start poly chain ${BORDER}"

if [ ! -d ${POLY_HOME}/log/poly/chain_log ]
then
    mkdir -p ${POLY_HOME}/log/poly/chain_log
fi
if [ ! -d ${POLY_HOME}/data/poly/chain ]
then
    mkdir -p ${POLY_HOME}/data/poly/chain/1
    mkdir -p ${POLY_HOME}/data/poly/chain/2
    mkdir -p ${POLY_HOME}/data/poly/chain/3
    mkdir -p ${POLY_HOME}/data/poly/chain/4
fi

${POLY_HOME}/lib/poly/poly --config ${POLY_HOME}/lib/poly/genesis.json --wallet ${POLY_HOME}/lib/poly/wallet.dat --password 4cUYqGj2yib718E7ZmGQc --rpcport 40336 --nodeport 40338 --ws --wsport 40335 --rest --restport 40334 --data-dir ${POLY_HOME}/data/poly/chain/1/ --enable-consensus >> ${POLY_HOME}/log/poly/chain_log/poly1.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start poly chain node1"
    exit 1
else
    echo "${LOG_PREFIX}successful to start poly chain node1: ( rpc address: http://0.0.0.0:40336, coinbase address: AaodCegA3EWhwd5hRdcKASGnJCPd3RJ3A5 )"
fi

${POLY_HOME}/lib/poly/poly --config ${POLY_HOME}/lib/poly/genesis.json --wallet ${POLY_HOME}/lib/poly/wallet1.dat --password 4cUYqGj2yib718E7ZmGQc --rpcport 40236 --nodeport 40238 --ws --wsport 40235 --rest --restport 40234 --data-dir ${POLY_HOME}/data/poly/chain/2/ --enable-consensus >> ${POLY_HOME}/log/poly/chain_log/poly2.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start poly chain node2"
    exit 1
else
    echo "${LOG_PREFIX}successful to start poly chain node2: ( rpc address: http://0.0.0.0:40236, coinbase address: AUd2CBoLZkRN2NwKbCZN2CXEbaFS8Y2jso )"
fi

${POLY_HOME}/lib/poly/poly --config ${POLY_HOME}/lib/poly/genesis.json --wallet ${POLY_HOME}/lib/poly/wallet2.dat --password 4cUYqGj2yib718E7ZmGQc --rpcport 40136 --nodeport 40138 --ws --wsport 40135 --rest --restport 40134 --data-dir ${POLY_HOME}/data/poly/chain/3/ --enable-consensus >> ${POLY_HOME}/log/poly/chain_log/poly3.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start poly chain node3"
    exit 1
else
    echo "${LOG_PREFIX}successful to start poly chain node3: ( rpc address: http://0.0.0.0:40136, coinbase address: AdfCn64T8ayXw76bwBhTXGQawQKFKZWxqB )"
fi

${POLY_HOME}/lib/poly/poly --config ${POLY_HOME}/lib/poly/genesis.json --wallet ${POLY_HOME}/lib/poly/wallet3.dat --password 4cUYqGj2yib718E7ZmGQc --rpcport 40036 --nodeport 40038 --ws --wsport 40035 --rest --restport 40034 --data-dir ${POLY_HOME}/data/poly/chain/4/ --enable-consensus >> ${POLY_HOME}/log/poly/chain_log/poly4.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start poly chain node4"
    exit 1
else
    echo "${LOG_PREFIX}successful to start poly chain node4: ( rpc address: http://0.0.0.0:40036, coinbase address: ALYo97aXPxB5WcfKohBAkH4QXFUHYHpgEH )"
fi



while true 
do
    lsof -i tcp:40336 > /dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 1
done

echo "${BORDER} done ${BORDER}"
echo