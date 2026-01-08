--[[
  代码补全插件
  仓库地址: https://github.com/hrsh7th/nvim-cmp
  功能说明: 代码补全引擎，支持 LSP 补全
--]]

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "windwp/nvim-autopairs",
  },
  opts = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.setup({
      sources = {
        { name = "nvim_lsp" },
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      }),
    })
    -- 自动补全括号
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
