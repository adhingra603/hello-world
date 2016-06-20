#!/bin/bash
# New branch

# Script to fetch logs from a THinstance
# Author: Ryan Bradley - DevOps EAG
# This script requires the Azure CLI

# Colors for pretty printing
grn=$'\e[1;32m'
end=$'\e[0m'

USER=saas
LOGS=/apps/tomcat/logs/
# Microsoft Azure Enterprise Subscription
SUBSCRIPTION=abf8b58f-21ec-4190-95ab-65489017d417
# Production
#SUBSCRIPTION=d081d6ba-98be-4aff-a971-0e8b8328ef0c

# Check if user passed any options
if [ $# -eq 0 ]
then
    echo "No options specified"
    exit
fi

# Check if Azure CLI is installed
which -s azure
if [ $? -ne 0 ]
then
    echo "Please install the azure cli to use this tool"
    exit
else
    echo -e "Setting Azure subscriptoin to: ${SUBSCRIPTION}\n"
    azure account set ${SUBSCRIPTION} &> /dev/null
fi

# TODO - add option to pass Azure Subscription

function usage()
{
cat << EOF
Usage: $0 [OPTIONS]
Example: ./getTHinstanceLogs.sh -n <thinstance> -p <password> [-t runtime|adaptive|clientservices|platform|reporting|services]

OPTIONS:
-h  Show help
-n  Name of THinstance (resource group)
-p  User Password
-t  VM type to get logs from. Default is set to ALL machines

EOF
}

#function getIP() {
#    azure network nic show -g ${THINSTANCE} -n ${i}"-Nic" --json | jq -r '.ipConfigurations[0].privateIPAddress'
#}

# Get script options
while getopts ':n:p::t::h' options
do
    case ${options} in
        h) usage
           exit ;;
        n) THINSTANCE=$OPTARG ;;
        p) PASSWORD=$OPTARG ;;
        t) TYPE=$(echo "$OPTARG" | tr '[:upper:]' '[:lower:]') ;;
        \?) echo "Uknown option: -$OPTARG" >&2
            exit 1 ;;
        :) echo "Option -$OPTARG requires an argument" >&2
           exit 1 ;;
    esac
done

if [ -z "$THINSTANCE" ] || [ -z "$PASSWORD" ]
then
    usage
    exit
fi

case ${TYPE} in

    all|"")
        TYPE="all"
        echo "Getting logs for all machines in THinstance: ${THINSTANCE}"
        vms=($(azure resource list ${THINSTANCE} -r Microsoft.compute/virtualMachines --json | jq -r '.[] | .name' | grep -iv spark))
        ;;
    idm|runtime|services|platform|reporting)
        echo "Getting logs for ${TYPE} machines in THinstance: ${THINSTANCE}"
        vms=($(azure resource list ${THINSTANCE} -r Microsoft.compute/virtualMachines --json | jq -r '.[] | .name' | grep -i ${TYPE} | grep -iv client))
        ;;
    clientservices)
        echo "Getting logs for ${TYPE} machines in THinstance: ${THINSTANCE}"
        vms=($(azure resource list ${THINSTANCE} -r Microsoft.compute/virtualMachines --json | jq -r '.[] | .name' | grep -i ${TYPE}))
        ;;
    spark)
        LOGS=/apps/spark/logs/
        vms=($(azure resource list ${THINSTANCE} -r Microsoft.compute/virtualMachines --json | jq -r '.[] | .name' | grep -i ${TYPE}))
        ;;
esac

# Create list of internal IPs of each VM in the THinstance
IPs=()
for i in "${vms[@]}"
do
    echo "Getting IP for: ${i}"
    IPs+=($(azure network nic show -g ${THINSTANCE} -n ${i}"-Nic" --json | jq -r '.ipConfigurations[0].privateIPAddress'))
done

# Create folder for logs in current directory
date=$(date +%m-%d-%y)
DIR=`pwd`/${THINSTANCE}_${date}
mkdir ${DIR}

# scp the logs from each VM in the THinstance to the local machine
echo "${grn}Saving log files to:  $DIR${end}"
for i in "${!IPs[@]}"
do
    MACHINE=${vms[$i]}-${IPs[$i]}
    echo "Collecting logs from:" ${MACHINE}
    /usr/bin/expect << EOF
    log_user 0
    spawn ssh -oStrictHostKeyChecking=no -oCheckHostIP=no ${USER}@${IPs[$i]}
    expect "assword: "
    send "${PASSWORD}\n"
    expect {
    "assword: " { puts "Bad username or password"; exit}
    "$ "
    }
    send "sudo su -\n"
    expect "# "
    
    send "cd ${LOGS}\n"
    expect "# "
    send "tar cf ${MACHINE}.tar *\n"
    expect "# "
    send "gzip ${MACHINE}.tar\n"
    expect "# "
    send "mv ${MACHINE}.tar.gz /tmp/\n"
    expect "# "
    send "chown saas:saas /tmp/${MACHINE}.tar.gz\n"
    expect "# "
    send "exit\n"
    expect "$ "
    send "exit\n"

    spawn scp -C -oStrictHostKeyChecking=no -oCheckHostIP=no ${USER}@${IPs[$i]}:/tmp/${MACHINE}.tar.gz ${DIR}/
    expect "assword: "
    send "${PASSWORD}\n"
    expect {
    "assword: " { puts "Bad username or password"; exit}
    "$ "
    }
EOF
done
