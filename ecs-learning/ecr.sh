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

Owner="$(whoami)"

while getopts 'r:o:?h' opt
do
   case ${opt} in
      r) EcrName="${OPTARG}" ;;
      o) Owner="${OPTARG}" ;;
      h|?) usage ;;
   esac
done

if [[ -z ${EcrName} ]]; then echo "EcrName is required." && usage; fi

subfolder=$(basename `pwd`)
templateFile="ecr.yaml"
templateUri="https://s3.amazonaws.com/rothsmith-cloudformation/${subfolder}/${templateFile}"
if [ "$1" == "--file" ]
then
  templateUri='file://${subfolder}/${templateFile}'
fi

stackName="ROTHSMITH-ECR-${EcrName^^}"

echo -e "\n*******************************************************************************
*
* Stack Info:
*   stackName=${stackName}
*   templateUri=${templateUri}
*
* Template Parameters:
*   EcrName=${EcrName}
*   Owner=${Owner}
*
*******************************************************************************************"
export IFS=$'\n'
if aws cloudformation create-stack\
 --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
 --disable-rollback \
 --stack-name $stackName \
 --template-body ${templateUri}\
 --parameters\
    ParameterKey=EcrName,ParameterValue=\"${EcrName}\" \
    ParameterKey=Owner,ParameterValue=\"${Owner}\" 
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

