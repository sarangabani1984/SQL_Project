@echo off
REM =====================================================
REM Batch file to setup and run ranking functions practice
REM =====================================================

echo ================================================
echo SQL Server Ranking Functions Practice Setup
echo ================================================
echo.

REM Set your SQL Server instance name here
REM Change "localhost" to your server name if different
SET SERVER_NAME=localhost

echo Step 1: Creating database and tables...
echo ------------------------------------------------
sqlcmd -S %SERVER_NAME% -E -i "%~dp0setup_ranking_practice.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to create database and tables!
    echo Please check:
    echo 1. SQL Server is running
    echo 2. You have permission to create databases
    echo 3. Server name is correct: %SERVER_NAME%
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo Setup completed successfully!
echo ================================================
echo.
echo Database: RankingPractice
echo Table: SalesPerformance
echo.
echo To run the practice queries, execute:
echo   sqlcmd -S %SERVER_NAME% -E -i ranking_queries.sql
echo.
echo Or run: run_ranking_queries.bat
echo.
pause
