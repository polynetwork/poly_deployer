#!/usr/bin/expect
if {$argc < 3} {
    puts "Usage:cmd <password> <side_chainid> <poly_home>"
    exit 1
}

set timeout -1
set p1 [lindex $argv 0] 
set id [lindex $argv 1] 
set home_dir [lindex $argv 2] 

spawn ${home_dir}/lib/gaia/gaiad config-genesis-file 1000000000stake cc ${home_dir}/lib/gaia/cosmos_key ${id} 
# --home=${home_dir}/data/gaia/chain/.gaiad --home-client=${home_dir}/data/gaia/chain/.gaiacli 
expect {
    "*Enter passphrase to decrypt your key*" {send "$p1\r"; exp_continue}
    "*Enter keyring passphrase*" {send "$p1\r"; exp_continue}
    "*Re-enter keyring passphrase*" {send "$p1\r"}
}
expect eof