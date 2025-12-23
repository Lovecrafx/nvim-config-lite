--[[
  Neovim 基础选项配置
  包含缩进、显示、搜索等通用设置
--]]

local opt = vim.opt

-- 缩进设置
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

-- 显示设置
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.wrap = false

-- 搜索设置
opt.ignorecase = true
opt.smartcase = true

-- 其它设置
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.backup = false
opt.undofile = true
