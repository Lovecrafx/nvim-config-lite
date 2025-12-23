--[[
  onedark 主题插件
  仓库地址: https://github.com/navarasu/onedark.nvim
  功能说明: One Dark 主题配色方案
--]]

return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("onedark").setup({
      style = "darker",
    })
    require("onedark").load()
  end,
}
