#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START BTC RELAYER: "
BORDER="----------------------------------------------"

echo "${BORDER} start btc relayer ${BORDER}"

if [ ! -d ${POLY_HOME}/log/btc/relayer ] 
then
    mkdir -p ${POLY_HOME}/log/btc/relayer
fi
if [ ! -d ${POLY_HOME}/data/btc/relayer ]
then
    mkdir -p ${POLY_HOME}/data/btc/relayer
fi

pid=`ps -ewf | grep ${POLY_HOME}.*run_btc_relayer | grep -v grep | awk '{print $2}'`
if [ -n "${pid}" ]
then
    echo "${LOG_PREFIX}btc relayer already start"
    exit 1
fi

conf_file="${POLY_HOME}/lib/relayer_btc/conf.json"
wallet_file="${POLY_HOME}/lib/poly/wallet.dat"
db_path="${POLY_HOME}/data/btc/relayer/db"
cat ${conf_file} | jq .poly_ob_conf.wallet_file="\"${wallet_file}\"" | jq .retry_db_path="\"${db_path}\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
if [ ! -d ${db_path} ]
then
    mkdir -p ${db_path}
fi

echo "4cUYqGj2yib718E7ZmGQc" | ${POLY_HOME}/lib/relayer_btc/run_btc_relayer -wallet-pwd="" -conf-file=${conf_file} >> ${POLY_HOME}/log/btc/relayer/relayer.log 2>&1 &
if [ $? -eq 0 ]
then
    echo "${LOG_PREFIX}successful to start btc relayer"
else
    echo "${LOG_PREFIX}failed to start btc relayer"
    exit 1
fi

echo "${BORDER} done ${BORDER}"
echo