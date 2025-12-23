--[[
  Git 辅助插件 (gitsigns)
  仓库地址: https://github.com/lewis6991/gitsigns.nvim
  功能说明: 显示 Git 更改状态（增加、修改、删除）、行内实时 blame（更改人、时间、内容）
--]]

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    -- 实时 blame 配置
    current_line_blame = true, -- 开启行内 blame 信息
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- blame 信息显示在行尾
      delay = 500,           -- 鼠标停顿 500ms 后显示
    },
    current_line_blame_formatter = "   <author>, <author_time:%Y-%m-%d> - <summary>",
    
    -- 符号配置
    signs = {
      add          = { text = "┃" },
      change       = { text = "┃" },
      delete       = { text = "_" },
      topdelete    = { text = "‾" },
      changedelete = { text = "~" },
      untracked    = { text = "┆" },
    },
  },
}
