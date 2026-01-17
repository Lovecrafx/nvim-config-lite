--[[
  nvim-lspconfig
  https://github.com/neovim/nvim-lspconfig
  LSP 配置集合
--]]

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local servers = require("config.servers")

    -- LSP 能力补全
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- 通用 LSP 设置
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- 诊断符号配置
    local signs = {
      Error = "✗",
      Warn = "⚠",
      Hint = "✦",
      Info = "ℹ",
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- LSP 配置工厂函数
    local function make_lsp_config(name, settings)
      local config = { capabilities = capabilities }
      if settings then
        config.settings = settings
      end
      return config
    end

    -- 各语言服务器配置
    local lsp_configs = {
      lua_ls = make_lsp_config("lua_ls", {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
          format = { enable = false },
        },
      }),
      jsonls = make_lsp_config("jsonls", {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      }),
      yamlls = make_lsp_config("yamlls", {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          format = { enable = false },
        },
      }),
      bashls = make_lsp_config("bashls", {
        bashIde = {
          globPattern = "*@(.sh|.bash|.bashrc|.bash_profile)",
        },
      }),
      pyright = make_lsp_config("pyright", {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      }),
      ts_ls = make_lsp_config("ts_ls", {
        typescript = { format = { enable = false } },
        javascript = { format = { enable = false } },
      }),
      vue_ls = make_lsp_config("vue_ls", {
        vue = { format = { enable = false } },
      }),
      html = make_lsp_config("html", {
        html = { format = { enable = false } },
      }),
      cssls = make_lsp_config("cssls"),
    }

    -- 注册所有 LSP 配置
    for name, config in pairs(lsp_configs) do
      vim.lsp.config(name, config)
    end

    -- 启用语言服务器
    vim.lsp.enable(servers)

    -- 确保进入文件类型时 LSP 已启动
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        if #vim.lsp.get_clients({ bufnr = args.buf }) == 0 then
          vim.lsp.enable({ args.match })
        end
      end,
    })
  end,
}
