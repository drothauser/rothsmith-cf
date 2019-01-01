#!/bin/bash -xe
echo ${LoadBalancer.DNSName} > /z.txt
cd /etc/sysconfig
sed '/export TOMCAT/d' httpd > httpd
echo 'export TOMCAT=${TomcatElb}' >> httpd
#sed 's/\(TOMCAT\=\).*/\1abc/' /etc/sysconfig/httpd > httpd.txt
cat httpd