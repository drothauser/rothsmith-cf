#!/bin/bash

function syntax() {
   echo "Syntax: $0 [--file | --help]"
   echo "Examples:"
   echo "   $0 --file   Use local template file to launch stack i.e. file://rothsmith-vpc.yaml"
   echo "   $0 --help   Command usage"
   exit 1
}

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Evaluate argument
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ "$1" = "--help" ]; then
   syntax
fi

TEMPLATE_URL="https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-vpc.yaml"
if [ "$1" = "--file" ]; then
   TEMPLATE_URL="file://rothsmith-vpc.yaml"   
fi

aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM \
 --disable-rollback \
 --stack-name ROTHSMITH-VPC\
 --template-body $TEMPLATE_URL \
 --parameters\
    ParameterKey=KeyPairName,ParameterValue=\"RothsmithKeyPair\"  

RC=$?

echo
echo "***********************************************************************"
echo "* Stack launch submitted to AWS. RC = $RC"
echo "***********************************************************************"
exit $RC