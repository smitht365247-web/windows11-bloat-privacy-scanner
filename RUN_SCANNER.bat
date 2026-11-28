@echo off
setlocal DisableDelayedExpansion
cd /d "%~dp0"
title Windows 11 Bloat, Telemetry ^& Privacy Scanner (v1.2)

:START
cls
echo ====================================================================
echo   WINDOWS 11 BLOAT, TELEMETRY ^& PRIVACY SCANNER (v1.2)
echo   (Portable Windows Toolkit ^| Read-Only Audit ^| No Coding Required)
echo ====================================================================
echo.
set "outDir=%~dp0."
set "customOut="
set /p "customOut=Save report in this toolkit folder? Press Enter for default or paste a folder path: "
if not defined customOut goto RUN
set "customOut=%customOut:"=%"
if not defined customOut goto RUN
call :StripSlash
if not defined customOut goto RUN
if "%customOut%"=="" goto RUN
set "outDir=%customOut%"

:RUN
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scan-Win11-Privacy.ps1" -OutputFolder "%outDir%"
echo.
pause
goto START

:StripSlash
if not defined customOut goto :eof
if "%customOut:~-1%"=="\" set "customOut=%customOut:~0,-1%"
goto :eof
