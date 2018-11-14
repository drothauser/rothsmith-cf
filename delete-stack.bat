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
set rc=%ERRORLEVEL%

:syntax
   echo Syntax: %0 [stack name] 
   echo Example:
   echo    %0 mystack
   set rc=1

:finish
echo.
echo ***********************************************************************
echo * Deploy Finished. RC = %rc%
echo ***********************************************************************
exit /B %rc%