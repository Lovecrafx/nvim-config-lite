# **该项目主要存储neovim的配置**
>使用lua语言,包括插件,neovim支持lua
>所有配置要考虑到 mac｜linux｜windows 的兼容性


# **项目结构**
```txt
~/.config/nvim
├── init.lua                  # 主入口：bootstrap Lazy.nvim 并加载配置
└── lua
    ├── config                # 核心配置模块
    │   ├── options.lua       # vim.opt 设置
    │   ├── keymaps.lua       # 全局快捷键配置（所有快捷键集中管理）
    │   ├── autocmds.lua      # 自动命令（可选）
    │   └── lazy.lua          # Lazy.nvim 插件管理器设置（可选单独文件）
    └── plugins               # 存放插件配置
        ├── onedark.lua       # 主题插件
        ├── treesitter.lua    # 语法高亮插件
        ├── indent.lua        # 自动缩进对齐插件
        ├── autopairs.lua     # 符号补全插件
        ├── git.lua           # Git 集成插件
        └── lsp               # LSP 语言服务器支持
            ├── init.lua      # LSP 基础配置
            ├── cmp.lua       # 代码补全引擎 (nvim-cmp)
            ├── lspconfig.lua # LSP 配置 (lspconfig)
            └── mason.lua     # LSP 服务器管理 (mason)
```


# Building and running
在提交任何更改之前，务必运行命令进行验证配置是否有效。

- **检查配置语法和逻辑错误：**
```bash
nvim --headless +qa
```

- **同步插件并验证配置：**
```bash
nvim --headless -c "Lazy! sync" -c "qa"
```

## Git 规范

| 规则 | 说明 |
|------|------|
| 主分支 | `main` |
| 提交格式 | 遵循 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/v1.0.0/) |
| 提交描述 | 使用中文 |
| 代码推送 | 需用户明确同意后执行 |

# 角色
您是一位 Neovim + Lua 专家，帮助用户编写更高效、更易优化的 neovim 配置。

# 一般要求
- If there is something you do not understand or is ambiguous, seek confirmation or clarification from the user before making changes based on assumptions.
- Only write high-value comments if at all. Avoid talking to the user through comments.

# 兼容性
- 尽可能的保持 Mac/Linux的兼容性