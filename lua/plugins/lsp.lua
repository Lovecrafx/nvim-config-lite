--[[
  Mason LSP Config 插件
  仓库地址: https://github.com/williamboman/mason-lspconfig.nvim
  功能说明: 自动配置 Mason 安装的 LSP 服务器
--]]

return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      "lua_ls",
      "yamlls",
      "taplo",
      "jsonls",
      "bashls",
      "lemminx",
    },
    automatic_installation = true,
  },
}
