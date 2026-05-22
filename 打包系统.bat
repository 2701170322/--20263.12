@echo off
chcp 65001 >nul
title 公租房管理系统 - EXE打包工具
echo ==========================================
echo   公租房管理系统 - 打包工具
echo ==========================================
echo.

REM 检查Python环境
echo [1/5] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.11+
    pause
    exit /b 1
)
echo [OK] Python已安装

REM 检查Node环境
echo [2/5] 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Node.js，请先安装Node.js 18+
    pause
    exit /b 1
)
echo [OK] Node.js已安装

REM 检查PyInstaller
echo [3/5] 检查PyInstaller...
python -c "import PyInstaller" >nul 2>&1
if errorlevel 1 (
    echo [提示] 正在安装PyInstaller...
    pip install pyinstaller
)
echo [OK] PyInstaller已安装

REM 打包后端
echo.
echo [4/5] 开始打包后端...
echo 这将需要几分钟时间，请耐心等待...
cd /d "%~dp0backend"

python -m PyInstaller ^
    --name "公租房管理系统-后端" ^
    --onefile ^
    --windowed ^
    --add-data "app;app" ^
    --add-data ".env;." ^
    --add-data "requirements.txt;." ^
    --hidden-import=uvicorn ^
    --hidden-import=uvicorn.protocols.http.auto ^
    --hidden-import=uvicorn.protocols.websockets.auto ^
    --hidden-import=uvicorn.logging ^
    --hidden-import=uvicorn.loops.auto ^
    --hidden-import=fastapi ^
    --hidden-import=fastapi.middleware.cors ^
    --hidden-import=sqlalchemy ^
    --hidden-import=sqlalchemy.ext.asyncio ^
    --hidden-import=sqlalchemy.orm ^
    --hidden-import=pymysql ^
    --hidden-import=cryptography ^
    --hidden-import=jose ^
    --hidden-import=jose.backends ^
    --hidden-import=passlib ^
    --hidden-import=passlib.hash ^
    --hidden-import=dotenv ^
    --hidden-import=pydantic ^
    --hidden-import=pydantic_settings ^
    --hidden-import=email_validator ^
    --clean ^
    --noconfirm ^
    run.py

if errorlevel 1 (
    echo.
    echo [错误] 后端打包失败！
    pause
    exit /b 1
)

echo [OK] 后端打包完成！

REM 打包前端
echo.
echo [5/5] 开始打包前端...
cd /d "%~dp0frontend"

echo 正在安装前端依赖...
call npm install
if errorlevel 1 (
    echo [错误] 前端依赖安装失败！
    pause
    exit /b 1
)

echo 正在构建前端...
call npm run build
if errorlevel 1 (
    echo [错误] 前端构建失败！
    pause
    exit /b 1
)

echo [OK] 前端打包完成！

REM 创建发布目录
echo.
echo 正在创建发布包...
cd /d "%~dp0"

if exist "发布包" (
    rmdir /s /q "发布包"
)

mkdir "发布包"
mkdir "发布包\后端"
mkdir "发布包\前端"
mkdir "发布包\数据库脚本"

REM 复制文件
if exist "backend\dist\公租房管理系统-后端.exe" (
    copy "backend\dist\公租房管理系统-后端.exe" "发布包\后端\" >nul
)

if exist "frontend\dist" (
    xcopy /s /e /i /q "frontend\dist" "发布包\前端\dist" >nul
)

copy "启动系统.bat" "发布包\" >nul
copy "使用说明.txt" "发布包\" >nul
copy "backend\.env" "发布包\后端\" >nul

echo.
echo ==========================================
echo   打包完成！
echo ==========================================
echo.
echo 发布包位置: %~dp0发布包\
echo.
echo 文件结构:
echo   ├── 启动系统.bat
echo   ├── 使用说明.txt
echo   ├── 后端\
echo   │   └── 公租房管理系统-后端.exe
echo   │   └── .env (数据库配置)
echo   ├── 前端\
echo   │   └── dist\ (静态文件)
echo   └── 数据库脚本\
echo.
echo 使用方法:
echo   1. 双击 "启动系统.bat" 运行
echo   2. 等待服务启动
echo   3. 浏览器自动打开
echo.
pause