#!/bin/bash 

# Note: uses space delimiter - will need to change in ncct-yaml if we use this.
ncctParams="NCCT-SMS-ELB=internal-DR-SMS-ELB-299976286.us-gov-west-1.elb.amazonaws.com NCCT-SMC-ELB=internal-DR-SMC-ELB-781552663.us-gov-west-1.elb.amazonaws.com NCCT-INMB-ELB=internal-DR-INMB-ELB-270283541.us-gov-west-1.elb.amazonaws.com NCCT-ENMB-ELB=internal-DR-ENMB-ELB-758516280.us-gov-west-1.elb.amazonaws.com NCCT-EXMB-ELB=internal-DR-EXMB-ELB-631577608.us-gov-west-1.elb.amazonaws.com NCCT-SVC-ELB=internal-DR-SVC-ELB-124401458.us-gov-west-1.elb.amazonaws.com NCCT-SVCA-ELB=internal-DR-SVCA-ELB-2089726507.us-gov-west-1.elb.amazonaws.com NCCT-DBMS-ELB=internal-DR-DBMS-ELB-1785593355.us-gov-west-1.elb.amazonaws.com NCCT-FUS-ELB=internal-DR-FUS-ELB-1886222459.us-gov-west-1.elb.amazonaws.com NCCT-BIN-ELB=internal-DR-BIN-ELB-400454980.us-gov-west-1.elb.amazonaws.com NCCT-DB-RDS=ncct-db-rds.chprgs0ortaa.us-gov-west-1.rds.amazonaws.com"

declare -A paramMap
for kvp in $ncctParams ; do
    key="${kvp%%=*}"
    value="${kvp##*=}"
    paramMap[$key]=$value
done

# Dump out the paramMap:

for K in "${!paramMap[@]}"; do echo $K --- ${paramMap[$K]}; done

# Get the value of the NCCT-INMB-ELB key:
echo "***** NCCT-INMB-ELB = ${paramMap['NCCT-INMB-ELB']}"
