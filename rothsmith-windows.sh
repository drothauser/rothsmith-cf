#!/bin/bash

function usage() {
   echo "Usage: ${0} [stack name] [AMI ID] [keypair] [security groups] [subnet] [ADS stack name] [ADS admin user] [ADS user password] <debug>"
   echo "Example:"
   echo    "${0} ROTHSMITH-WINDOWS ami-066663db63b3aa675 RothsmithKeyPair sg-c6f9e6ba subnet-910521ca DevOps ROTHSMITH-WINDOWS drothauser@yahoo.com "\'Rothsmith Windows\'" ROTHSMITH-ADS Administrator Password12345! debug"
   exit 1   
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate stack name argument
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ $# -eq 0 ]
  then
    echo "You must supply a stack name argument!"
    usage
fi
stackname=${1}
template="$(echo ${1} | tr '[:upper:]' '[:lower:]' | sed  's/^.*\-rothsmith/rothsmith/g').yaml"

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate AMI ID argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${2}" ]
  then
   echo "Missing AMI ID argument."
   usage
fi
ami_id=${2}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate key pair name argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${3}" ]
  then
   echo "Missing keypair argument."
   usage
fi
keypair=${3}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate security groups argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${4}" ]
  then
   echo "Missing security groups argument."
   usage
fi
securityGroups=${4}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate subnet groups argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${5}" ]
  then
   echo "Missing subnet argument."
   usage
fi
subnet=${5}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate EC2 profile/role name.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${6}" ]
  then
   echo "Missing EC2 profile/role argument."
   usage
fi
ec2Profile=${6}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate name of the EC2 instance.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${7}" ]
  then
   echo "Missing  name of the EC2 instance."
   usage
fi
ec2Name=${7}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate email address of the person owning this EC2 instance.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${8}" ]
  then
   echo "Missing email address of the person owning this EC2 instance."
   usage
fi
ec2Owner=${8}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate description of this EC2 instance.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "9" ]
  then
   echo "Missing description of this EC2 instance."
   usage
fi
ec2Desc=${9}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS stack name.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${10}" ]
  then
   echo "Missing ADS stack name argument."
   usage
fi
adsStackName=${10}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS Administrator User.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${11}" ]
  then
   echo "Missing ADS administrator user argument."
   usage
fi
adsUser=${11}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS Administrator Password.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "${12}" ]
  then
   echo "Missing ADS administrator password argument."
   usage
fi
adsPassword=${12}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Check if debug is desired
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
debug=""
if [ "${11}" == "debug" ]
  then
   debug=${11}
fi

echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "
echo "* Creating stack with:"
echo "*"
echo "*   template file:   $template"
echo "*   stackname:       $stackname "
echo "*   ami_id:          $ami_id "
echo "*   keypair:         $keypair "
echo "*   securityGroups:  $securityGroups "
echo "*   subnets:         $subnet "
echo "*   EC2 Profile:     $ec2Profile "
echo "*   EC2 Name:        $ec2Name "
echo "*   EC2 Owner:       $ec2Owner "
echo "*   EC2 Description: $ec2Desc "
echo "*   ADS stack name:  $adsStackName "
echo "*   ADS stack name:  $adsUser "
echo "*   ADS stack name:  $adsPassword "
echo "*   $debug "
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "

aws cloudformation create-stack\
 --$debug\
 --stack-name $stackname\
 --template-body file://${template}\
 --parameters\
   ParameterKey=AmiId,ParameterValue=${ami_id}\
   ParameterKey=Ec2KeyPair,ParameterValue=${keypair}\
   ParameterKey=Ec2SecurityGroups,ParameterValue=${securityGroups}\
   ParameterKey=Ec2Subnet,ParameterValue=${subnet}\
   ParameterKey=Ec2Profile,ParameterValue=${ec2Profile}\
   ParameterKey=Ec2Name,ParameterValue=${ec2Name}\
   ParameterKey=Ec2Owner,ParameterValue=${ec2Owner}\
   ParameterKey=Ec2Desc,ParameterValue="${ec2Desc}"\
   ParameterKey=AdsStackName,ParameterValue=${adsStackName}\
   ParameterKey=AdsUser,ParameterValue=${adsUser}\
   ParameterKey=AdsPassword,ParameterValue=${adsPassword}

rc=$?


