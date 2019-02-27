#!/bin/bash
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# This script performs the following tasks:
#   1. Updates the /etc/resolve.conf file with the primary and 
#      secondary DNS IP addresses of the domain service.
#   2. Issues a command to join the currently running instance
#      to the domain.
#
# Note that the following packages must be installed prior to 
# running this command - realmd, krb5-workstation. Install via:
#  yum install realmd krb5-workstation sssd -y
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

function usage() {
   echo "Usage: [Domain Name] [Primary DNS IP] [Secondary DNS IP] [Domain Adminstrator ID] [Domain Adminstrator Password]" >&2
   echo "Example:" >&2
   echo    "$0 ncct.gov 10.205.165.141 10.205.165.60 Admin Password12345!" >&2
   exit 1   
}

domainAdminId=$5

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain name file.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$1" ]
  then
   echo "Missing domain name argument." >&2
   usage
fi
domainName=$1

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's primary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$2" ]
  then
   echo "Missing domain's primary DNS IP address." >&2
   usage
fi
primaryIP=$2

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's secondary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$3" ]
  then
   echo "Missing domain's secondary DNS IP address." >&2
   usage
fi
secondaryIP=$3

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain administrator id.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$4" ]
  then
   echo "Validate domain administrator id." >&2
   usage
fi
domainAdminId=$4

# = = = = = = = = = = = = = = = = = = = =#!/bin/bash
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# This script performs the following tasks:
#   1. Updates the /etc/resolve.conf file with the primary and 
#      secondary DNS IP addresses of the domain service.
#   2. Issues a command to join the currently running instance
#      to the domain.
#
# Note that the following packages must be installed prior to 
# running this command - realmd, krb5-workstation. Install via:
#  yum install realmd krb5-workstation -y
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

function usage() {
   echo "Usage: [Domain Name] [Primary DNS IP] [Secondary DNS IP] [Domain Adminstrator ID] [Domain Adminstrator Password]" >&2
   echo "Example:" >&2
   echo    "$0 ncct.gov 10.205.165.141 10.205.165.60 Admin Password12345!" >&2
   exit 1   
}

domainAdminId=$5

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain name file.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$1" ]
  then
   echo "Missing domain name argument." >&2
   usage
fi
domainName=$1

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's primary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$2" ]
  then
   echo "Missing domain's primary DNS IP address." >&2
   usage
fi
primaryIP=$2

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's secondary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$3" ]
  then
   echo "Missing domain's secondary DNS IP address." >&2
   usage
fi
secondaryIP=$3

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain administrator id.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$4" ]
  then
   echo "Validate domain administrator id." >&2
   usage
fi
domainAdminId=$4

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain administrator password.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$5" ]
  then
   echo "Validate domain administrator password." >&2
   usage
fi
domainPasswd=$5

declare -r resolvConf="/etc/resolv.conf"

t=$(date +%Y%m%d-%H%M%S)
resolvConfBackup="${resolvConf}.${t}.bak"

# AWS hostname is 16 characters in the form of ip-ddd-ddd-ddd-ddd e.g. ip-10-205-165-64.
# Windows Domain hostnames must not be longer than 15 characters. Therefore, we must 
# shorten the hostname. 
origHost=$(hostname)
# Reduce the hostname size by stripping out '-' characters:
hostname $(hostname | tr -d '-')

echo
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo "* Running $0 with following parameters:"
echo "*"
echo "*   Domain Name:              $domainName"
echo "*   Primary DNS IP:           $primaryIP"
echo "*   Secondary DNS IP:         $secondaryIP"
echo "*   Administrator ID:         $domainAdminId"
echo "*   Administrator Password:   ********"
echo "*   Original Host Name:       $origHost"
echo "*   New Host Name:            $(hostname)"
echo "*   DNS Resolver File         $resolvConf"
echo "*   DNS Resolver Backup File  $resolvConfBackup"
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo

# Backup /etc/resolv.conf:
cp $resolvConf $resolvConfBackup

#Empties contents of /etc/resolv.conf
truncate -s 0 $resolvConf 

#Adds Domain Name to /etc/resolv.conf
echo search $domainName >> $resolvConf

#Adds Domain Primary IP Address to /etc/resolv.conf
echo nameserver $primaryIP >> $resolvConf

#Adds Domain Secondary IP Adress to /etc/resolv.conf
echo nameserver $secondaryIP >> $resolvConf

#Executes command to join instance to domain
echo $domainPasswd | realm join -v --user=$domainAdminId $domainName 


# Validate domain administrator password.#!/bin/bash
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# This script performs the following tasks:
#   1. Updates the /etc/resolve.conf file with the primary and 
#      secondary DNS IP addresses of the domain service.
#   2. Issues a command to join the currently running instance
#      to the domain.
#
# Note that the following packages must be installed prior to 
# running this command - realmd, krb5-workstation. Install via:
#  yum install realmd krb5-workstation -y
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

function usage() {
   echo "Usage: [Domain Name] [Primary DNS IP] [Secondary DNS IP] [Domain Adminstrator ID] [Domain Adminstrator Password]" >&2
   echo "Example:" >&2
   echo    "$0 ncct.gov 10.205.165.141 10.205.165.60 Admin Password12345!" >&2
   exit 1   
}

domainAdminId=$5

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain name file.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$1" ]
  then
   echo "Missing domain name argument." >&2
   usage
fi
domainName=$1

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's primary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$2" ]
  then
   echo "Missing domain's primary DNS IP address." >&2
   usage
fi
primaryIP=$2

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain's secondary DNS IP address.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$3" ]
  then
   echo "Missing domain's secondary DNS IP address." >&2
   usage
fi
secondaryIP=$3

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain administrator id.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$4" ]
  then
   echo "Validate domain administrator id." >&2
   usage
fi
domainAdminId=$4

# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
# Validate domain administrator password.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$5" ]
  then
   echo "Validate domain administrator password." >&2
   usage
fi
domainPasswd=$5

declare -r resolvConf="/etc/resolv.conf"

t=$(date +%Y%m%d-%H%M%S)
resolvConfBackup="${resolvConf}.${t}.bak"

# AWS hostname is 16 characters in the form of ip-ddd-ddd-ddd-ddd e.g. ip-10-205-165-64.
# Windows Domain hostnames must not be longer than 15 characters. Therefore, we must 
# shorten the hostname. 
origHost=$(hostname)
# Reduce the hostname size by stripping out '-' characters:
hostname $(hostname | tr -d '-')

echo
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo "* Running $0 with following parameters:"
echo "*"
echo "*   Domain Name:              $domainName"
echo "*   Primary DNS IP:           $primaryIP"
echo "*   Secondary DNS IP:         $secondaryIP"
echo "*   Administrator ID:         $domainAdminId"
echo "*   Administrator Password:   ********"
echo "*   Original Host Name:       $origHost"
echo "*   New Host Name:            $(hostname)"
echo "*   DNS Resolver File         $resolvConf"
echo "*   DNS Resolver Backup File  $resolvConfBackup"
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo

# Backup /etc/resolv.conf:
cp $resolvConf $resolvConfBackup

#Empties contents of /etc/resolv.conf
truncate -s 0 $resolvConf 

#Adds Domain Name to /etc/resolv.conf
echo search $domainName >> $resolvConf

#Adds Domain Primary IP Address to /etc/resolv.conf
echo nameserver $primaryIP >> $resolvConf

#Adds Domain Secondary IP Adress to /etc/resolv.conf
echo nameserver $secondaryIP >> $resolvConf

#Executes command to join instance to domain
echo $domainPasswd | realm join -v --user=$domainAdminId $domainName 


# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if [ -z "$5" ]
  then
   echo "Validate domain administrator password." >&2
   usage
fi
domainPasswd=$5

declare -r resolvConf="/etc/resolv.conf"

t=$(date +%Y%m%d-%H%M%S)
resolvConfBackup="${resolvConf}.${t}.bak"

# AWS hostname is 16 characters in the form of ip-ddd-ddd-ddd-ddd e.g. ip-10-205-165-64.
# Windows Domain hostnames must not be longer than 15 characters. Therefore, we must 
# shorten the hostname. 
origHost=$(hostname)
# Reduce the hostname size by stripping out '-' characters:
hostname $(hostname | tr -d '-')

echo
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo "* Running $0 with following parameters:"
echo "*"
echo "*   Domain Name:              $domainName"
echo "*   Primary DNS IP:           $primaryIP"
echo "*   Secondary DNS IP:         $secondaryIP"
echo "*   Administrator ID:         $domainAdminId"
echo "*   Administrator Password:   ********"
echo "*   Original Host Name:       $origHost"
echo "*   New Host Name:            $(hostname)"
echo "*   DNS Resolver File         $resolvConf"
echo "*   DNS Resolver Backup File  $resolvConfBackup"
echo "* = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *"
echo

# Backup /etc/resolv.conf:
cp $resolvConf $resolvConfBackup

#Empties contents of /etc/resolv.conf
truncate -s 0 $resolvConf 

#Adds Domain Name to /etc/resolv.conf
echo search $domainName >> $resolvConf

#Adds Domain Primary IP Address to /etc/resolv.conf
echo nameserver $primaryIP >> $resolvConf

#Adds Domain Secondary IP Adress to /etc/resolv.conf
echo nameserver $secondaryIP >> $resolvConf

#Executes command to join instance to domain
echo $domainPasswd | realm join -v --user=$domainAdminId $domainName 

