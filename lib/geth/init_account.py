from web3 import Web3, HTTPProvider
import sys


if __name__ == '__main__':
    if len(sys.argv) != 3:
        print('you need to input the path of private key file')
        sys.exit(1)
    relayer_addr = sys.argv[2].replace('"', '')

    w3 = Web3(HTTPProvider("http://0.0.0.0:8545"))

    if w3.eth.getBalance(relayer_addr) > 0:
        print('relayer ' + relayer_addr + ' already inited')
        exit(0)

    keyfile = open(sys.argv[1])
    acc = w3.eth.account.from_key(keyfile.read())

    gp = w3.eth.gasPrice
    nonce = w3.eth.getTransactionCount(acc.address)
    signed = acc.signTransaction({
        'from': acc.address,
        'to': relayer_addr,
        'value': w3.toWei(1, 'ether'),
        'gasPrice': gp,
        'gas': 200000,
        'nonce': nonce
    })

    tx = w3.eth.sendRawTransaction(signed.rawTransaction)
    print('START_ETH_CHAIN: send 1 ether to ' + relayer_addr + ' and tx hash is 0x' + bytes.hex(tx) + 'waiting for confirmation')
    w3.eth.waitForTransactionReceipt(tx, 600)
