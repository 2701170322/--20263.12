@echo off
chcp 65001 >nul
title 公租房管理系统
echo ==========================================
echo      公租房管理系统 - 启动器
echo ==========================================
echo.

REM 检查MySQL
echo [1/3] 检查MySQL服务...
tasklist | findstr "mysqld" >nul
if errorlevel 1 (
    echo [警告] MySQL服务可能未启动，请确保MySQL已运行
    timeout /t 3 >nul
) else (
    echo [OK] MySQL服务运行中
)

REM 启动后端
echo [2/3] 启动后端服务...
if exist "后端\公租房管理系统-后端.exe" (
    start "后端服务" "后端\公租房管理系统-后端.exe"
    echo [OK] 后端服务已启动
) else (
    echo [错误] 找不到后端程序，请先运行 打包系统.bat
    pause
    exit /b 1
)
timeout /t 3 >nul

REM 启动前端
echo [3/3] 启动前端服务...
if exist "前端\dist\index.html" (
    start "" "http://localhost:8001"
    echo [OK] 浏览器已打开
) else (
    echo [错误] 找不到前端文件，请先运行 打包系统.bat
    pause
    exit /b 1
)

echo.
echo ==========================================
echo      系统启动完成！
echo ==========================================
echo.
echo 访问地址: http://localhost:8001
echo.
echo 默认账号:
echo   管理员: admin / admin123
echo   员工:   staff001 / staff123
echo   租户:   tenant001 / tenant123
echo.
echo 按任意键关闭服务...
pause >nul

echo.
echo 正在关闭服务...
taskkill /FI "WINDOWTITLE eq 后端服务*" /F >nul 2>&1
echo [OK] 服务已关闭
timeout /t 2 >nul