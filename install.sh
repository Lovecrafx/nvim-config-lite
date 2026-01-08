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
    # 确保 bc 可用于版本比较
    if ! command -v bc >/dev/null 2>&1; then
        log_info "安装 bc 依赖..."
        $SUDO apt update -qq
        $SUDO apt install -y bc
    fi

    local glibc_ver
    glibc_ver=$(get_glibc_version)
    local nvim_version="v0.11.2"

    # Neovim 0.11.2 需要 glibc >= 2.27
    if [ -n "$glibc_ver" ]; then
        if [ "$(echo "$glibc_ver < 2.27" | bc -l)" -eq 1 ]; then
            log_error "检测到旧版 glibc ($glibc_ver)，Neovim 0.11.2 需要 glibc >= 2.27。请升级系统后重试。"
        fi
    fi

    # 检测系统架构
    local arch
    arch=$(uname -m)
    case "$arch" in
        x86_64)
            arch="x86_64"
            ;;
        aarch64|arm64)
            arch="arm64"
            ;;
        *)
            log_error "不支持的架构: $arch"
            ;;
    esac

    local download_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/nvim-linux-${arch}.appimage"

    log_info "将安装 Neovim ${nvim_version} (${arch})"

    log_info "正在从 GitHub 下载 Neovim AppImage..."
    if ! curl -fsSL --connect-timeout 30 --max-time 300 "$download_url" -o nvim.appimage; then
        log_error "下载 Neovim 失败，请检查网络连接或手动下载: $download_url"
    fi

    chmod +x nvim.appimage

    # 兼容性处理：如果无法直接运行 AppImage (通常因 FUSE 缺失)，则解压运行
    local appimage_error
    appimage_error=$(./nvim.appimage --version 2>&1) || true

    if [ -n "$appimage_error" ]; then
        log_warn "AppImage 直接运行失败: $appimage_error"
        log_info "正在执行解压安装..."

        if ! ./nvim.appimage --appimage-extract > /dev/null 2>&1; then
            log_error "AppImage 解压失败，文件可能已损坏"
        fi

        $SUDO rm -rf /opt/nvim 2>/dev/null || true
        $SUDO mv squashfs-root /opt/nvim
        $SUDO ln -sf /opt/nvim/AppRun /usr/local/bin/nvim
        rm -f nvim.appimage
        log_info "Neovim 已安装至 /opt/nvim"
    else
        $SUDO mv nvim.appimage /usr/local/bin/nvim
        log_info "Neovim 已安装至 /usr/local/bin/nvim"
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

    # 动态选择 libfuse 包名 (Ubuntu 22.04+ 需要 libfuse2t64)
    local fuse_pkg="libfuse2"
    if apt-cache show libfuse2t64 &>/dev/null; then
        fuse_pkg="libfuse2t64"
    fi

    $SUDO apt install -y git curl ripgrep fd-find build-essential $fuse_pkg bc

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
