# -*- coding: utf-8 -*-
"""
公租房管理系统 - 自动打包脚本
使用：python build.py
"""
import os
import sys
import shutil
import subprocess

def check_requirements():
    """检查环境"""
    print("=" * 60)
    print("公租房管理系统 - 自动打包工具")
    print("=" * 60)
    print()
    
    # 检查Python
    print("[1/3] 检查Python环境...")
    result = subprocess.run(['python', '--version'], capture_output=True, text=True)
    if result.returncode != 0:
        print("[错误] 未检测到Python")
        input("按回车键退出...")
        sys.exit(1)
    print(f"[OK] {result.stdout.strip()}")
    
    # 检查Node
    print("[2/3] 检查Node.js环境...")
    result = subprocess.run(['node', '--version'], capture_output=True, text=True)
    if result.returncode != 0:
        print("[错误] 未检测到Node.js")
        input("按回车键退出...")
        sys.exit(1)
    print(f"[OK] Node.js {result.stdout.strip()}")
    
    print("[OK] 环境检查完成！")
    print()

def create_simple_launcher():
    """创建简单的启动包（不打包后端，直接运行Python）"""
    print("=" * 60)
    print("创建便携式启动包...")
    print("=" * 60)
    print()
    
    package_name = '公租房管理系统-便携版'
    
    # 清理旧目录
    if os.path.exists(package_name):
        shutil.rmtree(package_name)
    
    # 创建目录
    os.makedirs(package_name)
    os.makedirs(f'{package_name}/backend')
    os.makedirs(f'{package_name}/frontend')
    print(f"[OK] 创建目录结构")
    
    # 复制后端源码
    shutil.copytree('backend/app', f'{package_name}/backend/app', dirs_exist_ok=True)
    shutil.copy('backend/run.py', f'{package_name}/backend/')
    shutil.copy('backend/requirements.txt', f'{package_name}/backend/')
    shutil.copy('backend/.env', f'{package_name}/backend/')
    shutil.copy('backend/init_db.py', f'{package_name}/backend/')
    print("[OK] 复制后端文件")
    
    # 复制前端
    os.chdir('frontend')
    print("[1/2] 安装前端依赖...")
    subprocess.run(['npm', 'install'], capture_output=True, shell=True)
    print("[2/2] 构建前端...")
    subprocess.run(['npm', 'run', 'build'], capture_output=True, shell=True)
    os.chdir('..')
    
    if os.path.exists('frontend/dist'):
        shutil.copytree('frontend/dist', f'{package_name}/frontend/dist', dirs_exist_ok=True)
        print("[OK] 复制前端文件")
    
    # 创建启动脚本
    launcher_bat = '''@echo off
chcp 65001 >nul
title 公租房管理系统
echo ==========================================
echo      公租房管理系统 - 启动器
echo ==========================================
echo.
echo [提示] 需要安装Python 3.11+和MySQL才能运行
echo.

REM 检查Python
echo [1/3] 检查Python...
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未检测到Python，请先安装Python 3.11+
    pause
    exit /b 1
)
echo [OK] Python已安装

REM 检查MySQL
echo [2/3] 检查MySQL...
tasklist | findstr "mysqld" >nul
if errorlevel 1 (
    echo [警告] MySQL服务可能未启动
    echo 请确保MySQL已运行并创建了数据库public_housing_db
)

REM 安装后端依赖
echo [3/3] 安装后端依赖...
cd backend
pip install -r requirements.txt -q
if errorlevel 1 (
    echo [警告] 依赖安装可能有问题
)
cd ..

REM 启动后端
echo.
echo 启动后端服务...
start "后端服务" cmd /k "cd backend && python run.py"
timeout /t 3 >nul

REM 启动前端
echo 启动浏览器...
start "" "http://localhost:8001"

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
pause
'''
    
    with open(f'{package_name}/启动系统.bat', 'w', encoding='utf-8') as f:
        f.write(launcher_bat)
    
    # 复制使用说明
    if os.path.exists('使用说明.txt'):
        shutil.copy('使用说明.txt', package_name)
    
    # 创建README
    readme = '''公租房管理系统 - 便携版
===================

系统要求
--------
1. Python 3.11+
2. MySQL 8.0+
3. Windows 10/11

安装步骤
--------
1. 安装Python 3.11+
   下载地址：https://www.python.org/downloads/

2. 安装MySQL 8.0+
   下载地址：https://dev.mysql.com/downloads/mysql/

3. 创建数据库
   在MySQL中执行：
   CREATE DATABASE public_housing_db CHARACTER SET utf8mb4;

4. 配置数据库
   修改 backend/.env 文件中的数据库配置：
   DB_PASSWORD=你的MySQL密码

5. 启动系统
   双击运行：启动系统.bat

访问地址
--------
- 系统首页：http://localhost:8001
- API文档：http://localhost:8001/docs

默认账号
--------
- 管理员：admin / admin123
- 员工：staff001 / staff123  
- 租户：tenant001 / tenant123

注意事项
--------
- 首次启动会自动安装Python依赖
- 确保MySQL服务已启动
- 确保8001端口未被占用
'''
    
    with open(f'{package_name}/README.txt', 'w', encoding='utf-8') as f:
        f.write(readme)
    
    print()
    print("=" * 60)
    print("打包完成！")
    print("=" * 60)
    print()
    print(f"发布包位置: {os.path.abspath(package_name)}")
    print()
    print("此版本特点：")
    print("  - 后端使用Python源码运行（不需要打包exe）")
    print("  - 前端已编译为静态文件")
    print("  - 首次启动会自动安装依赖")
    print("  - 避免PyInstaller打包错误")
    print()
    print("使用方法：")
    print("  1. 将整个文件夹压缩发给对方")
    print("  2. 对方解压后修改 backend/.env 数据库配置")
    print("  3. 双击 启动系统.bat 即可运行")
    print()

def main():
    try:
        check_requirements()
        create_simple_launcher()
        
        print("=" * 60)
        print("所有步骤已完成！")
        print("=" * 60)
        input("按回车键退出...")
        
    except Exception as e:
        print(f"[错误] {e}")
        import traceback
        traceback.print_exc()
        input("按回车键退出...")
        sys.exit(1)

if __name__ == '__main__':
    main()