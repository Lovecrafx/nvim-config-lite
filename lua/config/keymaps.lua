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

-- 代码格式化 (由 LSP 提供)
keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "格式化代码" })

-- LSP 快捷键
keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "跳转到定义" })
keymap.set("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "悬停信息" })
keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "显示诊断信息" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "代码操作" })
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "重命名" })

-- 鼠标选择文本后自动复制到系统剪贴板
keymap.set("x", "<LeftRelease>", '"*ygv', { desc = "鼠标释放时复制到剪贴板" })
keymap.set("x", "<2-LeftRelease>", '"*ygv', { desc = "双击选择时复制到剪贴板" })
