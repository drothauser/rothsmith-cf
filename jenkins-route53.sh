#!/bin/bash

jenkinsZone=$(aws route53 list-hosted-zones-by-name --dns-name "jenkins.rothsmith.net" --max-items 1 | grep '"Id"' | sed "s/^.*\/\(.*\)\"\,/\1/g")

jenkinsElb=$(aws elbv2 describe-load-balancers | grep -i jenkins | grep DNSName | awk '{print $2}' | sed 's/[\"\,]//g')

echo "****** ${jenkinsElb} *****"

jenkinsJson=$(cat ./jenkins-route53.json | sed "s/XXXXXXX/${jenkinsElb}/")

aws route53 change-resource-record-sets --hosted-zone-id $jenkinsZone --change-batch "${jenkinsJson}"
