#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
DEPLOYER_HOME=${POLY_HOME}/lib/tools/contracts_deployer
LOG_PREFIX="DEPLOY AND SETUP CONTRACTS: "
BORDER="----------------------------------------------"

echo "${BORDER} start to deploy and setup contracts ${BORDER}"

# update vendor_tool.json
vendor_conf_file="${POLY_HOME}/lib/vendor_tool/vendor_tool.json"
poly_wallet="${POLY_HOME}/lib/poly/wallet.dat"
db_path="${POLY_HOME}/data/btc/vendor/"
cat ${vendor_conf_file} | jq .WalletFile="\"${poly_wallet}\"" | jq .ConfigDBPath="\"${db_path}\"" > ${vendor_conf_file}1
mv ${vendor_conf_file}1 ${vendor_conf_file}
if [ ! -d ${db_path} ]
then
    mkdir -p ${db_path}
fi

# update tools config.json
conf_file="${POLY_HOME}/lib/tools/config.json"
btc_privk_path="${POLY_HOME}/lib/vendor_tool/btcprivk"
ont_wallet="${POLY_HOME}/lib/ontology/wallet.dat"
avm_path="${POLY_HOME}/lib/tools/contracts_deployer/ont_avm"
report_path="${POLY_HOME}/log/test_tool/report"
cosmos_key_path="${POLY_HOME}/lib/gaia/cosmos_key"
cat ${conf_file} | jq .BtcEncryptedPrivateKeyFile="\"${btc_privk_path}\"" | jq .BtcVendorSigningToolConfFile="\"${vendor_conf_file}\"" | jq .OntWallet="\"${ont_wallet}\"" | jq .OntContractsAvmPath="\"${avm_path}\"" | jq .RCWallet="\"${poly_wallet}\"" | jq .ReportDir="\"${report_path}\"" | jq .CMWalletPath="\"${cosmos_key_path}\"" > ${conf_file}1
mv ${conf_file}1 ${conf_file}
if [ ! -d ${report_path} ]
then
    mkdir -p ${report_path}
fi

echo "${LOG_PREFIX}start to deploy contracts"
${DEPLOYER_HOME}/ont_deployer -func deploy -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to deploy ont contracts"
    exit 1
fi
sleep 1

${DEPLOYER_HOME}/eth_deployer -func deploy -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to deploy eth contracts"
    exit 1
fi
sleep 1

${DEPLOYER_HOME}/btc_prepare -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to prepare btc"
    exit 1
fi
sleep 1

${DEPLOYER_HOME}/cosmos_prepare -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to prepare cosmos"
    exit 1
fi
sleep 1

echo "${LOG_PREFIX}start to setup contracts"
${DEPLOYER_HOME}/ont_deployer -func setup -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to setup ont contracts"
    exit 1
fi
sleep 1

${DEPLOYER_HOME}/eth_deployer -func setup -conf ${POLY_HOME}/lib/tools/config.json
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to setup eth contracts"
    exit 1
fi

echo "${BORDER} done ${BORDER}"
echo