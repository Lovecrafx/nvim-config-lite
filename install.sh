#!/bin/bash

# =============================================================================
# Neovim 自动安装与配置脚本 (支持 macOS 与 Debian/Ubuntu)
#
# 安装命令示例 (Debian/Ubuntu):
# curl -fsSL https://raw.githubusercontent.com/Lovecrafx/nvim-config-lite/main/install.sh | bash
# =============================================================================

set -e

# 定义颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

printf "${BLUE}开始配置 Neovim 环境...${NC}\n"

# 0. 处理 sudo 逻辑
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    printf "${RED}错误: 当前非 root 用户且系统中未找到 sudo 命令，请先安装 sudo 或以 root 身份运行。${NC}\n"
    exit 1
fi

# 1. 检测操作系统并安装依赖
OS_TYPE="$(uname)"

if [ "$OS_TYPE" == "Darwin" ]; then
    printf "${BLUE}检测到 macOS 系统，正在使用 Homebrew 安装依赖...${NC}\n"
    if ! command -v brew &> /dev/null; then
        printf "${RED}错误: 未找到 Homebrew，请先安装: https://brew.sh/${NC}\n"
        exit 1
    fi
    brew install neovim git ripgrep fd
elif [ -f /etc/debian_version ]; then
    $SUDO apt update
    $SUDO apt install -y git curl ripgrep fd-find build-essential libfuse2

    # 安装最新版 Neovim (GitHub 官方 AppImage)
    printf "${BLUE}正在从 GitHub 下载并安装最新的 Neovim (AppImage)...${NC}\n"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
    $SUDO chmod +x nvim.appimage
    $SUDO mv nvim.appimage /usr/local/bin/nvim

    # 为 fd-find 创建软链接
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        export PATH="$HOME/.local/bin:$PATH"
    fi
else
    printf "${RED}抱歉，暂不支持此操作系统类型: $OS_TYPE${NC}\n"
    exit 1
fi

# 2. 配置 Neovim 仓库
NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="https://github.com/Lovecrafx/nvim-config-lite.git"

if [ -d "$NVIM_CONFIG_DIR" ]; then
    printf "${BLUE}发现现有配置，正在备份到 ${NVIM_CONFIG_DIR}.bak...${NC}\n"
    rm -rf "${NVIM_CONFIG_DIR}.bak"
    mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
fi

printf "${BLUE}正在克隆配置仓库到 $NVIM_CONFIG_DIR ...${NC}\n"
git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

# 3. 自动安装插件 (Headless 模式)
printf "${BLUE}正在通过 lazy.nvim 自动同步插件...${NC}\n"
# 使用 -c 确保命令按顺序执行
nvim --headless -c "Lazy! sync" -c "qa"

printf "\n${GREEN}安装与配置完成！${NC}\n"
