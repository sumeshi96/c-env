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

@rem　初回起動チェック
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    @rem コンテナがない
    echo コンテナをビルドしています
    docker-compose up -d --build
    goto checkStatus
)

@rem　起動済みチェック
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    @rem 起動していない
    echo コンテナを起動しています
    docker-compose start
    goto checkStatus
)

:checkStatus
@rem　成功したか状態確認
call :isExistsContainer %containerName%
if %errorlevel%==-1 (
    echo コンテナがありません
    goto exitRunning
)
call :isRunningContainer %containerName%
if %errorlevel%==-1 (
    echo コンテナの起動に失敗しました
    goto exitRunning
)
echo 成功しました。
devcontainer open

@rem コンテナの存在を確認する
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
@rem 戻り値 0:存在する -1:存在しない

@rem コンテナの起動状態を確認する
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
@rem 戻り値 0:起動中 -1:起動していない

@rem コンテナ準備
:runContainer
set containerName=c-env
echo %containerName%コンテナの準備をしています
cd %conteinerName%
if not exist docker-compose.yml (
    echo %containerName%フォルダ内にdocker-compose.ymlが見つかりませんでした
    goto exitRunning
)
exit /b 0

:exitRunning
echo 起動処理に失敗しました
exit /b -1
@rem 終わり



exit