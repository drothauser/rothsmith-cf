#!/bin/bash

function usage() {
   command="${0}"
   echo "Usage: ${command}
   -r EcrName - Elastic Container Registry name (required)
   -o Owner - Owner/Progenitor of the stack"
   echo "Examples:"
   echo "${command} -r my-repository"
   echo "${command} -r my-repository -o drothauser"
   exit 2
}

echo "Initializing..."

ExecutionRoleArn="AWSECSTaskExecutionRole"
Owner="$(whoami)"

PublicSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='PublicInstanceSG'" --query 'SecurityGroups[*].GroupId' --output text)
PrivateSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='PrivateSubnetInstanceSG'" --query 'SecurityGroups[*].GroupId' --output text)
SecurityGroups="${PrivateSGs}"

privateSubnetTag="PrivateSubnet"
PrivateSubnets=$(aws ec2 describe-subnets --query "Subnets[?Tags[?starts_with(Value, 'PrivateSubnet') && [VpcId=='${VpcId}']]].[SubnetId]" --output text | paste -s -d ,)

while getopts 'r:o:?h' opt
do
   case ${opt} in
      r) ExecutionRoleArn="${OPTARG}" ;;
      o) Owner="${OPTARG}" ;;
      s) SecurityGroups="${OPTARG}" ;;
      S) Subnets="${OPTARG}" ;;
      h|?) usage ;;
   esac
done

#if [[ -z ${EcrName} ]]; then echo "EcrName is required." && usage; fi

subfolder=$(basename `pwd`)
templateFile="ecs-task.yaml"
templateUri="https://s3.amazonaws.com/rothsmith-cloudformation/${subfolder}/${templateFile}"
if [ "$1" == "--file" ]
then
  templateUri='file://${subfolder}/${templateFile}'
fi

stackName="ROTHSMITH-ECS-TASK"

echo -e "\n*******************************************************************************
*
* Stack Info:
*   stackName=${stackName}
*   templateUri=${templateUri}
*
* Template Parameters:
*   ExecutionRoleArn=${ExecutionRoleArn}
*   Owner=${Owner}
*   SecurityGroups=${SecurityGroups}
*   Subnets=${PrivateSubnets}
*
*******************************************************************************************"

export IFS=$'\n'
if aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
 --disable-rollback \
 --stack-name $stackName \
 --template-body ${templateUri}\
 --parameters\
    ParameterKey=ExecutionRoleArn,ParameterValue=\"${ExecutionRoleArn}\" \
    ParameterKey=Owner,ParameterValue=\"${Owner}\" \
    ParameterKey=SecurityGroups,ParameterValue=\"${SecurityGroups}\" \
    ParameterKey=Subnets,ParameterValue=\"${PrivateSubnets}\"
then
   echo "Creating $stackName Stack..."
   if aws cloudformation wait stack-create-complete --stack-name $stackName
   then
      echo "$stackName stack has been created."
      #echo "Updating nexus.rothsmith.net Route 53 record set alias target with ELB host"
      #./nexus-route53.sh
      #echo "Updating jenkins.rothsmith.net Route 53 record set alias target with ELB host"
      #./jenkins-route53.sh
   fi
fi

RC=$?

echo
echo "***********************************************************************"
echo "* $0 completed. RC = $RC"
echo "***********************************************************************"
exit $RC

