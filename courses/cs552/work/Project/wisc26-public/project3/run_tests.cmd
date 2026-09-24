@echo off
setlocal

rem Wrapper for PowerShell test runner. Use:
rem   run_tests.cmd            (run all)
rem   run_tests.cmd unit_imm    (run one)
rem   run_tests.cmd -list       (list tests)

set TEST=all
if not "%~1"=="" set TEST=%~1

powershell -NoProfile -ExecutionPolicy Bypass -File run_tests.ps1 -Test %TEST%
exit /b %ERRORLEVEL%
