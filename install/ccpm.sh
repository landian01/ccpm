#!/bin/bash

REPO_URL="https://github.com/automazeio/ccpm.git"
TARGET_DIR="."

echo "正在从 $REPO_URL 克隆仓库..."
git clone "$REPO_URL" "$TARGET_DIR"

if [ $? -eq 0 ]; then
    echo "克隆成功。正在删除 .git 目录..."
    rm -rf .git .gitignore install
    echo "Git 目录已删除。仓库现在是未跟踪状态。"
else
    echo "错误：克隆仓库失败。"
    exit 1
fi