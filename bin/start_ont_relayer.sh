#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START ONT RELAYER: "
BORDER="----------------------------------------------"

echo "${BORDER} start ont relayer ${BORDER}"

conf_file="${POLY_HOME}/lib/relayer_ont/config.json"
poly_wallet="${POLY_HOME}/lib/poly/wallet.dat"
ont_wallet="${POLY_HOME}/lib/ontology/wallet.dat"
db_path="${POLY_HOME}/data/ontology/relayer/"
cat ${conf_file} | jq .AliaWalletFile="\"${poly_wallet}\"" | jq .SideWalletFile="\"${ont_wallet}\"" | jq .DBPath="\"${db_path}\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
if [ ! -d ${db_path} ]
then
    mkdir -p ${db_path}
fi
if [ ! -d ${POLY_HOME}/log/ontology/relayer ]
then
    mkdir -p ${POLY_HOME}/log/ontology/relayer
fi

${POLY_HOME}/lib/relayer_ont/run_ont_relayer --cliconfig ${POLY_HOME}/lib/relayer_ont/config.json --logdir ${POLY_HOME}/log/ontology/relayer/ -alliapwd 4cUYqGj2yib718E7ZmGQc -ontpwd admin >> ${POLY_HOME}/log/ontology/relayer.log 2>&1 &

sleep 3

pid=`ps -ewf | grep ${POLY_HOME}.*run_ont_relayer | grep -v grep | awk '{print $2}'`
if [ ! -n "${pid}" ]
then
    echo "${LOG_PREFIX}failed to start ont relayer"
    exit 1
else
    echo "${LOG_PREFIX}successful to start ont relayer"
fi

echo "${BORDER} done ${BORDER}"
echo
