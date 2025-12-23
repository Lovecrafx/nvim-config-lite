--[[
  语法高亮插件
  仓库地址: https://github.com/nvim-treesitter/nvim-treesitter
  功能说明: 提供基于 Treesitter 的强大语法高亮
--]]

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- 确保安装指定的语言高亮
    ensure_installed = {
      "python",
      "java",
      "javascript",
      "typescript",
      "html",
      "css",
      "vue",
      "bash",
      "sql",
      "lua",
      "vim",
      "vimdoc",
      "markdown",
      "markdown_inline",
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  },
}
