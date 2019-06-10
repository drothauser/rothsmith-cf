#!/bin/bash
#if [ $# -eq 0 ]
#  then
#    echo "You must supply a stack name argument!"
#    exit 1
#fi

templateBodyUrl='https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-devops.yaml'
if [ "$1" == "--file" ]
then
  templateBodyUrl='file://rothsmith-devops.yaml'
fi

stackName="ROTHSMITH-DEVOPS"

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
      echo "Updating jenkins.rothsmith.net Route 53 record set alias target with ELB host"
      ./jenkins-route53.sh
   fi
fi

RC=$?

echo
echo "***********************************************************************"
echo "* $0 completed. RC = $RC"
echo "***********************************************************************"
exit $RC
