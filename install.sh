#!/bin/bash

# =============================================================================
# Neovim 自动安装与配置脚本 (支持 macOS 与 Debian/Ubuntu)
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
    printf "${BLUE}检测到 Debian/Ubuntu 系统，正在使用 apt 安装依赖...${NC}\n"
    $SUDO apt update
    $SUDO apt install -y git curl ripgrep fd-find build-essential
    
    # 安装 Neovim (如果系统版本过旧，建议从 GitHub 下载最新的 .deb)
    if ! command -v nvim &> /dev/null; then
        printf "${BLUE}正在安装 Neovim...${NC}\n"
        $SUDO apt install -y neovim
    fi

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
nvim --headless "+Lazy! sync" +qa

printf "${GREEN}安装与配置完成！${NC}\n"
printf "${BLUE}提示: 如果你在 Debian 上发现 nvim 版本过低 (建议 >= 0.9)，请考虑从 GitHub 下载最新版本。${NC}\n"
