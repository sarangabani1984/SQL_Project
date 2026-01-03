@echo off
REM =====================================================
REM Batch file to run all ranking function queries
REM =====================================================

echo ================================================
echo Running Ranking Functions Practice Queries
echo ================================================
echo.

REM Set your SQL Server instance name here
SET SERVER_NAME=localhost

echo Executing queries from: ranking_queries.sql
echo ------------------------------------------------
echo.

sqlcmd -S %SERVER_NAME% -E -i "%~dp0ranking_queries.sql"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Failed to execute queries!
    echo Please ensure:
    echo 1. Database RankingPractice exists
    echo 2. Run setup_ranking_practice.sql first
    echo.
    pause
    exit /b 1
)

echo.
echo ================================================
echo All queries completed!
echo ================================================
echo.
pause
