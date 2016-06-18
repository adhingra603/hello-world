#!/bin/bash

THINSTANCE=$1
REMOTE_SSH="./remoterootSSH.sh"
REDEPLOY_SCRIPT="/usr/bin/whoami"

# Change as needed
PWD="specialK"

usage() {
cat << EOF
    Usage: $0 <thinstance_name>
EOF
exit
}

# Validate thinstance
if [ $# -ne 1 ]
then
   usage
fi

#
# Main loop
#

while read ip
do

  echo "** $ip"
  echo "-------------------------------------------------------------------------"
  echo "HOT DEPLOY TO $ip"
  echo "-------------------------------------------------------------------------"

  $REMOTE_SSH saas@$ip $PWD $REDEPLOY_SCRIPT tmp/$ip.stdout &

done < /dev/stdin
wait

