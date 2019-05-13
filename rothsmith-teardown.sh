#!/bin/bash

if ./delete-stack.sh ROTHSMITH-APPS
then
  ./delete-stack.sh ROTHSMITH-VPC
fi