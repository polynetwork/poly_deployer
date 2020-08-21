#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START GAIA RELAYER: "
BORDER="----------------------------------------------"

echo "${BORDER} start gaia relayer ${BORDER}"

if [ ! -d ${POLY_HOME}/log/gaia/relayer ]
then
    mkdir -p ${POLY_HOME}/log/gaia/relayer
fi
if [ ! -d ${POLY_HOME}/data/gaia/relayer ]
then
    mkdir -p ${POLY_HOME}/data/gaia/relayer
fi

pid=`ps -ewf | grep ${POLY_HOME}.*run_gaia_relayer | grep -v grep | awk '{print $2}'`
if [ -n "${pid}" ]
then
    echo "${LOG_PREFIX}gaia relayer already start"
    exit 1
fi

conf_file="${POLY_HOME}/lib/relayer_gaia/conf.json"
wallet_file="${POLY_HOME}/lib/poly/wallet.dat"
cosmos_key_path="${POLY_HOME}/lib/relayer_gaia/cosmos_key"
db_path="${POLY_HOME}/data/gaia/relayer/db"
cat ${conf_file} | jq .cosmos_wallet="\"${cosmos_key_path}\"" | jq .poly_wallet="\"${wallet_file}\"" | jq .db_path="\"${db_path}\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
if [ ! -d ${db_path} ]
then
    mkdir -p ${db_path}
fi

${POLY_HOME}/lib/relayer_gaia/run_gaia_relayer -orcpwd=$1 -cosmospwd=$2 -conf=${POLY_HOME}/lib/relayer_gaia/conf.json >> ${POLY_HOME}/log/gaia/relayer/relayer.log 2>&1 &
if [ $? -eq 0 ]
then
    echo "${LOG_PREFIX}successful to start gaia relayer"
else
    echo "${LOG_PREFIX}failed to start relayer"
fi

echo "${BORDER} done ${BORDER}"
echo
