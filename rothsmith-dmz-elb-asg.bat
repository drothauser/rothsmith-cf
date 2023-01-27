REM ParameterKey=ELBSubnets,ParameterValue=^"subnet-09cd0870f808f2677^^,subnet-0386c83240089af69^" ^
aws cloudformation create-stack^
 --debug^
 --stack-name %1^
 --template-body file://rothsmith-dmz-elb-asg.yaml^
 --parameters^
    ParameterKey=AmiId,ParameterValue=ami-0151f162d1ff20101^
    ParameterKey=ELBSubnets,ParameterValue=^"subnet-09cd0870f808f2677^" ^
    ParameterKey=ELBSecurityGroups,ParameterValue=^"sg-07748e0a19e936ae4^" ^
    ParameterKey=Ec2Subnets,ParameterValue=subnet-09cd0870f808f2677^
    ParameterKey=Ec2SecurityGroups,ParameterValue=sg-07748e0a19e936ae4
