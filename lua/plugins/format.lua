--[[
  代码格式化插件
  仓库地址: https://github.com/stevearc/conform.nvim
  功能说明: 通过 LSP 实现代码格式化，开箱即用（依赖 LSP 服务器）
--]]

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  opts = {
    -- 仅使用 LSP 格式化，无需外部工具
    formatters_by_ft = {},
    -- 格式化选项
    format_on_save = {
      condition = function(buf)
        if vim.bo.buftype ~= "" or vim.api.nvim_buf_get_name(buf) == "" then
          return false
        end
        return true
      end,
      async = false,
      lsp_fallback = true,
    },
    notify_on_error = true,
  },
  init = function()
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
        local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
        range = { start = { start_line, 0 }, ["end"] = { end_line, 0 } }
      end
      require("conform").format({ range = range, lsp_fallback = true })
    end, {
      range = true,
      desc = "格式化代码",
    })
  end,
}
