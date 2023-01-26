#!/bin/bash

subdomain="web-public"
if [[ ! -z ${1} ]]; then subdomain="${1,,}"; fi

rothsmithZone=$(aws route53 list-hosted-zones-by-name --dns-name "${subdomain}.rothsmith.net" --max-items 1 --query 'HostedZones[*].Id' --output text | sed 's/\/hostedzone\///g')

rothsmithElb=$(aws elbv2 describe-load-balancers | grep -i "${subdomain}" | grep DNSName | awk '{print $2}' | sed 's/[\"\,]//g')


read -r -d '' CHANGE_BATCH <<-_EOF_
{
    "Comment": "Update Rothsmith hosted zone alias resource record sets in Route 53",
    "Changes": [
        {
            "Action": "UPSERT",
            "ResourceRecordSet": {
                "Name": "${subdomain}.rothsmith.net",
                "Type": "A",
                "AliasTarget": {
                    "HostedZoneId": "Z35SXDOTRQ7X7K",
                    "DNSName": "dualstack.${rothsmithElb}.",
                    "EvaluateTargetHealth": false
                }
            }
        }
    ]
}
_EOF_

echo -e "*********************************************
*  subdomain=${subdomain}
*  rothsmithZone=${rothsmithZone}
*  rothsmithElb=${rothsmithElb}
*  rothsmithJson=
${CHANGE_BATCH}"

COMMAND="aws route53 change-resource-record-sets --hosted-zone-id ${rothsmithZone} --change-batch '${CHANGE_BATCH}'"
echo ${COMMAND}
eval "${COMMAND}"

RC="$?"
echo -e "\nCommand Complete. Return Code = ${RC}"
exit ${RC}