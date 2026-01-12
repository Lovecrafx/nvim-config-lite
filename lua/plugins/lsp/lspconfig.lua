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

    -- 注册语言服务器配置
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
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
      },
    })

    vim.lsp.config("jsonls", {
      capabilities = capabilities,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config("yamlls", {
      capabilities = capabilities,
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          format = { enable = false },
        },
      },
    })

    vim.lsp.config("bashls", {
      capabilities = capabilities,
      settings = {
        bashIde = {
          globPattern = "*@(.sh|.bash|.bashrc|.bash_profile)",
        },
      },
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    })

    vim.lsp.config("ts_ls", {
      capabilities = capabilities,
      settings = {
        typescript = { format = { enable = false } },
        javascript = { format = { enable = false } },
      },
    })

    vim.lsp.config("vue_ls", {
      capabilities = capabilities,
      settings = {
        vue = { format = { enable = false } },
      },
    })

    vim.lsp.config("html", {
      capabilities = capabilities,
      settings = {
        html = { format = { enable = false } },
      },
    })

    vim.lsp.config("cssls", {
      capabilities = capabilities,
    })

    -- 根据 filetype 启用语言服务器
    vim.lsp.enable({
      "lua_ls",
      "jsonls",
      "yamlls",
      "bashls",
      "pyright",
      "ts_ls",
      "vue_ls",
      "html",
      "cssls",
    })

    -- 确保进入文件类型时 LSP 已启动
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(args)
        local filetype = args.match
        -- 获取当前 buffer 的语言服务器
        local clients = vim.lsp.get_clients({ bufnr = args.buf })
        if #clients == 0 then
          vim.lsp.enable({ filetype })
        end
      end,
    })

    -- LSP 快捷键
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "跳转到定义" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "查找引用" })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "悬停信息" })
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "显示诊断信息" })
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "上一个诊断" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "下一个诊断" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "代码操作" })
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "格式化代码" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "重命名" })
  end,
}
