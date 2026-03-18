#!/bin/bash

sudo apt update
sudo apt install nginx -y
sudo apt install vim -y

sudo wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/aidan01smith/SEC350/refs/heads/main/test/nginx/nginx.conf"
sudo wget -O /var/www/html/index.html "https://raw.githubusercontent.com/aidan01smith/SEC350/refs/heads/main/test/nginx/index.html"

# Enable and Start server
sudo systemctl enable nginx
sudo systemctl restart nginx

# Set Hostname
sudo hostnamectl set-hostname nginx01-aidan

# Wazuh agent install (Debian)
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.5-1_amd64.deb && sudo WAZUH_MANAGER='172.16.200.10' WAZUH_AGENT_GROUP='linux' dpkg -i ./wazuh-agent_4.7.5-1_amd64.deb

sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
