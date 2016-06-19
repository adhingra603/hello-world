#!/usr/bin/expect

#
# Usage: remoteSSH.sh <user@ip_addr> <pwd> <remote script>
#

set ip [lindex $argv 0]
set pwd [lindex $argv 1]
set script [lindex $argv 2]

# This will change depending on the machines you are logging into.
set prompt "*?bash"

# Timeout in seconds for all expect commands, including target script
set timeout 60

# Start script
spawn ssh $ip
expect "yes/no" { 
    send "yes\r"
    expect "*?assword" { send "$pwd\r" }
    } "*?assword" { send "$pwd\r" }
 
expect "$prompt" { send "$script\r" }
expect "$prompt" { send "exit\r" }


#----------------
# Below is a more elegant solution, can't get the prompt to match
#----------------

# set ip [lindex $argv 0]
# set pwd [lindex $argv 1]
# set script [lindex $argv 2]

# set prompt "*?bash"

# spawn ssh $ip

# set timeout 60
# expect {
#     timeout {
#         puts "Connection timed out"
#         exit 1
#     }

#     "yes/no" {
#         send "yes\r"
#         exp_continue
#     }

#     "assword:" {
#         send "$pwd\r"
#         exp_continue
#     }

#     "*?bash" {
#         send "$script\r"
#     }
# }

