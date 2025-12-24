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
    printf "${BLUE}检测到 Debian/Ubuntu 系统，正在清理旧环境并更新软件包列表...${NC}\n"
    # 卸载可能存在的旧版本
    if command -v nvim &> /dev/null; then
        printf "${BLUE}发现已安装的 Neovim，正在卸载...${NC}\n"
        $SUDO apt remove -y neovim neovim-runtime || true
        $SUDO rm -f /usr/local/bin/nvim
    fi
    $SUDO apt update
    $SUDO apt install -y git curl ripgrep fd-find build-essential libfuse2 bc

    # 安装最新版 Neovim (GitHub 官方 AppImage)
    # 检测 glibc 版本，旧系统 (glibc < 2.31) 使用 neovim-releases 仓库
    GLIBC_VER=$(ldd --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | tail -n1)
    
    # 默认使用主仓库
    DOWNLOAD_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
    
    if [ -n "$GLIBC_VER" ]; then
        if [ "$(echo "$GLIBC_VER < 2.31" | bc -l)" -eq 1 ]; then
            printf "${BLUE}检测到旧版 glibc ($GLIBC_VER)，切换至兼容性仓库下载...${NC}\n"
            DOWNLOAD_URL="https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.appimage"
        else
            printf "${BLUE}检测到现代 glibc ($GLIBC_VER)，从主仓库下载...${NC}\n"
        fi
    fi

    printf "${BLUE}正在下载 Neovim...${NC}\n"
    curl -fsSL "$DOWNLOAD_URL" -o nvim.appimage
    $SUDO chmod +x nvim.appimage

    # 尝试运行并检查是否需要解压 (解决 FUSE 缺失问题)
    if ! ./nvim.appimage --version &> /dev/null; then
        printf "${BLUE}检测到环境不支持直接运行 AppImage，正在解压安装...${NC}\n"
        ./nvim.appimage --appimage-extract > /dev/null
        $SUDO rm -rf /opt/nvim
        $SUDO mv squashfs-root /opt/nvim
        $SUDO ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
        rm nvim.appimage
    else
        $SUDO mv nvim.appimage /usr/local/bin/nvim
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
# 使用 -c 确保命令按顺序执行
nvim --headless -c "Lazy! sync" -c "qa"

printf "\n${GREEN}安装与配置完成！${NC}\n"
