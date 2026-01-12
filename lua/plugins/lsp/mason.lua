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

    require("mason-lspconfig").setup({
      ensure_installed = {
        -- lspconfig 服务器名 (mason-lspconfig 会自动映射到 mason 包名)
        "lua_ls",   -- Lua
        "jsonls",   -- JSON
        "yamlls",   -- YAML
        "bashls",   -- Bash
        "pyright",  -- Python
        "ts_ls",    -- TypeScript/JavaScript
        "vue_ls",   -- Vue
        "html",     -- HTML
        "cssls",    -- CSS
      },
      automatic_installation = true,
    })
  end,
}
