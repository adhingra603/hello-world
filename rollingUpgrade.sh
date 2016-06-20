#!/bin/bash

# Performs a rolling upgrade by SSH'ing into component VM's, and executing
# the hotdeploy.sh script
#
# Guidelines for use:
# - change WARS symlink to new version
# - fetch the IP's for the systems to update
# - edit script below
# - make sure you set pwd correctly

REMOTE_SSH="./remoteSSH.sh"
# Change as needed
PWD="w3Wi11r0c2y0U7oc8u"
REDEPLOY_SCRIPT="/apps/tomcat/bin/hotdeploy.sh"

# Execute hotdeploy.sh on Services hosts
echo "-------------------------------------------------------------------------"
echo "HOT DEPLOY TO SERVICES"
echo "-------------------------------------------------------------------------"

# $REMOTE_SSH saas@10.202.40.19 $PWD $REDEPLOY_SCRIPT
# echo -e "\n\n"

# $REMOTE_SSH saas@10.202.40.24 $PWD $REDEPLOY_SCRIPT
# echo -e "\n\n"

# Execute hotdeploy.sh on RT hosts
echo "-------------------------------------------------------------------------"
echo "HOT DEPLOY TO RUNTIME"
echo "-------------------------------------------------------------------------"

# $REMOTE_SSH saas@10.202.40.30 $PWD $REDEPLOY_SCRIPT
# echo -e "\n\n"

# $REMOTE_SSH saas@10.202.40.31 $PWD $REDEPLOY_SCRIPT
# echo -e "\n\n"

$REMOTE_SSH saas@10.202.40.32 $PWD $REDEPLOY_SCRIPT
echo -e "\n\n"

$REMOTE_SSH saas@10.202.40.33 $PWD $REDEPLOY_SCRIPT
echo -e "\n\n"
