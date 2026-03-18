#!/bin/bash

# to install dhcp and wazuh onto the dhcp box for the assessment

# update and install everything
sudo apt update
sudo apt install isc-dhcp-server -y
sudo apt install vim -y

# download the dhcp config
sudo wget -o /etc/dhcp/dhcpd.conf "https://raw.githubusercontent.com/aidan01smith/SEC350/refs/heads/main/test/dhcp/dhcpd.conf"

# restart the dhcp service
sudo systemctl enable isc-dhcp-server
sudo systemctl disable isc-dhcp-server6
sudo systemctl restart isc-dhcp-server

# set the hostname
sudo hostnamectl set-hostname dhcp01-aidan

# install wazuh for debian (if this doesn't work, go back to previous lab to fix or just use their official install guide
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb && sudo WAZUH_MANAGER='172.16.200.10' WAZUH_AGENT_GROUP='linux' dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
