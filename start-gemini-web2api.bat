@echo off
title Gemini Web2API Server
cd /d "%~dp0"

echo ========================================================
echo Memulai Gemini Web2API Server...
echo ========================================================

if exist ".venv\Scripts\activate.bat" (
    call ".venv\Scripts\activate.bat"
) else (
    echo [WARNING] .venv\Scripts\activate.bat tidak ditemukan.
)

if exist ".venv\Scripts\python.exe" (
    ".venv\Scripts\python.exe" gemini_web2api.py --config config.json
) else (
    python gemini_web2api.py --config config.json
)

echo.
echo ========================================================
echo Server telah berhenti.
echo ========================================================
pause
