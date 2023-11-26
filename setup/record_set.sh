#!/bin/bash

# grab variables
source /foundryssl/variables.sh
client_conf="ddclient.conf"

# install ddclient
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y ddclient

# set ddclient config
sudo sed -i "s/api_key/${api_key}/g" /aws-foundry-ssl/files/ddns/google/${client_conf}
sudo sed -i "s/api_secret/${api_secret}/g" /aws-foundry-ssl/files/ddns/google/${client_conf}
sudo sed -i "s/subdomain/${subdomain}/g" /aws-foundry-ssl/files/ddns/google/${client_conf}
sudo sed -i "s/fqdn/${fqdn}/g" /aws-foundry-ssl/files/ddns/google/${client_conf}

sudo cat /aws-foundry-ssl/files/ddns/google/${client_conf} >> /etc/ddclient.conf

# restart ddclient
sudo systemctl start ddclient
sudo systemctl enable ddclient

sudo ddclient --force
