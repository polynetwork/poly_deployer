#!/bin/bash
bin=`dirname "${BASH_SOURCE-$0}"`
bin=`cd "$bin"; pwd`
POLY_HOME=`cd "$bin"/..; pwd`
LOG_PREFIX="START VENDOR TOOLS: "
BORDER="----------------------------------------------"

echo "${BORDER} start vendor tools ${BORDER}"

if [ ! -d ${POLY_HOME}/log/btc/vendors ] 
then
    mkdir -p ${POLY_HOME}/log/btc/vendors/
fi

for num in 1 2 3
do
    pid=`ps -ewf | grep ${POLY_HOME}.*run_vendor | grep -v grep | awk '{print $2}'`
    if [ -n "$pid" ]
    then
        echo "${LOG_PREFIX}vendor_tool_${num} already start"
        continue
    fi

    ${POLY_HOME}/lib/vendor_tool/run_vendor --web=0 --polypwd "" --btcpwd "" --config ${POLY_HOME}/lib/vendor_tool/vendor_tool.json_${num} --loglevel 0 >> ${POLY_HOME}/log/btc/vendors/vendor_${num}.log 2>&1 &
    if [ $? -ne 0 ]
    then
        echo "${LOG_PREFIX}failed to start vendor_${num}"
        exit 1
    else
        echo "${LOG_PREFIX}successful to start vendor_${num}"
    fi
done

echo "${BORDER} done ${BORDER}"
echo
