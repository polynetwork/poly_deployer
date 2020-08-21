#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`

# clean all chains data
rm -rf ${POLY_HOME}/data/btc/chain/* ${POLY_HOME}/data/btc/relayer/* ${POLY_HOME}/data/btc/vendor/*
rm -rf ${POLY_HOME}/data/eth/chain/* ${POLY_HOME}/data/eth/relayer/*
rm -rf ${POLY_HOME}/data/ontology/chain/* ${POLY_HOME}/data/ontology/relayer/*
rm -rf ${POLY_HOME}/data/poly/chain/* ${POLY_HOME}/data/gaia/chain/* ${POLY_HOME}/data/gaia/chain/.g* 

# clean log file
rm -rf ${POLY_HOME}/log/btc/* ${POLY_HOME}/log/eth/* ${POLY_HOME}/log/ontology/* ${POLY_HOME}/log/poly/* ${POLY_HOME}/log/gaia/* ${POLY_HOME}/log/20* ${POLY_HOME}/log/ActorLog ${POLY_HOME}/lib/tools/test_tool/test.log ${POLY_HOME}/Log

# clean vendor
rm -rf ${POLY_HOME}/lib/vendor_tool/btcprivk_* ${POLY_HOME}/lib/vendor_tool/vendor_tool.json_*

# clean some extra files
rm -rf ${POLY_HOME}/peers.recent 

# clean btcx addr in config.json
conf_file="${POLY_HOME}/lib/tools/config.json"
cat ${conf_file} | jq .BtceContractAddress="\"\"" | jq .BtcoContractAddress="\"\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
