@echo off
SET CURDIR=%CD%

Set /P version=Enter release version number (e.g. 1.2.3):
If "%version%"=="" goto :err
goto:noerr

:err
echo No release version entered
goto:end

:noerr
SET SRC=https://metageta.googlecode.com/svn/branches/dsewpac/trunk
SET DST=https://metageta.googlecode.com/svn/branches/dsewpac/tags/%version%

rmdir /s /q %TEMP%\metageta-dsewpac-%version% > nul 2>&1
rem svn delete %DST% --force --message "Cleaning up"

svn copy %SRC% %DST% -m "Tagging DSEWPaC version %version%"
svn checkout --depth=empty %DST% %TEMP%\metageta-dsewpac-%version%

cd %TEMP%\metageta-dsewpac-%version%
svn propset displayversion %version%-dsewpac .
svn propset version %version%.$Revision$ .
svn commit -m "Updating version properties %version%"
cd %CURDIR%
rem Sleep for 3 seconds
ping 127.0.0.1 -n 3 > nul 2>&1
rmdir /s /q %TEMP%\metageta-dsewpac-%version%

:end
pause