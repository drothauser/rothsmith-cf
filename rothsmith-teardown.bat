@echo off
setlocal

call delete-stack.bat ROTHSMITH-APPS
set RC=%ERRORLEVEL%
if "%RC%" NEQ "0" goto finish

call delete-stack.bat ROTHSMITH-VPC

set RC=%ERRORLEVEL%

:finish
echo.
echo ***********************************************************************
echo * %0 finished. RC = %rc%
echo ***********************************************************************
endlocal
exit /B %RC%

