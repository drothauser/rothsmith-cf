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

aws cloudformation delete-stack --stack-name %STACKNAME%
set RC=%ERRORLEVEL%

if "%RC%" NEQ "0" goto finish
aws cloudformation wait stack-create-complete --stack-name %STACKNAME%

goto finish

:syntax
   echo Syntax: %0 [stack name] 
   echo Example:
   echo    %0 mystack
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * Delete Stack Submitted to AWS. RC = %RC%
echo ***********************************************************************
exit /B %RC%