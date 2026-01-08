--[[
  LSP 配置插件
  仓库地址: https://github.com/neovim/nvim-lspconfig
  功能说明: LSP 服务器配置
--]]

return {
  "neovim/nvim-lspconfig",
  dependencies = { "williamboman/mason-lspconfig.nvim" },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Lua LSP 配置
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = {
              indent_style = "space",
              indent_size = "2",
            },
          },
        },
      },
    })
    vim.lsp.enable("lua_ls")
  end,
}
