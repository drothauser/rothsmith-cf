#!/bin/bash

function usage() {
   echo "Usage: $1 [stack name] [AMI ID] [keypair] [security groups] [subnet] <debug>"
   echo "Example:"
   echo    "$0 myWindowsStack ami-050202fb72f001b47 RothsmithKeyPair sg-c6f9e6ba subnet-910521ca debug"
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
# Check if debug is desired
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
debug=""
if [ "$6" == "debug" ]
  then
   debug=$6
fi


echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "
echo "* Creating stack with:"
echo "*"
echo "*   template file:   rothsmith-windows.yaml "
echo "*   stackname:       $stackname "
echo "*   ami_id:          $ami_id "
echo "*   keypair:         $keypair "
echo "*   securityGroups:  $securityGroups "
echo "*   subnets:         $subnet "
echo "*   $debug "
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = "

aws cloudformation create-stack\
 --$debug\
 --stack-name $stackname\
 --template-body file://rothsmith-windows.yaml\
 --parameters\
    ParameterKey=AmiId,ParameterValue=${ami_id}\
    ParameterKey=EC2KeyPair,ParameterValue=${keypair}\
    ParameterKey=Ec2SecurityGroups,ParameterValue=${securityGroups}\
    ParameterKey=Ec2Subnet,ParameterValue=${subnet}

rc=$?


