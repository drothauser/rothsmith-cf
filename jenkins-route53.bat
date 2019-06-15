@echo off
setlocal enabledelayedexpansion

for /F "tokens=3 delims=/," %%i in ('aws route53 list-hosted-zones-by-name --dns-name ^"jenkins.rothsmith.net^" --max-items 1 ^| findstr ^"\^"Id\^":^"') do (
   set jenkinsZoneTmp=%%i
   set jenkinsZone=!jenkinsZoneTmp:"=!
)
echo Jenkins Zone = %jenkinsZone%

for /F "tokens=2 delims=:," %%i in ('aws elbv2 describe-load-balancers ^| findstr -i jenkins ^| findstr DNSName') do (
   set jenkinsElbTmp=%%i
   set jenkinsElb=!jenkinsElbTmp:"=!
   set jenkinsElb=!jenkinsElb: =!
)
echo Jenkins ELB = %jenkinsElb%

set /P jenkinsJsonRaw=<./jenkins-route53.json

set jenkinsJson=!jenkinsJsonRaw:XXXXXXX=%jenkinsElb%!
echo Route53 JSON = !jenkinsJson!
echo !jenkinsJson! > %TEMP%\jenkinsRoute53.json

aws route53 change-resource-record-sets --hosted-zone-id %jenkinsZone% --change-batch file://%TEMP%\jenkinsRoute53.json
