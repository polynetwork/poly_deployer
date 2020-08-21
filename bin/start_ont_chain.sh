#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START ONTOLOGY: "
BORDER="----------------------------------------------"

echo "${BORDER} start ontology ${BORDER}"

if [ ! -d ${POLY_HOME}/log/ontology/chain_log ]
then
    mkdir -p ${POLY_HOME}/log/ontology/chain_log
fi
if [ ! -d ${POLY_HOME}/data/ontology/chain ]
then
    mkdir -p ${POLY_HOME}/data/ontology/chain/1
    mkdir -p ${POLY_HOME}/data/ontology/chain/2
    mkdir -p ${POLY_HOME}/data/ontology/chain/3
    mkdir -p ${POLY_HOME}/data/ontology/chain/4
    mkdir -p ${POLY_HOME}/data/ontology/chain/5
    mkdir -p ${POLY_HOME}/data/ontology/chain/6
    mkdir -p ${POLY_HOME}/data/ontology/chain/7
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet.dat --gasprice 0 --rpcport 20336 --nodeport 20338 --ws --wsport 20335 --rest --restport 20334 --password admin --data-dir ${POLY_HOME}/data/ontology/chain/1/ --log-dir ${POLY_HOME}/log/ontology/chain_log/1/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node1"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node1: ( rpc address: http://0.0.0.0:20336, coinbase address: AdzZ2VKufdJWeB8t9a8biXoHbbMe2kZeyH )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet1.dat --gasprice 0 --rpcport 20236 --nodeport 20238 --ws --wsport 20235 --rest --restport 20234 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/2/ --log-dir ${POLY_HOME}/log/ontology/chain_log/2/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node2"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node2: ( rpc address: http://0.0.0.0:20236, coinbase address: Ad5i2T3Ra8CTreCjF9Z2tY6hyDWUUwS9ZN )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet2.dat --gasprice 0 --rpcport 20136 --nodeport 20138 --ws --wsport 20135 --rest --restport 20134 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/3/ --log-dir ${POLY_HOME}/log/ontology/chain_log/3/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node3"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node3: ( rpc address: http://0.0.0.0:20136, coinbase address: APsD4gj7nZDRTvL1rqLB7KLR1LAy2cpHzW )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet3.dat --gasprice 0 --rpcport 20036 --nodeport 20038 --ws --wsport 20035 --rest --restport 20034 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/4/ --log-dir ${POLY_HOME}/log/ontology/chain_log/4/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node4"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node4: ( rpc address: http://0.0.0.0:20036, coinbase address: AGja5ttQsMRSnqXTquqLxBQiJ3rjCqEz1s )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet4.dat --gasprice 0 --rpcport 19936 --nodeport 19938 --ws --wsport 19935 --rest --restport 19934 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/5/ --log-dir ${POLY_HOME}/log/ontology/chain_log/5/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node5"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node5: ( rpc address: http://0.0.0.0:19936, coinbase address: ASfhYsxk2spmhZvykNq3EWn76Wr93D71gj )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet5.dat --gasprice 0 --rpcport 19836 --nodeport 19838 --ws --wsport 19835 --rest --restport 19834 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/6/ --log-dir ${POLY_HOME}/log/ontology/chain_log/6/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node6"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node6: ( rpc address: http://0.0.0.0:19836, coinbase address: AMjxRzq1dZTvfX6QPMokzEosvT1AvbwWCc )"
fi

${POLY_HOME}/lib/ontology/ontology --config ${POLY_HOME}/lib/ontology/genesis.json --wallet ${POLY_HOME}/lib/ontology/wallet6.dat --gasprice 0 --rpcport 19736 --nodeport 19738 --ws --wsport 19735 --rest --restport 19734 --password 123 --data-dir ${POLY_HOME}/data/ontology/chain/7/ --log-dir ${POLY_HOME}/log/ontology/chain_log/7/ --enable-consensus >> /dev/null 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start ont chain node7"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont chain node7: ( rpc address: http://0.0.0.0:19736, coinbase address: ALJacku3BuneFY2tj7jZGGF9MWqoAN864n )"
fi

while true 
do
    lsof -i tcp:20336 | grep LISTEN > /dev/null 
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 1
done

echo "${LOG_PREFIX}init ont account"
${POLY_HOME}/lib/tools/side_chain_mgr/side_chain_mgr -tool init_ont_acc -conf ${POLY_HOME}/lib/tools/config.json -owallets "${POLY_HOME}/lib/ontology/wallet.dat,${POLY_HOME}/lib/ontology/wallet1.dat,${POLY_HOME}/lib/ontology/wallet2.dat,${POLY_HOME}/lib/ontology/wallet3.dat,${POLY_HOME}/lib/ontology/wallet4.dat,${POLY_HOME}/lib/ontology/wallet5.dat,${POLY_HOME}/lib/ontology/wallet6.dat" -opwds "admin,123,123,123,123,123,123"
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to init ont account"
fi

echo "${BORDER} done ${BORDER}"
echo
