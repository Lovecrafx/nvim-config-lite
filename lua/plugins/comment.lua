--[[
  Comment.nvim
  仓库地址: https://github.com/numToStr/Comment.nvim
  功能说明: 智能注释/取消注释插件，支持行注释和块注释

  使用示例:
    - gcc: 注释/取消注释当前行
    - gbc: 块注释/取消注释
    - gc[motion]: 对 motions 范围注释 (如 gcip 注释段落)
    - gb[motion]: 对 motions 范围块注释
    - Normal mode: gcw 注释当前词
    - Visual mode: gc 注释选中区域
--]]
return {
  "numToStr/Comment.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("Comment").setup()
  end,
}
