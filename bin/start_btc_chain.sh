#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
COINBASE_ADDR="mpCNjy4QYAmw8eumHJRbVtt6bMDVQvPpFn"
LOG_PREFIX='START_BTC_CHAIN: '
BORDER="----------------------------------------------"

echo "${BORDER} start btc chain ${BORDER}"

if [ ! -d ${POLY_HOME}/log/btc ]
then
    mkdir ${POLY_HOME}/log/btc
fi

if [ ! -d ${POLY_HOME}/data/btc/chain ]
then
    mkdir -p ${POLY_HOME}/data/btc/chain
fi

# start btc chain in regtest mode
${POLY_HOME}/lib/bitcoin/bin/bitcoind -regtest -rpcuser=test -rpcpassword=test -rpcbind=0.0.0.0 -rpcallowip=0.0.0.0/0.0.0.0 -datadir=${POLY_HOME}/data/btc/chain/ -txindex=1 -rest=1 -server=1 >> ${POLY_HOME}/log/btc/btc_chain.log 2>&1 &
pid=`ps -ewf | grep ${POLY_HOME}.*bitcoind | grep -v grep | awk '{print $2}'`
if [ -n "${pid}" ]
then
    echo "${LOG_PREFIX}successful to start btc chain: ( rpc address: http://0.0.0.0:18443, coinbase address: ${COINBASE_ADDR} )"
else
    echo "${LOG_PREFIX}failed to start btc chain"
    exit 1
fi

echo "${LOG_PREFIX}waiting for starting rpc server"
while true 
do
    lsof -i tcp:18443 | grep LISTEN > /dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 1
done

# start tool to generate blocks if there is tx in pool
${POLY_HOME}/lib/tools/btctool -gui=0 -tool=blkgene -user=test -pwd=test -defaultaddr=${COINBASE_ADDR} -tsec=1 -url=http://0.0.0.0:18443 >> ${POLY_HOME}/log/btc/btc_gene.log 2>&1 &
pid=`ps -ewf | grep ${POLY_HOME}.*btctool | grep -v grep | awk '{print $2}'`
if [ ! -n "${pid}" ]
then
    echo "${LOG_PREFIX}failed to start blk auto-generate"
    exit 1
fi

sleep 3
${POLY_HOME}/lib/bitcoin/bin/bitcoin-cli -rpcport=18443 -rpcuser=test -rpcpassword=test getblockhash 102 >> /dev/null
if [ $? -ne 0 ]
then
    ${POLY_HOME}/lib/bitcoin/bin/bitcoin-cli -rpcport=18443 -rpcuser=test -rpcpassword=test importaddress ${COINBASE_ADDR} "coinbase" >> /dev/null
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}failed to importaddress coinbase"
        exit 1
    fi
    
    sleep 5

    ${POLY_HOME}/lib/bitcoin/bin/bitcoin-cli -rpcport=18443 -rpcuser=test -rpcpassword=test generatetoaddress 102 "${COINBASE_ADDR}" >> /dev/null
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}failed to generatetoaddress coinbase"
        exit 1
    fi
fi

echo "${BORDER} start btc chain done ${BORDER}"
echo
