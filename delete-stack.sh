#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "You must supply a stack name argument!"
    exit 1
fi
aws cloudformation delete-stack --stack-name $1