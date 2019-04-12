@echo Off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Domain Name Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1" EQU "" (
   echo Missing domain name argument.
   goto syntax
)
set DOMAIN=%1

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Domain User Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%2" EQU "" (
   echo Missing domain user argument.
   goto syntax
)
set USER=%2

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Domain User Password Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%3" EQU "" (
   echo Missing domain user password argument.
   goto syntax
)
set PASSWORD=%3

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Primary DNS Server Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%4" EQU "" (
   echo Missing primary DNS server argument.
   goto syntax
)
set PRIMARY=%4

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Secondary DNS Server Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%5" EQU "" (
   echo Missing secondary DNS server argument.
   goto syntax
)
set SECONDARY=%5

echo.
echo * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *
echo * Running %0 with following parameters:
echo *
echo *   Domain Name:            %DOMAIN%
echo *   Domain User:            %USER%
echo *   Domain Password:        %PASSWORD%
echo *   Primary DNS Server:     %PRIMARY%
echo *   Secondary DNS Server:   %SECONDARY%
echo *   Computer Name:          %COMPUTERNAME%
echo * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *
echo.

call domdns.bat %PRIMARY% %SECONDARY%

echo.
echo * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *
echo * Running:
echo *
echo *   netdom.exe join %computername% /domain:%DOMAIN% /UserD:%USER% /PasswordD:%PASSWORD%
echo *
echo * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = *
echo.
netdom.exe join %computername% /domain:%DOMAIN% /UserD:%USER% /PasswordD:%PASSWORD%

set RC=%ERRORLEVEL%

goto finish

:syntax
   echo Syntax: %0 [ 'domain name' 'domain user' 'domain password' 'primary DNS server' 'secondary DNS server'] 
   echo Example:
   echo    %0 ncct.gov Admin Password12345! 10.205.165.141 10.205.165.60
   set RC=1

:finish
echo.
echo ***********************************************************************
echo * %0 completed with return code = %RC%
echo ***********************************************************************
endlocal
exit /B %RC%
