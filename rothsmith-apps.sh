#!/bin/bash
#if [ $# -eq 0 ]
#  then
#    echo "You must supply a stack name argument!"
#    exit 1
#fi

templateBodyUrl='https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-apps.yaml'
if [ "$1" == "--file" ]
then
  templateBodyUrl='file://rothsmith-apps.yaml'
fi

# ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\\,subnet-0386c83240089af69\" \templateBodyUrl
# --debug\

stackName="ROTHSMITH-APPS"

if aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM \
 --disable-rollback \
 --stack-name $stackName \
 --template-body ${templateBodyUrl}\
 --parameters\
    ParameterKey=VPCStack,ParameterValue=\"ROTHSMITH-VPC\" \
    ParameterKey=S3Bucket,ParameterValue=\"rothsmith-cloudformation\" 
then
   echo "Creating $stackName Stack..."
   if aws cloudformation wait stack-create-complete --stack-name $stackName
   then
      echo "$stackName stack has been created."
      echo "Updating nexus.rothsmith.net Route 53 record set alias target with ELB host"
      ./nexus-route53.sh
   fi
fi

RC=$?

echo
echo "***********************************************************************"
echo "* $0 completed. RC = $RC"
echo "***********************************************************************"
exit $RC
