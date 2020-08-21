#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`



# start all chains
${POLY_HOME}/bin/start_btc_chain.sh
if [ $? -ne 0 ]
then
    echo "failed to start bitcoin"
    exit 1
fi
${POLY_HOME}/bin/start_eth_chain.sh
if [ $? -ne 0 ]
then
    echo "failed to start ethereum"
    exit 1
fi
${POLY_HOME}/bin/start_ont_chain.sh
if [ $? -ne 0 ]
then
    echo "failed to start ontology"
    exit 1
fi
${POLY_HOME}/bin/start_poly_chain.sh
if [ $? -ne 0 ]
then
    echo "failed to start poly chain"
    exit 1
fi
${POLY_HOME}/bin/start_gaia_chain.sh
if [ $? -ne 0 ]
then
    echo "failed to start gaia chain"
    exit 1
fi

# deploy all contracts
${POLY_HOME}/bin/deploy_contracts.sh
if [ $? -ne 0 ]
then
    echo "failed to deploy contracts"
    exit 1
fi
# register side chain and sync genesis blks
${POLY_HOME}/bin/setup_env.sh
if [ $? -ne 0 ]
then
    echo "failed to register side chain and sync genesis blks"
    exit 1
fi

# start all relayers
${POLY_HOME}/bin/start_btc_relayer.sh
if [ $? -ne 0 ]
then
    echo "failed to start btc relayer"
    exit 1
fi
${POLY_HOME}/bin/start_eth_relayer.sh
if [ $? -ne 0 ]
then
    echo "failed to start eth relayer"
    exit 1
fi
${POLY_HOME}/bin/start_ont_relayer.sh
if [ $? -ne 0 ]
then
    echo "failed to start ont relayer"
    exit 1
fi
${POLY_HOME}/bin/start_gaia_relayer.sh
if [ $? -ne 0 ]
then
    echo "failed to start gaia relayer"
    exit 1
fi

# start vendors
${POLY_HOME}/bin/start_vendor_tool.sh
if [ $? -ne 0 ]
then
    echo "failed to start vendor tools"
    exit 1
fi

echo "=============================================="
echo "ready for cross chain transactions"
echo "=============================================="