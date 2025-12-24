#!/bin/bash

# =============================================================================
# Neovim 自动安装与配置脚本 (支持 macOS 与 Debian/Ubuntu)
# =============================================================================

set -e

# --- 1. 全局配置与变量 ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

NVIM_CONFIG_DIR="$HOME/.config/nvim"
REPO_URL="https://github.com/Lovecrafx/nvim-config-lite.git"

# --- 2. 工具函数 ---
log_info()  { printf "${BLUE}[INFO] %b${NC}\n" "$1"; }
log_warn()  { printf "${YELLOW}[WARN] %b${NC}\n" "$1"; }
log_error() { printf "${RED}[ERROR] %b${NC}\n" "$1"; exit 1; }

check_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    elif command -v sudo >/dev/null 2>&1; then
        SUDO="sudo"
    else
        log_error "当前非 root 用户且未找到 sudo，请先安装 sudo 或以 root 运行。"
    fi
}

# --- 3. 兼容性逻辑 ---
get_glibc_version() {
    ldd --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | tail -n1
}

# 根据系统环境安装 Neovim 二进制文件 (Linux)
install_nvim_binary_linux() {
    local glibc_ver
    glibc_ver=$(get_glibc_version)
    local download_url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"

    if [ -n "$glibc_ver" ]; then
        if [ "$(echo \"$glibc_ver < 2.31\" | bc -l)" -eq 1 ]; then
            log_warn "检测到旧版 glibc ($glibc_ver)，切换至兼容性仓库..."
            download_url="https://github.com/neovim/neovim-releases/releases/latest/download/nvim-linux-x86_64.appimage"
        fi
    fi

    log_info "正在从 GitHub 下载 Neovim AppImage..."
    curl -fsSL "$download_url" -o nvim.appimage
    chmod +x nvim.appimage

    # 兼容性处理：如果无法直接运行 AppImage (通常因 FUSE 缺失)，则解压运行
    if ! ./nvim.appimage --version &> /dev/null; then
        log_warn "环境不支持直接运行 AppImage，正在执行解压安装..."
        ./nvim.appimage --appimage-extract > /dev/null
        $SUDO rm -rf /opt/nvim
        $SUDO mv squashfs-root /opt/nvim
        $SUDO ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
        rm nvim.appimage
    else
        $SUDO mv nvim.appimage /usr/local/bin/nvim
    fi
}

# --- 4. 平台特定安装 ---
install_linux() {
    log_info "配置 Debian/Ubuntu 环境..."
    
    # 卸载旧版本
    if command -v nvim &> /dev/null; then
        log_info "清理旧版本 Neovim..."
        $SUDO apt remove -y neovim neovim-runtime || true
        $SUDO rm -f /usr/local/bin/nvim
    fi

    $SUDO apt update
    $SUDO apt install -y git curl ripgrep fd-find build-essential libfuse2 bc

    install_nvim_binary_linux

    # fd-find 软链接兼容性
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

install_macos() {
    log_info "配置 macOS 环境..."
    if ! command -v brew &> /dev/null; then
        log_error "未找到 Homebrew，请先安装: https://brew.sh/"
    fi
    brew install neovim git ripgrep fd
}

# --- 5. 配置管理 ---
setup_config() {
    if [ -d "$NVIM_CONFIG_DIR" ]; then
        log_warn "发现现有配置，备份至 ${NVIM_CONFIG_DIR}.bak"
        rm -rf "${NVIM_CONFIG_DIR}.bak"
        mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}.bak"
    fi

    log_info "克隆配置仓库..."
    git clone "$REPO_URL" "$NVIM_CONFIG_DIR"
}

sync_plugins() {
    log_info "同步插件 (Headless 模式)..."
    nvim --headless -c "Lazy! sync" -c "qa"
}

# --- 6. 主执行流 ---
main() {
    check_sudo
    
    local os_type
    os_type="$(uname)"

    if [ "$os_type" == "Darwin" ]; then
        install_macos
    elif [ -f /etc/debian_version ]; then
        install_linux
    else
        log_error "不支持的操作系统类型: $os_type"
    fi

    setup_config
    sync_plugins

    printf "\n${GREEN}Neovim 安装与配置成功！${NC}\n"
}

main "$@"