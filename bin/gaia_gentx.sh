#!/usr/bin/expect
if {$argc < 2} {
    puts "Usage:cmd <password> <poly_home>"
    exit 1
}

set timeout -1
set p1 [lindex $argv 0]
set home_dir [lindex $argv 1]

spawn ${home_dir}/lib/gaia/gaiad gentx --home=${home_dir}/data/gaia/chain/.gaiad --home-client=${home_dir}/data/gaia/chain/.gaiacli --name=cc --keyring-backend=file
expect {
    "*Enter keyring passphrase*" {send "$p1\r"; exp_continue}
    "*Enter keyring passphrase*" {send "$p1\r"; exp_continue}
    "*Enter keyring passphrase*" {send "$p1\r"}
}