#!/bin/bash

set AmiId="ami-08a29dcf20b8fea61"
set EC2KeyPair="RothsmithKeyPair"
set Scaling="1,2,1"
set vpcTag="ROTHSMITH-VPC"
set publicSGTag="PublicInstanceSG"
set privateSGTag="PrivateSubnetInstanceSG"

VpcId=$(aws ec2 describe-vpcs --filters "Name='tag-value',Values='%vpcTag%" --query 'Vpcs[*].VpcId' --output text)
Subnets=$(aws ec2 describe-subnets --query "Subnets[?VpcId=='${VpcId}'].[SubnetId]" --output text | paste -s -d ,)
PublicSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='${publicSGTag}'" --query 'SecurityGroups[*].GroupId' --output text)
PrivateSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='${privateSGTag}'" --query 'SecurityGroups[*].GroupId' --output text)

ClusterName='RothsmithECSCluster'
InstanceType="t2.micro"
Scaling="1,2,1"
Owner="$(whoami)"
SecurityGroups="${PrivateSGs}"


subfolder=$(basename `pwd`)
templateFile="ecs.yaml"
templateUri="https://s3.amazonaws.com/rothsmith-cloudformation/${subfolder}/${templateFile}"
if [ "$1" == "--file" ]
then
  templateUri='file://${subfolder}/${templateFile}'
fi

stackName="ROTHSMITH-ECS-LEARNING"

echo -e "\n*******************************************************************************
*
* Stack Info:
*   stackName=${stackName}
*   templateUri=${templateUri}
*
* Template Parameters:
*   AmiId=${AmiId}
*   EC2KeyPair=${EC2KeyPair}
*   InstanceType=${InstanceType}
*   ClusterName=${ClusterName}
*   Owner=${Owner}
*   Scaling=${Scaling}
*   SecurityGroups=${SecurityGroups}
*   Subnets=${Subnets}
*   VpcId=${VpcId}
*
* Miscellany:
*   vpcTag=${vpcTag}
*   publicSGTag=${publicSGTag}
*   privateSGTag=${privateSGTag}
*******************************************************************************************"
export IFS=$'\n'
if aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
 --disable-rollback \
 --stack-name $stackName \
 --template-body ${templateUri}\
 --parameters\
    ParameterKey=AmiId,ParameterValue=\"${AmiId}\" \
    ParameterKey=InstanceType,ParameterValue=\"${InstanceType}\" \
    ParameterKey=ClusterName,ParameterValue=\"${ClusterName}\" \
    ParameterKey=Owner,ParameterValue=\"${Owner}\" \
    ParameterKey=Scaling,ParameterValue=\"${Scaling}\" \
    ParameterKey=SecurityGroups,ParameterValue=\"${SecurityGroups}\" \
    ParameterKey=Subnets,ParameterValue=\"${Subnets}\" \
    ParameterKey=VpcId,ParameterValue=\"${VpcId}\"
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

