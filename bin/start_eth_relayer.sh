#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START ETH RELAYER: "
BORDER="----------------------------------------------"

echo "${BORDER} start eth relayer ${BORDER}"

conf_file="${POLY_HOME}/lib/relayer_eth/config.json"
wallet_file="${POLY_HOME}/lib/poly/wallet.dat"
db_path="${POLY_HOME}/data/eth/relayer"
cat ${conf_file} | jq .BoltDbPath="\"${db_path}/boltdb\"" | jq .PolyConfig.WalletFile="\"${wallet_file}\"" | jq .ETHConfig.KeyStorePath="\"${POLY_HOME}/lib/relayer_eth\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
if [ ! -d ${db_path}/boltdb ]
then
    mkdir -p ${db_path}/boltdb
fi

if [ ! -d ${POLY_HOME}/log/eth/relayer ]
then
    mkdir -p ${POLY_HOME}/log/eth/relayer/
fi

${POLY_HOME}/lib/relayer_eth/run_eth_relayer --logdir ${POLY_HOME}/log/eth/relayer/ --cliconfig ${POLY_HOME}/lib/relayer_eth/config.json >> /dev/null 2>&1 &
sleep 1
pid=`ps -ewf | grep ${POLY_HOME}.*run_eth_relayer | grep -v grep | awk '{print $2}'`
if [ ! -n "${pid}" ]
then
    echo "${LOG_PREFIX}failed to start eth relayer"
    exit 1
else
    echo "${LOG_PREFIX}successful to start eth relayer"
fi

echo "${BORDER} done ${BORDER}"
echo