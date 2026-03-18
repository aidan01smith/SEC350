#!/bin/vbash
# Script use to configure Vyos Firewall Rules for SEC-350 Edge02

# Need to source vyos script commands from this file below
source /opt/vyatta/etc/functions/script-template

# Prevent Script from running without the "vyattacfg" user group permission applied
if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

# Configuration commands go here VVV
configure

# Configure Firewall Zones for DMZ, LAN, and WAN
set zone-policy zone WAN interface eth0
set zone-policy zone DMZ interface eth1
set zone-policy zone LAN interface eth2

# Apply Config
commit

# Configure Firewall Rules

## DMZ-to-LAN
set firewall name DMZ-to-LAN default-action drop
set firewall name DMZ-to-LAN enable-default-log

set firewall name DMZ-to-LAN rule 1 action 'accept'
set firewall name DMZ-to-LAN rule 1 description 'Allow outbound Established traffic to LAN'
set firewall name DMZ-to-LAN rule 1 state established 'enable'

set firewall name DMZ-to-LAN rule 10 action 'accept'
set firewall name DMZ-to-LAN rule 10 description 'wazuh agent comms with wazuh server'
set firewall name DMZ-to-LAN rule 10 destination address '172.16.200.10'
set firewall name DMZ-to-LAN rule 10 destination port '1514,1515'
set firewall name DMZ-to-LAN rule 10 protocol 'tcp'

## DMZ-to-WAN
set firewall name DMZ-to-WAN default-action drop
set firewall name DMZ-to-WAN enable-default-log

set firewall name DMZ-to-WAN rule 1 action 'accept'
set firewall name DMZ-to-WAN rule 1 description 'Allow outbound Established traffic to WAN'
set firewall name DMZ-to-WAN rule 1 state established 'enable'

set firewall name DMZ-to-WAN rule 999 action 'accept'
set firewall name DMZ-to-WAN rule 999 description 'Allow Jump to WAN'
set firewall name DMZ-to-WAN rule 999 disable
set firewall name DMZ-to-WAN rule 999 source address '172.16.50.4'

## LAN-to-DMZ
set firewall name LAN-to-DMZ default-action drop
set firewall name LAN-to-DMZ enable-default-log

set firewall name LAN-to-DMZ rule 1 action 'accept'
set firewall name LAN-to-DMZ rule 1 description 'Allow outbound Established traffic to DMZ'
set firewall name LAN-to-DMZ rule 1 state established 'enable'

set firewall name LAN-to-DMZ rule 10 action 'accept'
set firewall name LAN-to-DMZ rule 10 description 'Allow LAN HTTP to Web01'
set firewall name LAN-to-DMZ rule 10 destination address '172.16.50.3'
set firewall name LAN-to-DMZ rule 10 destination port '80'
set firewall name LAN-to-DMZ rule 10 protocol 'tcp'

set firewall name LAN-to-DMZ rule 11 action 'accept'
set firewall name LAN-to-DMZ rule 11 description 'Allow LAN to DMZ SSH from Mgmt01'
set firewall name LAN-to-DMZ rule 11 destination port '22'
set firewall name LAN-to-DMZ rule 11 protocol 'tcp'
set firewall name LAN-to-DMZ rule 11 source address '172.16.150.10'

## LAN-to-WAN
set firewall name LAN-to-WAN default-action drop
set firewall name LAN-to-WAN enable-default-log

set firewall name LAN-to-WAN rule 1 action 'accept'

## WAN-to-DMZ
set firewall name WAN-to-DMZ default-action drop
set firewall name WAN-to-DMZ enable-default-log

set firewall name WAN-to-DMZ rule 1 action 'accept'
set firewall name WAN-to-DMZ rule 1 description 'Allow established WAN connections to DMZ'
set firewall name WAN-to-DMZ rule 1 state established 'enable'

set firewall name WAN-to-DMZ rule 10 action 'accept'
set firewall name WAN-to-DMZ rule 10 description 'Allow HTTP from WAN to DMZ'
set firewall name WAN-to-DMZ rule 10 destination address '172.16.50.3'
set firewall name WAN-to-DMZ rule 10 destination port '80'
set firewall name WAN-to-DMZ rule 10 protocol 'tcp'

set firewall name WAN-to-DMZ rule 15 action 'accept'
set firewall name WAN-to-DMZ rule 15 description 'Allow SSH from WAN to JUMP'
set firewall name WAN-to-DMZ rule 15 destination address '172.16.50.4'
set firewall name WAN-to-DMZ rule 15 destination port '22'
set firewall name WAN-to-DMZ rule 15 protocol 'tcp'

## WAN-to-LAN
set firewall name WAN-to-LAN default-action drop
set firewall name WAN-to-LAN enable-default-log

set firewall name WAN-to-LAN rule 1 action 'accept'
set firewall name WAN-to-LAN rule 1 description 'Allow established WAN connections to LAN'
set firewall name WAN-to-LAN rule 1 state established 'enable'

# Assign Firewalls Rules to Firewall Zones

## DMZ Zone Rules
set zone-policy zone DMZ from LAN firewall name 'LAN-to-DMZ'
set zone-policy zone DMZ from WAN firewall name 'WAN-to-DMZ'

## LAN Zone Rules
set zone-policy zone LAN from DMZ firewall name 'DMZ-to-LAN'
set zone-policy zone LAN from WAN firewall name 'WAN-to-LAN'

## WAN Zone Rules
set zone-policy zone WAN from DMZ firewall name 'DMZ-to-WAN'
set zone-policy zone WAN from LAN firewall name 'LAN-to-WAN'

# Save Configuration
commit
save
exit
