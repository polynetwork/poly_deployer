#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX='START_ETH_CHAIN: '
BORDER="----------------------------------------------"

echo "${BORDER} start eth chain ${BORDER}"

if [ ! -d ${POLY_HOME}/log/eth ]
then
    mkdir ${POLY_HOME}/log/eth
fi
if [ ! -d ${POLY_HOME}/data/eth/chain ]
then
    mkdir -p ${POLY_HOME}/data/eth/chain
fi

if [ ! -f ${POLY_HOME}/data/eth/chain/geth/chaindata/LOCK ]
then 
    echo "init geth genesis and accounts"
    ${POLY_HOME}/lib/geth/geth init ${POLY_HOME}/lib/geth/genesis.json --datadir ${POLY_HOME}/data/eth/chain/ >> /dev/null 2>&1 & 
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}failed to init eth chain"
        exit 1
    fi

    ${POLY_HOME}/lib/geth/geth account import ${POLY_HOME}/lib/geth/private_key --datadir ${POLY_HOME}/data/eth/chain/ --password ${POLY_HOME}/lib/geth/pwd >> /dev/null
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}failed to import account to geth"
        exit 1
    fi
fi

${POLY_HOME}/lib/geth/geth --rpc --mine --miner.threads 1 --datadir ${POLY_HOME}/data/eth/chain/ --networkid 123 --rpcaddr 0.0.0.0 --rpcvhosts "*" --ethash.dagdir ${POLY_HOME}/data/eth/chain/ethash/ --nodiscover >> ${POLY_HOME}/log/eth/eth_chain.log 2>&1 &
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to start eth chain"
    exit 1
else
    echo "${LOG_PREFIX}successful to start eth chain: ( rpc address: http://0.0.0.0:8545, coinbase address: 0x5cD3143f91a13Fe971043E1e4605C1c23b46bF44 )"
fi

pip3 show web3 >> /dev/null
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}install web3.py now"
    pip3 install web3 >> /dev/null
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}no python-pip installed, please install python3 and pip"
    fi
fi

if [ ! -x "$(command -v jq)" ]
then
    echo "${LOG_PREFIX}install jq now"
    os_name=`uname`
    if [ $os_name = 'Darwin' ]
    then
        if [ ! -x "$(command -v brew)" ]
        then
            echo "no brew is installed, please install brew first. "
            exit 1
        fi
        brew install jq >> /dev/null
        if [ $? -ne 0 ]
        then
            echo "${LOG_PREFIX}failed to install jq"
            exit 1
        fi
    elif [ $os_name = 'Linux' ]
    then
        if [ -x "$(command -v apt-get)" ]
        then
            apt-get install -y jq >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "${LOG_PREFIX}failed to install jq"
                exit 1
            fi
        elif [ -x "$(command -v yum)" ]
        then
            yum install -y jq >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "${LOG_PREFIX}failed to install jq"
                exit 1
            fi
        else
            echo "${LOG_PREFIX}no yum or apt-get, install jq yourself please. "
            exit 1
        fi
    else
        echo "os not support"
        exit 1
    fi
fi

while true 
do
    lsof -i tcp:8545 | grep LISTEN > /dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    sleep 1
done

relayer_addr="0xB7Ee265D94446F465dba65002A9960D4bef9dca7"
python3 ${POLY_HOME}/lib/geth/init_account.py ${POLY_HOME}/lib/geth/private_key ${relayer_addr}
 
echo "${BORDER} start eth chain done ${BORDER}"
echo
