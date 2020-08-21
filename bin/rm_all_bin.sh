#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`

# bitcoin
rm -rf ${POLY_HOME}/lib/bitcoin/bin ${POLY_HOME}/lib/bitcoin/include ${POLY_HOME}/lib/bitcoin/lib ${POLY_HOME}/lib/bitcoin/share 
# eth
rm -rf ${POLY_HOME}/lib/geth/geth
# gaia
rm -rf ${POLY_HOME}/lib/gaia/gaia*
# ontology
rm -rf ${POLY_HOME}/lib/ontology/ontology
# poly
rm -rf ${POLY_HOME}/lib/poly/poly
# relayers
rm -rf ${POLY_HOME}/lib/relayer_btc/run_btc_relayer ${POLY_HOME}/lib/relayer_eth/run_eth_relayer ${POLY_HOME}/lib/relayer_ont/run_ont_relayer ${POLY_HOME}/lib/relayer_gaia/run_gaia_relayer
# tools
rm -rf ${POLY_HOME}/lib/tools/contracts_deployer/btc_prepare ${POLY_HOME}/lib/tools/contracts_deployer/cosmos_prepare ${POLY_HOME}/lib/tools/contracts_deployer/eth_deployer ${POLY_HOME}/lib/tools/contracts_deployer/ont_deployer ${POLY_HOME}/lib/tools/side_chain_mgr/side_chain_mgr ${POLY_HOME}/lib/tools/test_tool/cctest ${POLY_HOME}/lib/tools/btctool ${POLY_HOME}/lib/vendor_tool/run_vendor