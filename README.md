# Neovim 配置

基于 Lua 和 Lazy.nvim 的 Neovim 配置，支持 macOS 与 Linux。

## 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/Lovecrafx/nvim-config-lite/main/install.sh | bash
```

> 支持 macOS 与 Linux。安装完成后运行 `nvim` 启动。

## 一键更新

```bash
cd ~/.config/nvim && ./update.sh
```

或远程执行：

```bash
curl -fsSL https://raw.githubusercontent.com/Lovecrafx/nvim-config-lite/main/update.sh | bash
```

### 更新内容

| 操作 | 说明 |
|------|------|
| `git pull` | 获取最新配置变更 |
| `Lazy! sync` | 同步/更新所有插件 |
| `nvim --headless +qa` | 验证配置语法 |

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
