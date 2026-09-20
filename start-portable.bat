@echo off
title Gemini Web to API Portable
cd /d "%~dp0"

echo ========================================================
echo  Gemini Web to API - Portable Edition (Windows x64)
echo ========================================================
echo  Server URL : http://127.0.0.1:8081/v1
echo  Web UI     : http://127.0.0.1:8081/
echo ========================================================
echo.

if exist "gemini-web-to-api-portable.exe" (
    gemini-web-to-api-portable.exe --open-browser
) else if exist "gemini-web2api-portable.exe" (
    gemini-web2api-portable.exe --open-browser
) else (
    echo [ERROR] File executable portable tidak ditemukan!
)

echo.
echo Server telah berhenti.
pause
