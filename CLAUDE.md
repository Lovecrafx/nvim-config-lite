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
    │   ├── keymaps.lua       # 全局键映射
    │   ├── autocmds.lua      # 自动命令（可选）
    │   └── lazy.lua          # Lazy.nvim 插件管理器设置（可选单独文件）
    └── plugins               # 存放插件配置
```


# 个人自定义插件
## 注释
> 每个插件的开头都要有注释,具体要求如下
> **插件名称**
> **插件仓库地址**
> **插件功能说明**

## 插件
1. onedark 主题插件
2. 符号补全插件
3. 自动缩进对齐插件
4. 语法高亮插件
  - 高亮语言(Python｜Java｜JavaScript｜TypeScript｜HTML｜CSS｜Vue｜Shell｜SQL｜YAML｜TOML)

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

- **Linux (x86_64) 兼容性测试（使用 Docker）：**
```bash
# 拉取 ubuntu 镜像并进入交互式容器
docker run -it --rm -v ~/.config/nvim:/root/.config/nvim ubuntu:22.04 /bin/bash

# 在容器内执行以下命令进行测试
# 注意：需安装最新版 neovim 和 git，否则插件可能安装失败
apt update && apt install -y curl git
LATEST=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
curl -sL "https://github.com/neovim/neovim/releases/download/${LATEST}/nvim-linux-x86_64.tar.gz" | tar xz
./nvim-linux-x86_64/bin/nvim --headless +qa
./nvim-linux-x86_64/bin/nvim --headless -c "Lazy! sync" -c "qa"
```

# git
- 该项目的主分支名为"main"。
- git commit格式规范请遵守:https://www.conventionalcommits.org/zh-hans/v1.0.0/#%e7%ba%a6%e5%ae%9a%e5%bc%8f%e6%8f%90%e4%ba%a4%e8%a7%84%e8%8c%83
- git commit 描述部分请使用中文.
- 推送到远程仓库（git push）的操作必须先获得用户的明确同意。

# 角色
您是一位 Neovim + Lua 专家，帮助用户编写更高效、更易优化的 neovim 配置。

# 一般要求
- If there is something you do not understand or is ambiguous, seek confirmation or clarification from the user before making changes based on assumptions.
- Only write high-value comments if at all. Avoid talking to the user through comments.

# 兼容性
- 尽可能的保持 Mac/Linux的兼容性