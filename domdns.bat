@echo Off
setlocal

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Primary DNS Server Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%1"=="" (
   echo Missing primary DNS server argument.
   goto syntax
)
set PRIMARY=%1

:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
:: Validate Secondary DNS Server Argument
:: = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
if "%2"=="" (
   echo Missing secondary DNS server argument.
   goto syntax
)
set SECONDARY=%2

echo *** SETTING DNS SERVERS FOR ADAPTERS ***
echo.
For /f "skip=2 tokens=4*" %%a In ('NetSh Interface IPv4 Show Interfaces') Do (
    call :UseNetworkAdapter %%a "%%b"
)

set RC=%ERRORLEVEL%
goto finish

:syntax
   echo Syntax: %0 [primary DNS server] [secondary DNS server] 
   echo Example:
   echo    %0 10.205.165.141 10.205.165.60
   set RC=1

:finish
echo.
echo *** %0 completed with return code = %RC% ***
echo.
endlocal
exit /B %RC%

:UseNetworkAdapter
:: %1 = State
:: %2 = Name (quoted); %~2 = Name (unquoted)
set STATE=%1
set NAME=%2
If %STATE% EQU connected (
    :: Configure DNS Servers
    echo Setting primary DNS server for %NAME% = %PRIMARY%
    netsh interface ip set dns name=%NAME% static %PRIMARY%
    echo Setting secondary DNS server for %NAME% = %SECONDARY%
    netsh interface ip add dns name=%NAME% %SECONDARY% index=2
)
exit /B