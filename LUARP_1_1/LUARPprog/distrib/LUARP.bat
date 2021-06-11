@echo off

if not "%minimized%"=="" goto :minimized
set minimized=true
start /min cmd /C "%~dpnx0"
goto :EOF
:minimized
rem Anything after here will run in a minimized window

echo Launching Splash Screen
start Splash\splash.hta

echo Launching Matlab compiled software
LUARPprog.exe

echo Closing Splashscreen (mshta.exe)
Taskkill /F /IM mshta.exe

