@echo off
title Build Gemini Web to API Portable
cd /d "%~dp0"

echo ========================================================
echo Membangun Gemini Web to API Portable Standalone (.exe)...
echo ========================================================

if exist ".venv\Scripts\activate.bat" (
    call ".venv\Scripts\activate.bat"
) else (
    echo [ERROR] Virtual environment .venv tidak ditemukan!
    pause
    exit /b 1
)

python -m pip install pyinstaller
pyinstaller --noconfirm --clean --onefile --name "gemini-web-to-api-portable" --add-data "test-chat.html;." gemini_web2api.py

if exist "dist\gemini-web-to-api-portable.exe" (
    copy /y "dist\gemini-web-to-api-portable.exe" "%~dp0gemini-web-to-api-portable.exe"
    copy /y "dist\gemini-web-to-api-portable.exe" "%~dp0gemini-web2api-portable.exe"
    echo.
    echo ========================================================
    echo Build Selesai! File: gemini-web-to-api-portable.exe
    echo ========================================================
) else (
    echo [ERROR] Gagal membuat file executable.
)

pause
