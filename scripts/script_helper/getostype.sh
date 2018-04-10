#!/bin/bash
# sub-script
# run on controller only

# this script will generate configuration file for a rongcloud component
# format:
# genconf.sh IPAddress component

# environment variable ${script_home} defined in entry script deploy_mgr.sh
if [ -f /etc/os-branch ]; then
   osid=`cat /etc/os-branch | awk -F "=" '/^ID=/{print $2}'`
   verid=`cat /etc/os-branch | awk -F "=" '/^VERSION_ID=/{print $2}'`
   verid=${verid//\"/}
   echo -e "${osid//\"/}${verid%.*}"
elif [ -f /etc/redhat-branch ]; then
   verid=`cat /etc/redhat-branch | awk '{match($0,/([0-9]+.[0-9]*)/,str);print str[0]}'`
   echo -e "redhat${verid%.*}"
fi
