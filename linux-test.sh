#!/bin/bash -xe
ElbDnsKVPs="A=B,C=D"
ConfigFile="SMS.xml"
ZabbixURL="http://localhost/zabbix"

bucket="rothsmith-scripts"
scriptsDir="/tmp/scripts/"

aws s3 sync "s3://$bucket/" "/tmp/scripts"

cd $scriptsDir
ncctElbDnsNames="${ElbDnsKVPs}"

echo "& .\NcctConfig.ps1 $ncctElbDnsNames ${ConfigFile}"
echo "*** NCCT TouchPoint configuration completed ***"

echo "& .\ZabbixSyncFunction.ps1 ${ZabbixURL}"
echo "*** ZabbixSyncFunction completed ***"

