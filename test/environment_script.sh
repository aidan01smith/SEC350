#!/bin/bash
# Script used to download and remotely run assessment install scripts 

## Pre-Reqs:
# * Basic networking has been configured for nginx01 + dhcp01
# * Local Priv Users successfully created & added to groups
# * Mgmt01 can connect to target systems

# Troubleshooting: Remove old ssh fingerprints
# ssh-keygen -f "/home/michael/.ssh/known_hosts" -R "<IP_of_remote-host_here>"

## Download Script Files and remotely run on target system
ssh -t aidan@172.16.150.5 "wget 'https://raw.githubusercontent.com/aidan01smith/SEC350/refs/heads/main/test/dhcp/dhcp_install.sh' && sudo bash dhcp_install.sh; rm dhcp_install.sh"
ssh -t aidan@172.16.50.3 "wget 'https://raw.githubusercontent.com/aidan01smith/SEC350/refs/heads/main/test/nginx/nginx_install.sh' && sudo bash nginx_install.sh; rm nginx_install.sh"
