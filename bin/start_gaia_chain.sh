#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX='START_GAIA_CHAIN: '
BORDER="----------------------------------------------"

echo "${BORDER} start gaia ${BORDER}"

if [ ! -d ${POLY_HOME}/log/gaia/chain/ ]
then
    mkdir -p ${POLY_HOME}/log/gaia/chain/
fi
if [ ! -d ${POLY_HOME}/data/gaia/chain/ ]
then
    mkdir -p ${POLY_HOME}/data/gaia/chain/
fi

cosmos_key_pwd=`jq .CMWalletPwd ${POLY_HOME}/lib/tools/config.json | sed 's/"//g'`
side_chain_id=`jq .CMCrossChainId ${POLY_HOME}/lib/tools/config.json`

cd ${POLY_HOME}/data/gaia/chain/

${POLY_HOME}/lib/gaia/gaiad init --home=${POLY_HOME}/data/gaia/chain/.gaiad --chain-id=cc-cosmos cc-cosmos
if [ $? -ne 0 ]
then
    echo "failed to init gaia chain"
    exit 1
fi

${POLY_HOME}/bin/gaia_add_account.sh $cosmos_key_pwd $side_chain_id $POLY_HOME
if [ $? -ne 0 ]
then
    echo "failed to add-genesis-account"
    exit 1
fi

${POLY_HOME}/bin/gaia_gentx.sh $cosmos_key_pwd $POLY_HOME
if [ $? -ne 0 ]
then
    echo "failed to gentx"
    exit 1
fi

${POLY_HOME}/lib/gaia/gaiad collect-gentxs --home=${POLY_HOME}/data/gaia/chain/.gaiad 
if [ $? -ne 0 ]
then
    echo "failed to collect-gentxs"
    exit 1
fi

${POLY_HOME}/lib/gaia/gaiad start --pruning=nothing --rpc.laddr=tcp://0.0.0.0:26650 --p2p.laddr=tcp://0.0.0.0:26646 --address=tcp://0.0.0.0:26648 --home=${POLY_HOME}/data/gaia/chain/.gaiad >> ${POLY_HOME}/log/gaia/chain/gaia.log 2>&1 &

echo "${LOG_PREFIX}waiting for starting rpc server"
while true 
do
    lsof -i tcp:26650 | grep LISTEN > /dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 1
done

sleep 5

${POLY_HOME}/bin/gaia_transfer.sh $cosmos_key_pwd cosmos17ud4tm64emwfrlgq0aafhguxajtc7w4gseapra cosmos1nztkr7cvp6cvq4s9apyu4emayw0e3trl68gj3f 10000stake ${POLY_HOME}
if [ $? -ne 0 ]
then
    echo "failed to transfer stake to relayer"
    exit 1
fi

echo "${BORDER} done ${BORDER}"
echo