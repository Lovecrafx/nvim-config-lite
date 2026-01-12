--[[
  mason.nvim
  https://github.com/williamboman/mason.nvim
  语言服务器安装管理工具
--]]

return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local servers = require("config.servers")

    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })
  end,
}
