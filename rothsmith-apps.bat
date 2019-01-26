@echo off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Evaluate argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1"=="--help" (
   goto syntax
)
set TEMPLATE_URL="https://s3.amazonaws.com/rothsmith-cloudformation/rothsmith-apps.yaml"
if "%1"=="--file" (
   set TEMPLATE_URL="file://rothsmith-apps.yaml"   
)

aws cloudformation create-stack^
 --capabilities CAPABILITY_IAM ^
 --disable-rollback ^
 --stack-name ROTHSMITH-APPS^
 --template-url %TEMPLATE_URL% ^
 --parameters^
    ParameterKey=VPCStack,ParameterValue=^"ROTHSMITH-VPC^" ^
    ParameterKey=S3Bucket,ParameterValue=^"rothsmith-cloudformation^" 

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