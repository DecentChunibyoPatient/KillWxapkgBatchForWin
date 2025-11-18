@echo off
chcp 65001 >nul
set "FILE=KillWxapkg_2.4.1_windows_386.exe"
set "URL=https://github.com/Ackites/KillWxapkg/releases"

REM 判断 exe 是否存在
if not exist "%~dp0%FILE%" (
    echo 未找到：%FILE%
    echo.
    echo 正在打开下载页面...
    start "" "%URL%"
    echo.
    pause
    goto :eof
)
set "EXT=.wxapkg"

REM 检查是否有参数
if "%~1"=="" (
    echo 请拖入一个或多个文件或文件夹到此bat执行
    pause
    goto :eof
)

if "%~2"=="" (
 echo step2 请拖入一个或多个文件或文件夹到此bat执行


 goto step2
)



REM 输入文件完整路径
set inputFile=%~1

REM 获取输入目录
set inputDir=%~dp1

REM 获取文件名和扩展名
set fileName=%~nx1

REM 查找路径中第一个 wx 开头的文件夹作为 AppID
set AppID=
setlocal enabledelayedexpansion
for %%i in (%inputDir:\= % ) do (
    echo %%i | findstr /b "wx" >nul
    if not errorlevel 1 (
        set AppID=%%i
        goto :found
    )
)
:found
if "%AppID%"=="" (

    pause
    exit /b
)

REM 输出文件 = 原文件路径 + "_"
set outputFile=%inputFile%_

REM 当前bat所在目录exe
set exePath=%~dp0KillWxapkg_2.4.1_windows_386.exe

REM 打印执行命令

echo %exePath% -id=%AppID% -in=%inputFile% -out=%outputFile%

REM 执行命令（带双引号避免空格报错）
"%exePath%" -id=%AppID% -in="%inputFile%" -out="%outputFile%"



  exit 


:step2

REM 遍历所有拖入的参数
:loop
if "%~1"=="" goto :done

set "path=%~1"

REM 如果是目录
if exist "%path%\*" (
    echo 遍历文件夹及子文件夹: %path%
    for /r "%path%" %%f in (*%EXT%) do (
        echo 文件: %%f
 start /wait /i "" cmd /c ""%~f0" "%%f" run"


)


    )
) else (


    REM 单个文件，严格判断后缀
    set "filename=%~nx1"
    setlocal enabledelayedexpansion
    if /i "!filename:~-7!"=="%EXT%" (
        echo 文件: %path%

        echo "%~f0 %path% run"
 start /wait /i "" cmd /c ""%~f0" "%path%" run"




    ) else (
        echo 跳过非 %EXT% 文件: %path%
    )
    endlocal

)

shift
goto loop

:done
echo.
echo 所有文件处理完成！
pause
