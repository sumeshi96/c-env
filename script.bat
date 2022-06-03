@echo off
cd C:\github\c-env

start "" "Docker Desktop.exe"

echo starting docker...

ping 127.0.0.1 -n 30>nul

set PROCIMAGE=Docker Desktop.exe
set APLNAME=Dokcer
tasklist /FI "IMAGENAME eq %PROCIMAGE%" | find "%PROCIMAGE%" > NUL
if %errorlevel% == 0 (
    echo Start DockerDesktop
)

call :runContainer %containerName%

@rem�@����N���`�F�b�N
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    @rem �R���e�i���Ȃ�
    echo �R���e�i���r���h���Ă��܂�
    docker-compose up -d --build
    goto checkStatus
)

@rem�@�N���ς݃`�F�b�N
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    @rem �N�����Ă��Ȃ�
    echo �R���e�i���N�����Ă��܂�
    docker-compose start
    goto checkStatus
)

:checkStatus
@rem�@������������Ԋm�F
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    echo �R���e�i������܂���
    goto exitRunning
)
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    echo �R���e�i�̋N���Ɏ��s���܂���
    goto exitRunning
)
echo �������܂����B
devcontainer open

@rem �R���e�i�̑��݂��m�F����
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
@rem �߂�l 0:���݂��� -1:���݂��Ȃ�

@rem �R���e�i�̋N����Ԃ��m�F����
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
@rem �߂�l 0:�N���� -1:�N�����Ă��Ȃ�

@rem �R���e�i����
:runContainer
set containerName=c-env
echo %containerName%�R���e�i�̏��������Ă��܂�
cd %conteinerName%
if not exist docker-compose.yml (
    echo %containerName%�t�H���_����docker-compose.yml��������܂���ł���
    goto exitRunning
)
exit /b 0

:exitRunning
echo �N�������Ɏ��s���܂���
exit /b -1
@rem �I���



exit