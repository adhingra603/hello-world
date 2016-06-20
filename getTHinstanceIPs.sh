#!/bin/bash

# Script to get IPs of VMs in a THinstance
# Author: Ryan Bradley - DevOps EAG
# This script requires the Azure CLI

THINSTANCE=$1

usage() {
cat << EOF
    Usage: $0 <thinstance_name>
EOF
exit
}

# Check if Azure CLI is installed
which -s azure
if [ $? -ne 0 ]
then
    echo "Please install the azure cli to use this tool"
    exit
fi

# Check if user passed an option
if [ $# -eq 0 ]
then
    usage
fi

nics=($(azure resource list "${THINSTANCE}" -r Microsoft.Network/networkInterfaces --json | jq -r '.[] | .name'))

for vm in "${nics[@]}"
do
    ip=$(azure network nic show -g "${THINSTANCE}" -n "${vm}" --json | jq -r '.ipConfigurations[0].privateIPAddress')
    echo "${vm%-*} -- $ip"
done