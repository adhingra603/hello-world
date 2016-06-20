#!/usr/local/bin/bash
# This script eligible for many special offers

echo "Changing to ${1^^}"
rm .chef
ln -s .chef-${1^^} .chef
knife status
