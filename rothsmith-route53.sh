#!/bin/bash

#rothsmithZone=$(aws route53 list-hosted-zones-by-name --dns-name "rothsmith.net" --max-items 1 | grep '"Id"' | sed "s/^.*\/\(.*\)\"\,/\1/g")

rothsmithZone=$(aws route53 list-hosted-zones-by-name --dns-name "rothsmith.net" --max-items 1 --query 'HostedZones[*].Id' --output text | sed 's/\/hostedzone\///g')

loadBalancerPrefix="web-public"
if [[ ! -z ${1} ]]; then loadBalancerPrefix="${1}"; fi

rothsmithElb=$(aws elbv2 describe-load-balancers | grep -i "${loadBalancerPrefix}" | grep DNSName | awk '{print $2}' | sed 's/[\"\,]//g')
#rothsmithElb=$(aws elbv2 describe-load-balancers --query "LoadBalancers[?starts_with(DNSName,'test')].DNSName" --output text)

rothsmithJson=$(cat ./rothsmith-route53.json | sed "s/XXXXXXX/${rothsmithElb}/")

echo -e "*********************************************
*  rothsmithZone=${rothsmithZone}
*  rothsmithElb=${rothsmithElb}
*  rothsmithJson=
${rothsmithJson}
*
*********************************************"

aws route53 change-resource-record-sets --hosted-zone-id $rothsmithZone --change-batch "${rothsmithJson}"
