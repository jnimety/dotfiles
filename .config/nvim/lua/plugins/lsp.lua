vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local buffer = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client then
      -- local builtin = require("telescope.builtin")
      local builtin = Snacks.picker

      local keymap_opts = function(desc)
        return { noremap = true, silent = true, buffer = buffer, desc = desc }
      end

      -- Enable completion triggered by <c-x><c-o>
      vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions

      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, keymap_opts("[R]e[n]ame reference under cursor"))
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, keymap_opts("[C]ode [A]ction"))
      vim.keymap.set(
        "n",
        "<leader>ch",
        vim.lsp.buf.document_highlight,
        keymap_opts("[C]ode [H]ighlight reference under cursor")
      )
      vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, keymap_opts("[C]ode [L]ens"))
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, keymap_opts("Prev Diagnostic"))
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, keymap_opts("Next Diagnostic"))
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymap_opts("Line Diagnostics"))
      vim.keymap.set("n", "gd", builtin.lsp_definitions, keymap_opts("[G]oto [D]efinition"))
      vim.keymap.set("n", "gr", builtin.lsp_references, keymap_opts("[G]oto [R]eferences"))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts("[G]oto [D]eclaration"))
      vim.keymap.set("n", "gI", builtin.lsp_implementations, keymap_opts("[G]oto [I]mplementation"))
      vim.keymap.set("n", "go", builtin.lsp_type_definitions, keymap_opts("[G]oto Type Definition"))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts("Hover"))
      vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, keymap_opts("Signature Help"))
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, keymap_opts("[T]oggle LSP Inlay [H]ints"))

      -- `:lua =vim.lsp.get_active_clients()[1].server_capabilities` to list capabilities
      if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
          buffer = buffer,
          callback = function()
            vim.lsp.buf.clear_references()
          end,
        })
      end

      if client.server_capabilities.codeLensProvider then
        -- vim.notify("enabling codelens")
        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
          buffer = buffer,
          callback = function()
            vim.lsp.codelens.enable(true, { bufnr = buffer })
          end,
        })
      end
    end
  end,
})

return {
  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "mason-org/mason.nvim",
      { "saghen/blink.cmp", branch = "v1" },
    },
    config = function()
      vim.diagnostic.config({
        signs = {
          active = true,
          values = {
            { name = "DiagnosticSignError", text = require("defaults").icons.diagnostics.Error },
            { name = "DiagnosticSignWarn", text = require("defaults").icons.diagnostics.Warn },
            { name = "DiagnosticSignHint", text = require("defaults").icons.diagnostics.Hint },
            { name = "DiagnosticSignInfo", text = require("defaults").icons.diagnostics.Info },
          },
        },
        virtual_text = {
          -- format = format,
          spacing = 4,
          prefix = "●",
        },
        severity_sort = true,
        float = {
          focusable = true,
          focus = true,
          -- style = "minimal",
          -- border = "rounded",
          source = true,
          -- header = "",
          -- prefix = "",
          -- format = format,
        },
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "ansible-lint",
        "codespell",
        "hadolint",
        "helm-ls",
        "herb-language-server",
        "openscad-lsp",
        "prettierd",
        "shellcheck",
        "shfmt",
        "sql-formatter",
        "stylua",
        "tree-sitter-cli",
        "typescript-language-server",
        "yamlfmt",
      },
      ui = {
        check_outdated_packages_on_open = false,
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end

      require("mason-lspconfig").setup({
        automatic_enable = true,
        automatic_installation = false,
        ensure_installed = {
          "ansiblels",
          "bashls",
          -- "biome", -- add to project package.json instead
          "dockerls",
          -- "ruby_lsp", -- add to project Gemfile instead
          "rust_analyzer",
          -- "sorbet", -- add to project Gemfile instead
          "lua_ls",
          "tailwindcss",
          "terraformls",
          "ts_ls",
          "yamlls",
        },
      })

      -- enable servers mason-lspconfig doesn't know about
      vim.lsp.enable({ "biome", "ruby_lsp", "sorbet" })
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
  },
}
