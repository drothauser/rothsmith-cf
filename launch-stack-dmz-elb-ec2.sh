    # ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\\,subnet-0386c83240089af69\" \
aws cloudformation create-stack\
 --debug\
 --stack-name myteststack\
 --template-body file://rothsmith-dmz-elb.yaml\
 --parameters\
    ParameterKey=ELBSubnets,ParameterValue=\"subnet-09cd0870f808f2677\" \
    ParameterKey=ELBSecurityGroups,ParameterValue=\"sg-07748e0a19e936ae4\" \
    ParameterKey=Ec2Subnet,ParameterValue=subnet-09cd0870f808f2677\
    ParameterKey=Ec2SecurityGroups,ParameterValue=sg-07748e0a19e936ae4
