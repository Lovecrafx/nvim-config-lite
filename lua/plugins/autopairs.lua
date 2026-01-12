--[[
  nvim-autopairs
  https://github.com/windwp/nvim-autopairs
  自动补全括号、引号、花括号等配对符号
--]]

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- 启用 treesitter 检查
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      python = { "string", "source" },
    },
    fast_wrap = {},
  },
}
