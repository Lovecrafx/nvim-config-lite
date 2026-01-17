--[[
  Lazy.nvim 插件管理器配置
  自动安装并加载插件
--]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.lsp" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "onedark" } },
  checker = {
    enabled = true,
    notify = false,
    frequency = 7,
  },
  change_detection = {
    notify = true,
  },
})
