@echo off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate stack name argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1"=="" (
   echo Missing stack name argument.
   goto syntax
)
set STACKNAME=%1

REM --template-body file://rothsmith-apps.yaml^

aws cloudformation create-stack^
 --capabilities CAPABILITY_IAM ^
 --disable-rollback ^
 --stack-name %STACKNAME%^
 --template-body s3://rothsmith-cloudformation/rothsmith-apps.yaml^
 --parameters^
    ParameterKey=VPCStack,ParameterValue=^"ROTHSMITH-VPC^" ^
    ParameterKey=S3Bucket,ParameterValue=^"rothsmith-cloudformation^" 

set RC=%ERRORLEVEL%
goto finish

:syntax
   echo Syntax: %0 [stack name] 
   echo Example:
   echo    %0 mystack 
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Stack launch submitted to AWS. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%