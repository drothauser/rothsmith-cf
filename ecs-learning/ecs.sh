#!/bin/bash

region="us-east-1"
vpcTag="ROTHSMITH-VPC"
VpcId=$(aws ec2 describe-vpcs --filters "Name='tag-value',Values='${vpcTag}'" --query 'Vpcs[*].VpcId' --output text)
Subnets=$(aws ec2 describe-subnets --query "Subnets[?VpcId=='${vpcId}'].[SubnetId]" --output text | paste -s -d ,)
PublicSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='PublicInstanceSG'" --query 'SecurityGroups[*].GroupId' --output text)
PrivateSGs=$(aws ec2 describe-security-groups --filters "Name='tag-value',Values='PrivateSubnetInstanceSG'" --query 'SecurityGroups[*].GroupId' --output text)

echo -e "\n*******************************************************************************
* Parameters:
*   VpcId=${VpcId}
*   Subnets=${Subnets}
*   PublicSGs=${PublicSGs}
*   PrivateSGs=${PrivateSGs}
*******************************************************************************************"

