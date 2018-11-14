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

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate key pair name argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%2"=="" (
   echo Missing keypair argument.
   goto syntax
)
set KEYPAIR=%2

aws cloudformation delete-stack --stack-name %STACKNAME%
aws cloudformation create-stack^
 --debug^
 --stack-name %STACKNAME%^
 --template-body file://rothsmith-windows.yaml^
 --parameters^
    ParameterKey=EC2KeyPair,ParameterValue=%KEYPAIR% 
set rc=%ERRORLEVEL%

:syntax
   echo Syntax: %0 [stack name] [keypair]
   echo Example:
   echo    %0 mystack mykeypair
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Stack launch finished. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%