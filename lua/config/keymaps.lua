--[[
  全局键位映射配置
  定义常用的快捷键，增强编辑效率
--]]

local keymap = vim.keymap

-- 设置主键为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 快速保存和退出
keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存文件" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "退出" })

-- 窗口切换
keymap.set("n", "<C-h>", "<C-w>h", { desc = "切换到左侧窗口" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "切换到下方窗口" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "切换到上方窗口" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "切换到右侧窗口" })

-- 视觉模式下移动选中文本
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- 取消搜索高亮
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "取消搜索高亮" })
