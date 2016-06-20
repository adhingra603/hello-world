#!/bin/bash

export THINSTANCE=$1
export REMOTE_SSH="./remoterootSSH.sh"
export REDEPLOY_SCRIPT="/mnt/autofs/repository/Instances/$1/VMConfigurations/Scripts/redeploy.sh"
export REDEPLOY_CMD="nohup $REDEPLOY_SCRIPT &"

# Change as needed
export PWD="specialK"

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

  #$REMOTE_SSH saas@$ip $PWD "$REDEPLOY_CMD" tmp/$ip.stdout &
  sh -c "$REMOTE_SSH saas@$ip $PWD $REDEPLOY_SCRIPT tmp/$ip.stdout"

done < /dev/stdin
wait

