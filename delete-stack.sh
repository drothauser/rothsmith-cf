#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "You must supply a stack name argument!"
    exit 1
fi

stackName="$1"

if aws cloudformation delete-stack --stack-name $stackName
then
   echo "Deleting $stackName Stack..."
   aws cloudformation wait stack-delete-complete --stack-name $stackName
   echo "$stackName stack has been deleted."
fi