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

set KEYPAIR="RothsmithKeyPair"

aws cloudformation delete-stack --stack-name %STACKNAME%
aws cloudformation create-stack^
 --stack-name %STACKNAME%^
 --template-body file://rothsmith-quicken.yaml^
 --parameters^
    ParameterKey=Ec2KeyPair,ParameterValue=%KEYPAIR% 
set rc=%ERRORLEVEL%

goto finish

:syntax
   echo Syntax: %0 [stack name] 
   echo Example:
   echo    %0 mystack 
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Stack launch finished. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%