#!/bin/vbash
# Script use to configure Vyos Firewall/Router for SEC-350

# Need to source vyos script commands from this file below
source /opt/vyatta/etc/functions/script-template

# Prevent Script from running without the "vyattacfg" user group permission applied
if [ "$(id -g -n)" != 'vyattacfg' ] ; then
    exec sg vyattacfg -c "/bin/vbash $(readlink -f $0) $@"
fi

configure

# Network Adapter Config
set interfaces ethernet eth0 address '10.0.17.129/24' # change this if it is different
set interfaces ethernet eth0 description 'SEC350-WAN'
set interfaces ethernet eth1 address '172.16.50.2/29'
set interfaces ethernet eth1 description 'SEC350-DMZ'
set interfaces ethernet eth2 address '172.16.150.2/24'
set interfaces ethernet eth2 description 'SEC350-LAN'


# DNS Settings
set system name-server '10.0.17.2'

# Default Gateway
set protocols static route 0.0.0.0/0 next-hop 10.0.17.2

# Set Hostname
set system host-name 'edge01-aidan'

# Apply Initial Network Config
commit


# DNS Forwarding for DMZ and LAN NET
set service dns forwarding allow-from '172.16.50.0/29'
set service dns forwarding allow-from '172.16.150.0/24'
set service dns forwarding listen-address '172.16.50.2'
set service dns forwarding listen-address '172.16.150.2'
set service dns forwarding system

# NAT Config
set nat source rule 10 description 'NAT FROM DMZ to WAN'
set nat source rule 10 outbound-interface 'eth0'
set nat source rule 10 source address '172.16.50.0/29'
set nat source rule 10 translation address 'masquerade'
set nat source rule 11 description 'NAT FROM LAN to WAN'
set nat source rule 11 outbound-interface 'eth0'
set nat source rule 11 source address '172.16.150.0/24'
set nat source rule 11 translation address 'masquerade'
set nat source rule 12 description 'NAT FROM MGMT to WAN'
set nat source rule 12 outbound-interface 'eth0'
set nat source rule 12 source address '172.16.200.0/28'
set nat source rule 12 translation address 'masquerade'

# NAT Forwarding
set nat destination rule 10 description 'HTTP->WEB01'
set nat destination rule 10 destination port '80'
set nat destination rule 10 inbound-interface 'eth0'
set nat destination rule 10 protocol 'tcp'
set nat destination rule 10 translation address '172.16.50.3'
set nat destination rule 10 translation port '80'
set nat destination rule 15 description 'SSH->JUMP'
set nat destination rule 15 destination port '22'
set nat destination rule 15 inbound-interface 'eth0'
set nat destination rule 15 protocol 'tcp'
set nat destination rule 15 translation address '172.16.50.4'
set nat destination rule 15 translation port '22'

# RIP Routing to FW-Mgmt
set protocols rip interface eth2
set protocols rip network '172.16.50.0/29'

# Set SSH Listen Address to LAN only
delete service ssh listen-address '0.0.0.0'
set service ssh listen-address '172.16.150.2'

# Save Configuration
commit
save
exit
