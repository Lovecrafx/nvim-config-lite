--[[
  Comment.nvim
  仓库地址: https://github.com/numToStr/Comment.nvim
  功能说明: 智能注释/取消注释插件，支持行注释和块注释
--]]
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup()
  end,
}
