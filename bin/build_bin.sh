#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="---------------------BUILDING: "

# commits
export POLY_CMT=8083385c9933af59c22f64042cc4850181045096
export ONT_RELAYER=04a071ce01f98678fe1e9b75e3ac73b43301fba6
export ETH_RELAYER=84d43bdd64f60f7278a02a85454941b9aef10674
export BTC_RELAYER=c0f8dde8d4cb6c18becd6070382113d36fa56794
export BTC_VENDOR=3b19a5fd76664a7d7c811956f582effcf937810f
export GAIA_DEMO=d7bdccddca7b01efeabeaa5a7adbacfe75732001
export COSMOS_RELAYER=2287164b4bd99a175dd6e7a90c848173d850ea38
export TEST_CMT=8cf514b0775052939ea0e69bf19e90f135ecb612

# install tools 
if [ ! -x "$(command -v expect)" ]
then
    echo 'Install expect for you...' >&2
    os_name=`uname`
    if [ $os_name = 'Darwin' ]
    then
        if [ ! -x "$(command -v brew)" ]
        then
            echo "no brew is installed, please install brew first. "
            exit 1
        fi
        brew install expect >> /dev/null
        if [ $? -ne 0 ]
        then
            echo "failed to install expect"
            exit 1
        fi
    elif [ $os_name = 'Linux' ]
    then
        if [ -x "$(command -v apt-get)" ]
        then
            apt-get install -y expect >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "failed to install expect"
                exit 1
            fi
        elif [ -x "$(command -v yum)" ]
        then
            yum install -y expect >> /dev/null
            if [ $? -ne 0 ]
            then
                echo "failed to install expect"
                exit 1
            fi
        else
            echo "no yum or apt-get, install expect yourself please. "
            exit 1
        fi
    else
        echo "os not support"
        exit 1
    fi
fi

# make dirs
mkdir -p ${POLY_HOME}/.code/polynetwork
mkdir -p ${POLY_HOME}/.code/ontio
mkdir -p ${POLY_HOME}/.code/zouxyan

# bitcoind
cd ${POLY_HOME}/.code
if [ ! -d ./bitcoin-0.19.1 ]
then
    wget https://bitcoincore.org/bin/bitcoin-core-0.19.1/bitcoin-0.19.1-x86_64-linux-gnu.tar.gz
fi
tar -zxf bitcoin-0.19.1-x86_64-linux-gnu.tar.gz
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to extract bitcoin"
    exit 1
fi
cp -R bitcoin-0.19.1/* ${POLY_HOME}/lib/bitcoin
echo "${LOG_PREFIX}bitcoin built"

# ethereum
cd ${POLY_HOME}/.code/
if [ ! -d ./go-ethereum ]
then
    git clone https://github.com/ethereum/go-ethereum.git
fi
cd go-ethereum
git checkout v1.9.15
make
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build ethereum"
    exit 1
fi
mv build/bin/geth ${POLY_HOME}/lib/geth/
echo "${LOG_PREFIX}ethereum built"

# ontology
cd ${POLY_HOME}/.code/ontio
if [ ! -d ./ontology ]
then
    git clone https://github.com/ontio/ontology.git
fi
cd ontology
make
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build ontology"
    exit 1
fi
mv ontology ${POLY_HOME}/lib/ontology/
echo "${LOG_PREFIX}ontology built"

# poly
cd ${POLY_HOME}/.code/ontio/
if [ ! -d ./poly ]
then
    git clone https://github.com/polynetwork/poly.git
fi
cd poly
git reset --hard $POLY_CMT
make
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build poly"
    exit 1
fi
mv poly ${POLY_HOME}/lib/poly/
echo "${LOG_PREFIX}poly built"

# gaia-demo
cd ${POLY_HOME}/.code/
if [ ! -d ./gaia-demo ]
then
    git clone https://github.com/skyinglyh1/gaia-demo.git
fi
cd gaia-demo/cmd/gaiad/
git reset --hard $GAIA_DEMO
go build
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build gaiad"
    exit 1
fi
mv gaiad ${POLY_HOME}/lib/gaia/

cd ${POLY_HOME}/.code/gaia-demo/cmd/gaiacli/
go build
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build gaiacli"
    exit 1
fi
mv gaiacli ${POLY_HOME}/lib/gaia/
echo "${LOG_PREFIX}gaia built"

# prepare local code resource for go.mod
cd ${POLY_HOME}/.code/polynetwork/
if [ ! -d ./btc-vendor-tools ]
then
    git clone https://github.com/polynetwork/btc-vendor-tools.git
fi
if [ ! -d ./poly-go-sdk ]
then
    git clone https://github.com/polynetwork/poly-go-sdk.git
fi
if [ ! -d ./ontology-go-sdk ]
then
    git clone https://github.com/ontio/ontology-go-sdk.git
fi

# btctool
cd ${POLY_HOME}/.code/zouxyan
if [ ! -d ./btctool ]
then
    git clone https://github.com/zouxyan/btctool.git
fi
cd btctool/cmd 
go build -o btctool main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build btctool"
    exit 1
fi
mv btctool ${POLY_HOME}/lib/tools/
echo "${LOG_PREFIX}btctool built"

# relayer btc
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./btc-relayer ]
then
    git clone https://github.com/polynetwork/btc-relayer.git
fi
cd btc-relayer/cmd
git reset --hard $BTC_RELAYER
go build -o run_btc_relayer run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build btc relayer"
    exit 1
fi
mv run_btc_relayer ${POLY_HOME}/lib/relayer_btc
echo "${LOG_PREFIX}btc relayer built"

# relayer eth
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./eth-relayer ]
then
    git clone https://github.com/polynetwork/eth-relayer.git
fi
cd eth-relayer
git reset --hard $ETH_RELAYER
go build -o run_eth_relayer main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build eth relayer"
    exit 1
fi
mv run_eth_relayer ${POLY_HOME}/lib/relayer_eth/
echo "${LOG_PREFIX}eth relayer built"

# relayer ont
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./ont-relayer ]
then
    git clone https://github.com/polynetwork/ont-relayer.git
fi
cd ont-relayer
git reset --hard $ONT_RELAYER
go build -o run_ont_relayer main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build ont relayer"
    exit 1
fi
mv run_ont_relayer ${POLY_HOME}/lib/relayer_ont/
echo "${LOG_PREFIX}ont relayer built"

# relayer gaia
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./cosmos-relayer ]
then
    git clone https://github.com/polynetwork/cosmos-relayer.git
fi
cd cosmos-relayer
git reset --hard $COSMOS_RELAYER
go build -o run_gaia_relayer cmd/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build gaia relayer"
    exit 1
fi
mv run_gaia_relayer ${POLY_HOME}/lib/relayer_gaia/
echo "${LOG_PREFIX}gaia relayer built"

# btc vendors
cd ${POLY_HOME}/.code/polynetwork
cd btc-vendor-tools
git reset --hard $BTC_VENDOR
go build -o run_vendor cmd/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build vendor tool"
    exit 1
fi
mv run_vendor ${POLY_HOME}/lib/vendor_tool/
echo "${LOG_PREFIX}vendor tool built"

# tools: 
cd ${POLY_HOME}/.code/polynetwork
if [ ! -d ./poly-io-test ]
then
    git clone https://github.com/polynetwork/poly-io-test.git
fi
cd poly-io-test
git reset --hard $TEST_CMT
go build -o btc_prepare cmd/btc_prepare/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build btc_prepare"
    exit 1
fi
go build -o ont_deployer cmd/ont_deployer/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build ont_deployer"
    exit 1
fi
go build -o eth_deployer cmd/eth_deployer/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build eth_deployer"
    exit 1
fi
go build -o cosmos_prepare cmd/cosmos_prepare/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build cosmos_prepare"
    exit 1
fi
go build -o side_chain_mgr cmd/tools/run.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build side_chain_mgr"
    exit 1
fi
go build -o cctest cmd/cctest/main.go
if [ $? -ne 0 ]
then
    echo "${LOG_PREFIX}failed to build cctest"
    exit 1
fi

mv btc_prepare ${POLY_HOME}/lib/tools/contracts_deployer
mv ont_deployer ${POLY_HOME}/lib/tools/contracts_deployer
mv eth_deployer ${POLY_HOME}/lib/tools/contracts_deployer
mv cosmos_prepare ${POLY_HOME}/lib/tools/contracts_deployer
mv side_chain_mgr ${POLY_HOME}/lib/tools/side_chain_mgr
mv cctest ${POLY_HOME}/lib/tools/test_tool

echo "=============================================="
echo "all built"
echo "=============================================="
