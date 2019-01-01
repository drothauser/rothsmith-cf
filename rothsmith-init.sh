#!/bin/bash -xe
#!/bin/bash
# rothsmith-init.sh: a shell script to download and invoke a script in userdata.
# define usage function
usage(){
	echo "Usage: $0 server code [web, nexus, jenkins)"
	exit 1
}

serviceCode="$1"
 
# define is_file_exits function 
# $f -> store argument passed to the script
launchConfigScript(){

    local script="rothsmith-$serviceCode.sh"
    aws s3 cp s3://rothsmith-scripts/$script /tmp --region ${AWS::Region}
    source ./$script &> $script.log

}
# invoke  usage
# call usage() function if server code not supplied
[[ $# -eq 0 ]] && usage
 
# Invoke launchConfigScript
launchConfigScript "$serviceCode" 
