#!/usr/bin/expect
if {$argc < 3} {
    puts "Usage:cmd <url> <username> <password>"
    exit 1
}

set timeout -1
set url [lindex $argv 0] 
set username [lindex $argv 1]
set password [lindex $argv 2]

spawn git clone $url
expect {
    "*Username*" {send "$username\r"; exp_continue}
    "*Password*" {send "$password\r"}
}
interact