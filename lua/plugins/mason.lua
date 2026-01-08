--[[
  Mason 插件管理
  仓库地址: https://github.com/williamboman/mason.nvim
  功能说明: LSP 服务器、DAP 服务器、格式化器等工具管理
--]]

return {
  "williamboman/mason.nvim",
  event = "BufEnter",
  opts = {
    ui = {
      border = "rounded",
      height = 0.8,
      width = 0.8,
    },
    -- 自动安装的 LSP 服务器
    ensure_installed = {
      "lua-language-server",
      "pyright",
      "typescript-language-server",
      "html-lsp",
      "css-lsp",
      "vue-language-server",
      "bash-language-server",
      "sqlfmt",
      "yaml-language-server",
      "taplo",
      "lemminx",
    },
  },
}
