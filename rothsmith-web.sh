#!/bin/bash -xe
aws s3 cp s3://rothsmith-scripts/httpd.conf /etc/httpd/conf/httpd.conf 
cd /etc/sysconfig
kvp="$1"
key=`echo $kvp | cut -f1 -d"="`
sed "/export $key/d" httpd
echo "export $kvp" >> httpd
service httpd restart