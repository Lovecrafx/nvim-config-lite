--[[
  nvim-cmp
  https://github.com/hrsh7th/nvim-cmp
  代码补全引擎
--]]

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- 补全配置
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 100 },
        { name = "luasnip", priority = 50 },
        { name = "buffer", priority = 25 },
        { name = "path", priority = 10 },
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind_icons = {
            Text = "✦",
            Method = "f",
            Function = "ƒ",
            Constructor = "⚙",
            Field = "◇",
            Variable = "▣",
            Class = "⚛",
            Interface = "◈",
            Module = "📦",
            Property = "▢",
            Unit = "⚡",
            Value = "⚔",
            Enum = "⇄",
            Keyword = "⚑",
            Snippet = "✂️",
            Color = "✏",
            File = "📄",
            Reference = "📑",
            Folder = "📂",
            EnumMember = "≡",
            Constant = "☌",
            Struct = "⛓",
            Event = "⋈",
            Operator = "∘",
            TypeParameter = "⏣",
          }
          vim_item.kind = kind_icons[vim_item.kind] .. " " .. vim_item.kind
          vim_item.menu = ({
            nvim_lsp = "[LSP]",
            buffer = "[Buffer]",
            path = "[Path]",
            luasnip = "[Snippet]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })

    -- 搜索补全
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- 命令行补全
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
      matching = {
        disallow_fuzzy_matching = false,
        disallow_partial_matching = false,
      },
    })

    -- luasnip 配置
    require("luasnip.loaders.from_snipmate").lazy_load()
  end,
}
