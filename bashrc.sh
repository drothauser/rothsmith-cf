#!/bin/bash

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export M2_HOME=/usr/local/maven
export PATH=.:${M2_HOME}/bin:${PATH}

function gclass() {
  find . -name "*.jar" -exec sh -c 'jar -tf {} | grep -H --label {} '$1'' \;
}
