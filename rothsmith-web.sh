#!/bin/bash -xe
aws s3 cp s3://rothsmith-scripts/httpd.conf /etc/httpd/conf/httpd.conf
cd /etc/sysconfig
for kvp in "$@"
do
    key=`echo $kvp | cut -f1 -d"="`
    sed "/export $key/d" httpd > httpd.tmp
    cat httpd.tmp > httpd
    echo "export $kvp" >> httpd
done
service httpd restart
