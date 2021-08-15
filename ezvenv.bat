@ECHO OFF
set EnvPath=D:/PythonEnvironments

if "%1"=="-le" GOTO :LIST_ENVS
if "%1"=="--list-envs" GOTO :LIST_ENVS
if "%1"=="--list-environments" GOTO :LIST_ENVS

if "%1"=="-lp" GOTO :LIST_PACKAGES
if "%1"=="--list-packages" GOTO :LIST_PACKAGES

if "%1"=="-h" GOTO :SHOW_HELP
if "%1"=="--help" GOTO :SHOW_HELP



GOTO :SET_ENV

:LIST_ENVS
echo Found the following environments in %EnvPath%:
echo.
DIR /AD /B "%EnvPath%"
Exit /B

:LIST_PACKAGES
set EnvName=%2
echo Found the following packages in %EnvPath%/%EnvName%
%EnvPath%/%EnvName%/Scripts/activate.bat & pip freeze & deactivate
Exit /B

:SET_ENV
echo Sourcing %EnvPath%/%1
CALL "D:/PythonEnvironments/venv/Scripts/activate.bat"
@REM %EnvPath%/%1/Scripts/activate
Exit /B

:SHOW_HELP
echo EnvPath : %EnvPath%
echo Usage:
echo 	ezenv environment
echo 	ezenv [options] [environment]
echo Options:
echo    -h                              Displays help page
echo    help
echo.
echo    -le                             Lists environments in the Environment Path
echo    --list-envs
echo    --list-environments
echo.
echo    -lp ENVIRONMENT                 Lists packages in environment
echo    --list-packages ENVIRONMENT
Exit /B
