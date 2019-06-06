#!/bin/bash
# Script to reset Jenkins jobs to build 1

find /var/lib/jenkins/jobs -maxdepth 2 -mindepth 2 -name lastS* -exec rm -rf {} \;
find /var/lib/jenkins/jobs -maxdepth 2 -mindepth 2 -type d -exec rm -rf {} \;
find /var/lib/jenkins/jobs -maxdepth 2 -mindepth 2 -name nextBuildNumber -exec sh -c 'echo 1 > {}'  \;

