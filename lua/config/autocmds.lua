--[[
  自动命令配置
  定义在特定事件触发时自动执行的操作
--]]

local autocmd = vim.api.nvim_create_autocmd

-- 复制时高亮
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 40,
    })
  end,
})

-- 自动去除行尾空格 (可选)
-- autocmd("BufWritePre", {
--   pattern = "*",
--   command = [[%s/\s\+$//e]],
-- })
