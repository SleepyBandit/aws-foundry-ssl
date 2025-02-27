#!/bin/bash

# ---------------------------------------------------------------
# Set up dynamic DNS and automatic AWS zone ID resolution updates
# ---------------------------------------------------------------

if [[ -z "${fqdn}" ]]; then
    echo "Variable \$fqdn is empty, cannot update AWS without a fully qualified domain name."
    exit 1
fi

zone_id=`aws route53 list-hosted-zones | jq ".HostedZones[] | select(.Name==\"${fqdn}.\") | .Id" | cut -d / -f3 | cut -d '"' -f1`

echo "DNS Zone ID: ${zone_id}"

# If zone_id is set, update it. Otherwise, append it
grep -q "^zone_id=" /foundryssl/variables.sh && sed "s/^zone_id=.*/zone_id=${zone_id}/" -i /foundryssl/variables.sh || sed "$ a\zone_id=${zone_id}" -i /foundryssl/variables.sh

sudo cp /aws-foundry-ssl/setup/aws/dynamic_dns.sh /foundrycron/dynamic_dns.sh
sudo cp /aws-foundry-ssl/setup/aws/dynamic_dns.service /etc/systemd/system/dynamic_dns.service
sudo cp /aws-foundry-ssl/setup/aws/dynamic_dns.timer /etc/systemd/system/dynamic_dns.timer

# Start the timer and set it up for restart support too
sudo systemctl daemon-reload
sudo systemctl enable --now dynamic_dns.timer
