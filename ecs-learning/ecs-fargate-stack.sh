#!/bin/bash

EC2KeyPair="RothsmithKeyPair"
Scaling="1,2,1"
vpcTag="ROTHSMITH-VPC"
publicSGTag="PublicInstanceSG"
privateSGTag="PrivateSubnetInstanceSG"
publicSubnetTag="PublicSubnet"
privateSubnetTag="PrivateSubnet"

VpcId=$(aws ec2 describe-vpcs --filters "Name='tag-value',Values='${vpcTag}'" --query 'Vpcs[*].VpcId' --output text)

PublicSubnets=$(aws ec2 describe-subnets --query "Subnets[?Tags[?starts_with(Value, '${publicSubnetTag}') && [VpcId=='${VpcId}']]].[SubnetId]" --output text | paste -s -d ,)
PrivateSubnets=$(aws ec2 describe-subnets --query "Subnets[?Tags[?starts_with(Value, '${privateSubnetTag}') && [VpcId=='${VpcId}']]].[SubnetId]" --output text | paste -s -d ,)

PublicSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='${publicSGTag}'" --query 'SecurityGroups[*].GroupId' --output text)
PrivateSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='${privateSGTag}'" --query 'SecurityGroups[*].GroupId' --output text)

ClusterName='RothsmithECSCluster'
Project='Presidents'
InstanceType="t2.micro"
Scaling="1,2,1"
Owner="$(whoami)"

subfolder=$(basename `pwd`)
templateFile="ecs-fargate-stack.yaml"
templateUri="https://s3.amazonaws.com/rothsmith-cloudformation/${subfolder}/${templateFile}"
if [ "$1" == "--file" ]
then
  templateUri='file://${subfolder}/${templateFile}'
fi

stackName="ROTHSMITH-ECS-FARGATE-CLUSTER"

echo -e "\n*******************************************************************************
*
* Stack Info:
*   stackName=${stackName}
*   templateUri=${templateUri}
*
* Template Parameters:
*   EC2KeyPair=${EC2KeyPair}
*   InstanceType=${InstanceType}
*   ClusterName=${ClusterName}
*   Owner=${Owner}
*   Project=${Project}
*   Scaling=${Scaling}
*   PrivateSGs=${PrivateSGs}
*   PublicSGs=${PublicSGs}
*   PrivateSubnets=${PrivateSubnets}
*   PublicSubnets=${PublicSubnets}
*   VpcId=${VpcId}
*
* Miscellany:
*   vpcTag=${vpcTag}
*   publicSGTag=${publicSGTag}
*   privateSGTag=${privateSGTag}
*   publicSubnetTag=${publicSubnetTag}
*   privateSubnetTag=${privateSubnetTag}
*******************************************************************************************"
export IFS=$'\n'
if aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
 --disable-rollback \
 --stack-name $stackName \
 --template-body ${templateUri}\
 --parameters\    
    ParameterKey=InstanceType,ParameterValue=\"${InstanceType}\" \
    ParameterKey=ClusterName,ParameterValue=\"${ClusterName}\" \
    ParameterKey=Owner,ParameterValue=\"${Owner}\" \
    ParameterKey=Scaling,ParameterValue=\"${Scaling}\" \
    ParameterKey=PrivateSGs,ParameterValue=\"${PrivateSGs}\" \
    ParameterKey=PrivateSubnets,ParameterValue=\"${PrivateSubnets}\" \
    ParameterKey=Project,ParameterValue=\"${Project}\" \
    ParameterKey=PublicSGs,ParameterValue=\"${PublicSGs}\" \
    ParameterKey=PublicSubnets,ParameterValue=\"${PublicSubnets}\" \
    ParameterKey=VpcId,ParameterValue=\"${VpcId}\"
then
   echo "Creating $stackName Stack..."
   if aws cloudformation wait stack-create-complete --stack-name $stackName
   then
      echo "$stackName stack has been created."
      echo "Updating ${Project,,}.rothsmith.net Route 53 record set alias target with ELB host"
      ../rothsmith-route53.sh ${Project}
   fi
fi

RC=$?

echo
echo "***********************************************************************"
echo "* $0 completed. RC = $RC"
echo "***********************************************************************"
exit $RC

