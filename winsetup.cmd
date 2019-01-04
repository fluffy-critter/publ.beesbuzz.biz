@ECHO OFF
TITLE Publ Setup

pipenv --venv
IF %ERRORLEVEL% NEQ 0 (
    ECHO Running first-time install...
    pipenv --three install
) ELSE (
    ECHO Refreshing packages...
    pipenv install
)

if %ERRORLEVEL% EQU 0 ECHO Install complete.
