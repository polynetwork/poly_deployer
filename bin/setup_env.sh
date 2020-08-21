#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="REGISTER AND SYNC_GENESIS_HDR: "
BORDER="----------------------------------------------"

echo "${BORDER} start to register side chain and sync genesis header ${BORDER}"

echo "${LOG_PREFIX}start to register side chain"
${POLY_HOME}/lib/tools/side_chain_mgr/side_chain_mgr -tool register_side_chain -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc"
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to register_side_chain"
    exit 1
fi

echo "${LOG_PREFIX}start to sync genesis header side chain"
${POLY_HOME}/lib/tools/side_chain_mgr/side_chain_mgr -tool sync_genesis_header -conf ${POLY_HOME}/lib/tools/config.json -pwallets "${POLY_HOME}/lib/poly/wallet.dat,${POLY_HOME}/lib/poly/wallet1.dat,${POLY_HOME}/lib/poly/wallet2.dat,${POLY_HOME}/lib/poly/wallet3.dat" -ppwds "4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc,4cUYqGj2yib718E7ZmGQc" -owallets "${POLY_HOME}/lib/ontology/wallet.dat,${POLY_HOME}/lib/ontology/wallet1.dat,${POLY_HOME}/lib/ontology/wallet2.dat,${POLY_HOME}/lib/ontology/wallet3.dat" -opwds "admin,123,123,123"
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to sync genesis header"
    exit 1
fi

eccm_addr=`cat ${POLY_HOME}/lib/tools/config.json | jq .Eccm`
eccd_addr=`cat ${POLY_HOME}/lib/tools/config.json | jq .Eccd`
cat ${POLY_HOME}/lib/relayer_eth/config.json | jq .ETHConfig.ECCMContractAddress="${eccm_addr}" | jq .ETHConfig.ECCDContractAddress="${eccd_addr}" > ${POLY_HOME}/lib/relayer_eth/config.json1
mv ${POLY_HOME}/lib/relayer_eth/config.json1 ${POLY_HOME}/lib/relayer_eth/config.json

echo "${BORDER} done ${BORDER}"
echo
