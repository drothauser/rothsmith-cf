#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "You must supply a stack name argument!"
    exit 1
fi

# ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\\,subnet-0386c83240089af69\" \

aws cloudformation create-stack\
 --debug\
 --stack-name $1\
 --template-body file://rothsmith-apps.yaml\
 --parameters\
    ParameterKey=AmiId,ParameterValue=ami-0151f162d1ff20101\
    ParameterKey=PubElbSNs,ParameterValue=\"subnet-09cd0870f808f2677\" \
    ParameterKey=PubElbSGs,ParameterValue=\"sg-07748e0a19e936ae4\" \
    ParameterKey=PubEc2SNs,ParameterValue=subnet-09cd0870f808f2677\
    ParameterKey=PubEc2SGs,ParameterValue=sg-07748e0a19e936ae4
