@echo off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Evaluate argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1"=="--help" (
   goto syntax
)
set TEMPLATE_URL="https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-jenkins.yaml"
if "%1"=="--file" (
   set TEMPLATE_URL="file://rothsmith-jenkins.yaml"   
)

aws cloudformation create-stack^
 --capabilities CAPABILITY_IAM ^
 --disable-rollback ^
 --stack-name ROTHSMITH-JENKINS^
 --template-url %TEMPLATE_URL% ^
 --parameters^
    ParameterKey=Ec2Subnet,ParameterValue=^"subnet-910521ca^" ^
    ParameterKey=EC2Profile,ParameterValue=^"DevOps^" 

set RC=%ERRORLEVEL%
goto finish

:syntax
   echo "Syntax: %0 [--file | --help]"
   echo Examples:
   echo    %0 --file   Use local template file to launch stack i.e. file://rothsmith-apps.yaml
   echo    %0 --help   Command usage
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Stack launch submitted to AWS. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%