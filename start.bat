@echo off
chcp 65001 >nul
title 公租房管理系统 - 启动器
echo ==========================================
echo      公租房管理系统 - 一键启动
echo ==========================================
echo.

REM 检查Python环境
echo [1/4] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.11+
    pause
    exit /b 1
)
echo [√] Python已安装

REM 检查Node环境
echo [2/4] 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Node.js，请先安装Node.js 18+
    echo 下载地址: https://nodejs.org/
    pause
    exit /b 1
)
echo [√] Node.js已安装

REM 启动后端服务
echo [3/4] 启动后端服务...
start "后端服务" cmd /k "cd /d "%~dp0backend" && echo 正在启动后端服务... && python -m uvicorn app.main:app --host 0.0.0.0 --port 8001 --workers 1"
timeout /t 3 >nul

REM 启动前端服务
echo [4/4] 启动前端服务...
start "前端服务" cmd /k "cd /d "%~dp0frontend" && echo 正在启动前端服务... && npm run dev"
timeout /t 3 >nul

echo.
echo ==========================================
echo      系统启动完成！
echo ==========================================
echo.
echo 访问地址:
echo   - 前端界面: http://localhost:3000
echo   - 后端API:  http://localhost:8001
echo   - API文档:  http://localhost:8001/docs
echo.
echo 默认账号:
echo   - 管理员: admin / admin123
echo   - 员工:   staff001 / staff123
echo   - 租户:   tenant001 / tenant123
echo.
echo 按任意键关闭所有服务...
pause >nul

REM 关闭所有相关的cmd窗口
taskkill /FI "WINDOWTITLE eq 后端服务*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq 前端服务*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq 公租房管理系统*" /F >nul 2>&1

echo 服务已关闭
exit