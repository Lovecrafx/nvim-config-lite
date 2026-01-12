# Neovim 配置

基于 Lua 和 Lazy.nvim 的 Neovim 配置，支持 macOS 与 Linux。

## 快速安装 (Linux)

### 前置要求
- Debian/Ubuntu 系统
- 普通用户（需有 sudo 权限）或 root 用户

### 安装步骤

1. **下载安装脚本**：
   ```bash
   curl -fsSL https://raw.githubusercontent.com/Lovecrafx/nvim-config-lite/main/install.sh -o install.sh
   ```

2. **执行安装**：
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **启动 Neovim**：
   ```bash
   nvim
   ```

### 安装过程说明

脚本会自动执行以下操作：

| 步骤 | 操作 |
|------|------|
| 1 | 检查 sudo 权限 |
| 2 | 安装系统依赖（git、curl、ripgrep、fd-find、build-essential、bc） |
| 3 | 下载并安装 Neovim v0.11.2（自动适配 x86_64/arm64 架构） |
| 4 | 处理 AppImage 兼容性问题（如系统无 FUSE 则自动解压） |
| 5 | 克隆配置仓库至 `~/.config/nvim` |
| 6 | 自动同步所有插件 |

### 系统要求

- **glibc 版本**：≥ 2.27（Neovim 0.11.2 要求）
- **支持架构**：x86_64、arm64

## 手动安装

```bash
# 1. 安装依赖
sudo apt update
sudo apt install -y git curl ripgrep fd-find build-essential bc

# 2. 下载 Neovim
curl -fsSL https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.appimage -o nvim.appimage
chmod +x nvim.appimage

# 3. 安装 Neovim（处理 FUSE 兼容性）
sudo mv nvim.appimage /usr/local/bin/nvim

# 4. 克隆配置
git clone https://github.com/Lovecrafx/nvim-config-lite.git ~/.config/nvim

# 5. 同步插件
nvim --headless -c "Lazy! sync" -c "qa"
```

## 插件列表

| 插件 | 功能 |
|------|------|
| onedark | 主题配色 |
| nvim-autopairs | 自动补全括号、引号等配对符号 |
| indent-blankline | 缩进线显示 |
| nvim-treesitter | 语法高亮 |
| gitsigns | Git 状态与 blame |
| nvim-cmp | 代码补全引擎 |
| nvim-lspconfig | LSP 语言服务器配置 |
| mason | LSP 服务器管理 |

## 快捷键

| 快捷键 | 功能 |
|--------|------|
| `<leader>w` | 保存文件 |
| `<leader>q` | 退出 |
| `<leader>nh` | 取消搜索高亮 |
| `<leader>f` | 格式化代码 |
| `<C-h/j/k/l>` | 切换窗口 |
| `J/K` (visual) | 移动选中行 |

## 项目结构

```text
~/.config/nvim
|-- init.lua
`-- lua
    |-- config/
    |   |-- options.lua    # vim 选项
    |   |-- keymaps.lua    # 键位映射
    |   |-- autocmds.lua   # 自动命令
    |   `-- lazy.lua       # 插件管理器
    `-- plugins/
        |-- onedark.lua    # 主题配色（onedark）
        |-- treesitter.lua # 语法高亮（nvim-treesitter）
        |-- indent.lua     # 缩进线显示（indent-blankline/ibl）
        |-- autopairs.lua  # 符号补全（nvim-autopairs）
        |-- git.lua        # Git 标记与 blame（gitsigns）
        `-- lsp/
            |-- init.lua      # LSP 基础配置
            |-- cmp.lua       # 代码补全引擎（nvim-cmp）
            |-- lspconfig.lua # LSP 配置（lspconfig）
            `-- mason.lua     # LSP 服务器管理（mason）
```

## 验证配置

```bash
# 检查语法
nvim --headless +qa

# 同步插件
nvim --headless -c "Lazy! sync" -c "qa"
```
