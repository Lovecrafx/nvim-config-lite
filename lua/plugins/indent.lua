--[[
  自动缩进对齐插件
  仓库地址: https://github.com/lukas-reineke/indent-blankline.nvim
  功能说明: 在代码中显示缩进线，提高代码结构清晰度
--]]

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│",
    },
    scope = {
      enabled = false,
    },
  },
}
