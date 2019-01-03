#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "You must supply a stack name argument!"
    exit 1
fi

# ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\\,subnet-0386c83240089af69\" \
# --debug\

aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM \
 --disable-rollback \
 --stack-name $1\
 --template-body file://rothsmith-apps.yaml\
 --parameters\
    ParameterKey=VPCStack,ParameterValue=\"ROTHSMITH-VPC\" \
    ParameterKey=S3Bucket,ParameterValue=\"rothsmith-cloudformation\" 
