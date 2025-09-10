@echo off

set REPO_URL=https://github.com/automazeio/ccpm.git
set TARGET_DIR=.

echo 正在从 %REPO_URL% 克隆仓库...
git clone %REPO_URL% %TARGET_DIR%

if %ERRORLEVEL% EQU 0 (
    echo 克隆成功。正在删除 .git 目录...
    rmdir /s /q .git 2>nul
    rmdir /s /q install 2>nul
    del /q .gitignore 2>nul
    echo Git 目录已删除。仓库现在是未跟踪状态。
) else (
    echo 错误：克隆仓库失败。
    exit /b 1
)