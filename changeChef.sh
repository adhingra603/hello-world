#!/usr/local/bin/bash
echo "Changing to ${1^^}"
rm .chef
ln -s .chef-${1^^} .chef
knife status
