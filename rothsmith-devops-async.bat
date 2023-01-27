@echo off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Evaluate argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1"=="--help" (
   goto syntax
)
set TEMPLATE_URL="https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-devops.yaml"
if "%1"=="--file" (
   set TEMPLATE_URL="file://rothsmith-devops.yaml"   
)

set stackName=ROTHSMITH-DEVOPS

aws cloudformation create-stack^
 --capabilities CAPABILITY_IAM ^
 --disable-rollback ^
 --stack-name %stackName%^
 --template-url %TEMPLATE_URL% ^
 --parameters^
    ParameterKey=VPCStack,ParameterValue=^"ROTHSMITH-VPC^" ^
    ParameterKey=S3Bucket,ParameterValue=^"rothsmith-cloudformation^" 

set RC=%ERRORLEVEL%

if %RC% NEQ 0 (
   goto finish
)

echo "Creating %stackName% Stack..."
aws cloudformation wait stack-create-complete --stack-name %stackName%

if %RC% NEQ 0 (
   goto finish
)

echo "%stackName% stack has been created."
echo "Updating jenkins.rothsmith.net Route 53 record set alias target with ELB host"
call jenkins-route53.bat

if %RC% NEQ 0 (
   goto finish
)

echo "Updating nexus.rothsmith.net Route 53 record set alias target with ELB host"
call nexus-route53.bat

goto finish

:syntax
   echo "Syntax: %0 [--file | --help]"
   echo Examples:
   echo    %0 --file   Use local template file to launch stack i.e. file://rothsmith-devops.yaml
   echo    %0 --help   Command usage
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Stack launch submitted to AWS. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%