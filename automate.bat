@echo off
cd C:\c-env

start "" "Docker Desktop.exe"

echo starting docker...
echo wait for about 30 minites

ping 127.0.0.1 -n 30>nul

set PROCIMAGE=Docker Desktop.exe
set APLNAME=Dokcer
tasklist /FI "IMAGENAME eq %PROCIMAGE%" | find "%PROCIMAGE%" > NUL
if %errorlevel% == 0 (
    echo Start DockerDesktop
)

call :runContainer %containerName%

@rem initialization
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    @rem No contaienr
    echo building container...
    docker-compose up -d --build
    goto checkStatus
)

@rem activated check
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    @rem No activated
    echo Starting containers...
    docker-compose start
    goto checkStatus
)
echo finish!
exit

@rem <--------------------subrutin-------------------->  

@rem status check
:checkStatus
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    echo No contaienr
    goto exitRunning
)
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    echo Failed to start container...
    goto exitRunning
)
echo Success...
devcontainer open

@rem checking exists container...
:isExistsContainer
set containerName=c-env
set isExistsContainer=NOT_EXIST

docker container ls -q -a -f name="%containerName%" > isExistsContainer.txt
set /p isExistsContainer=<isExistsContainer.txt
del isExistsContainer.txt
if %isExistsContainer%==NOT_EXIST (
    exit /b -1
)
exit /b 0

@rem checking starting container
:isRunningContainer
set containerName=c-env
set isRunningContainer=NOT_RUNNING
docker container ls -q -f name="%containerName%" > isRunningContainer.txt
set /p isRunningContainer=<isRunningContainer.txt
del isRunningContainer.txt
if %isRunningContainer%==NOT_RUNNING (
    exit /b -1
)
exit /b 0

@rem Preparing contaienr
:runContainer
set containerName=c-env
echo Preparing %containerName% container...
cd %conteinerName%
if not exist docker-compose.yml (
    echo Not found docker-compose.yml
    goto exitRunning
)
exit /b 0

:exitRunning
echo Failed to start container...
exit /b -1
