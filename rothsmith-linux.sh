#!/bin/bash

function usage() {
   echo "Usage: $1 [stack name] [AMI ID] [keypair] [security groups] [subnet] [profile/role] [ADS stack name] [ADS user] [ADS pasasword] <debug>"
   echo "Example:"
   echo    "$0 ROTHSMITH-LINUX ami-04bfee437f38a691e RothsmithKeyPair sg-0985ed0c55346cbba subnet-2cf37e20 DevOps ROTHSMITH-ADS Administrator Password12345! debug"
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
stackname=$1

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate AMI ID argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$2" ]
  then
   echo "Missing AMI ID argument."
   usage
fi
ami_id=$2

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate key pair name argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$3" ]
  then
   echo "Missing keypair argument."
   usage
fi
keypair=$3

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate security groups argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$4" ]
  then
   echo "Missing security groups argument."
   usage
fi
securityGroups=$4

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate subnet groups argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$5" ]
  then
   echo "Missing subnet argument."
   usage
fi
subnet=$5

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate profile/role argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$6" ]
  then
   echo "Missing profile/role argument."
   usage
fi
profile=$6

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS stack argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$7" ]
  then
   echo "Missing Ads stack argument."
   usage
fi
adsStack=$7

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS user argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$8" ]
  then
   echo "Missing Ads user argument."
   usage
fi
adsUser=$8

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate ADS password argument.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$9" ]
  then
   echo "Missing Ads password argument."
   usage
fi
adsPassword=$9

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Check if debug is desired
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
debug=""
if [ "$10" == "debug" ]
  then
   debug=$10
fi


echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "
echo "* Creating stack with:"
echo "*"
echo "*   template file:   rothsmith-linux.yaml "
echo "*   stackname:       $stackname "
echo "*   ami_id:          $ami_id "
echo "*   keypair:         $keypair "
echo "*   securityGroups:  $securityGroups "
echo "*   subnets:         $subnet "
echo "*   profile/role:    $profile "
echo "*   ADS Stack:       $adsStack "
echo "*   ADS User:        $adsUser "
echo "*   ADS Password:    *****"
echo "*   $debug "
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "

aws cloudformation create-stack\
 --$debug\
 --stack-name $stackname\
 --template-body file://rothsmith-linux.yaml\
 --parameters\
    ParameterKey=AmiId,ParameterValue=${ami_id}\
    ParameterKey=EC2KeyPair,ParameterValue=${keypair}\
    ParameterKey=Ec2SecurityGroups,ParameterValue=${securityGroups}\
    ParameterKey=Ec2Subnet,ParameterValue=${subnet}\
    ParameterKey=EC2Profile,ParameterValue=${profile}\
    ParameterKey=AdsStack,ParameterValue=${adsStack}\
    ParameterKey=AdsUser,ParameterValue=${adsUser}\
    ParameterKey=AdsPassword,ParameterValue=${adsPassword}\

rc=$?


