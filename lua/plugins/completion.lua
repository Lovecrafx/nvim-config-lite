--[[
  符号补全插件
  仓库地址: https://github.com/windwp/nvim-autopairs
  功能说明: 自动补全括号、引号等符号
--]]

return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true,
  },
}
