@echo off
setlocal

REM nexusZone=$(aws route53 list-hosted-zones-by-name --dns-name "nexus.rothsmith.net" --max-items 1 | grep '"Id"' | sed "s/^.*\/\(.*\)\"\,/\1/g")
set zoneCmd='aws route53 list-hosted-zones-by-name --dns-name ^"nexus.rothsmith.net^" --max-items 1 | findstr ^"\^"Id\^":^"'
FOR /F "tokens=* USEBACKQ" %%F IN (`%zoneCmd%`) DO (
   SET var=%%F
)
ECHO %var%

REM nexusElb=$(aws elbv2 describe-load-balancers | grep -i nexus | grep DNSName | awk '{print $2}' | sed 's/[\"\,]//g')

REM echo "****** ${nexusElb} *****"

set /P nexusJson=<./nexus-route53.json

REM nexusJson=$(cat ./nexus-route53.json | sed "s/XXXXXXX/${nexusElb}/")

REM aws route53 change-resource-record-sets --hosted-zone-id $nexusZone --change-batch "%nexusJson%"
