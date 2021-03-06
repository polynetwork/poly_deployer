<h1 align="center">Poly Deployer</h1>
<h4 align="center">Version 1.0 </h4> 

## 介绍

poly deployer实现了跨链环境的一键部署，实现了从代码下载编译、启动多条链及Relayer、合约部署设置到账户配置的所有流程，启动完成后，可以使用附带的工具发送跨链交易，使用者还可以根据需求进行自己的测试。

目前支持macOS和Linux的单节点环境，包含比特币、以太坊、本体、GAIA（demo）的跨链，使用的是我们提供的智能合约。

## 使用

首先，克隆代码到本地。

```
git clone https://github.com/polynetwork/poly_deployer.git
```

共包含四个目录：

- lib：包含所有程序的配置文件、钱包文件，编译后的可执行文件都放在对应路径下；
- bin：包含所有的shell脚本，实现了各个流程；
- data：存储所有链、工具的数据；
- log：存储所有日志；

运行bin目录下的`build_bin.sh`，自动下载相关工具及代码至./.code目录下，编译代码后放到指定位置。

然后，运行bin目录下的`start-all.sh`启动所有相关进程，比如比特币、以太坊等。

成功运行后，通过`bin/status.sh`检查进程是否启动正常，如果有问题可以在log目录下查看对应日志。如无问题，整个跨链环境就准备好了，可以发送跨链交易了。

若成功启动，可以通过运行命令`lib/tools/test_tool -cfg lib/tools/config.json -t ${case_name}`来测试跨链，日志会显示当前交易状态，直到成功。

`case_name`可以在[代码](https://github.com/polynetwork/poly-io-test/blob/8cf514b0775052939ea0e69bf19e90f135ecb612/testcase/init.go#L25)中查看，比如case：`SendOntToEthChain`ONT从本体跨链到以太坊。

各个节点会启动在本地`0.0.0.0`地址，比如以太坊geth启动在`8545`，所以需要确保端口无冲突。

## 问题

目前没在所有环境上做过充分的测试，可能会有缺少依赖包的问题。

**工具主要依赖有：go 1.14、python3.6以上、web3.py、jq、expect、 gtk+-3.0、pkg-config、gcc等，可以提前自行安装好。**