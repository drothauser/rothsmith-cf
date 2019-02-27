#!/bin/bash
#if [ $# -eq 0 ]
#  then
#    echo "You must supply a stack name argument!"
#    exit 1
#fi

templateBodyUrl='https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-ads.yaml'
if [ "$1" == "--file" ]
then
  templateBodyUrl='file://rothsmith-ads.yaml'
fi

# ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\\,subnet-0386c83240089af69\" \templateBodyUrl
# --debug\

aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM \
 --disable-rollback \
 --stack-name ROTHSMITH-ADS\
 --template-body ${templateBodyUrl}\
 --parameters\
    ParameterKey=VpcId,ParameterValue=\"vpc-b3e69dd5\" \
    ParameterKey=DirectoryName,ParameterValue=\"rothsmith.net\" \
    ParameterKey=DirectoryPassword,ParameterValue=\"Password12345!\" \
    ParameterKey=SubnetsManagement,ParameterValue=\"subnet-910521ca\,subnet-00524b49\"
    