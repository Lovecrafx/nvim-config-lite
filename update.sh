#!/bin/bash

# =============================================================================
# Neovim 配置更新脚本
# 功能：更新配置仓库 + 同步 Lazy.nvim 插件
# =============================================================================

set -e

NVIM_CONFIG_DIR="$HOME/.config/nvim"
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info()  { printf "${BLUE}[INFO] %b${NC}\n" "$1"; }
log_warn()  { printf "${YELLOW}[WARN] %b${NC}\n" "$1"; }
log_error() { printf "${RED}[ERROR] %b${NC}\n" "$1"; exit 1; }

# 进入配置目录
cd "$NVIM_CONFIG_DIR"

# 检查是否在 git 仓库中
if [ ! -d ".git" ]; then
    log_error "未检测到 git 仓库。请先通过安装脚本初始化配置。"
fi

log_info "正在拉取最新配置..."
git fetch origin
git pull origin main

log_info "正在同步插件..."
if ! nvim --headless -c "Lazy! sync" -c "qa" 2>/dev/null; then
    log_warn "插件同步出现警告，继续执行..."
fi

log_info "正在验证配置..."
if ! nvim --headless +qa 2>/dev/null; then
    log_error "配置验证失败，请检查错误信息。"
fi

echo ""
printf "${GREEN}[SUCCESS] 更新完成！${NC}\n"
echo ""
echo "可通过以下命令启动 Neovim:"
echo "  nvim"