setlocal

for /F "tokens=3 delims=/" %%i in ('git ls-remote -t ^| findstr /V /R "^.*-[0-9].*[}]"') do git push --delete origin %%i

for /F %%i in ('git tag --list') do git tag --delete %%i

endlocal
