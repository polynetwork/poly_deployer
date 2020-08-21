#!/usr/bin/expect
if {$argc < 5} {
    puts "Usage:cmd <password> <from_addr> <to_addr> <amount> <home_dir>"
    exit 1
}

set timeout -1
set p1 [lindex $argv 0]
set from [lindex $argv 1]
set to [lindex $argv 2]
set amt [lindex $argv 3]
set home_dir [lindex $argv 4] 

spawn ${home_dir}/lib/gaia/gaiacli tx send $from $to $amt --chain-id=cc-cosmos --home=${home_dir}/data/gaia/chain/.gaiacli --node=tcp://localhost:26650 --keyring-backend=file --gas-prices=0.00001stake
expect {
    "*Enter keyring passphrase*" {send "$p1\r"; exp_continue}
    "*confirm transaction before signing and broadcasting*" {send "y\r"; exp_continue}
    "*Enter keyring passphrase*" {send "$p1\r"}
}