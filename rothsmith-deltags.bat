setlocal

cd %USERPROFILE%\git\rothsmith-parent
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\rothsmith-encrypt
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\genericdao-api
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\genericdao-dbutils
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\rothsmith-database
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\rothsmith-props
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\rothsmith-testutils
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

cd %USERPROFILE%\git\presidents
call %USERPROFILE%\git\rothsmith-cf\git-delete-tags.bat

endlocal


