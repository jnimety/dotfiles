local format = function(d)
  local code = d.code or (d.user_data and d.user_data.lsp.code)

  if code then
    return string.format("%s [%s]", d.message, code):gsub("1. ", "")
  end

  return d.message
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local builtin = require('telescope.builtin')

  local keymap_opts = function(desc)
    return { noremap = true, silent = true, buffer = bufnr, desc = desc }
  end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions

  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, keymap_opts("[R]e[n]ame reference under cursor"))
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, keymap_opts("[C]ode [A]ction"))
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, keymap_opts("Prev Diagnostic"))
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, keymap_opts("Next Diagnostic"))
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, keymap_opts("Line Diagnostics"))
  vim.keymap.set('n', 'gd', builtin.lsp_definitions, keymap_opts("[G]oto [D]efinition"))
  vim.keymap.set('n', 'gr', builtin.lsp_references, keymap_opts("[G]oto [R]eferences"))
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts("[G]oto [D]eclaration"))
  vim.keymap.set('n', 'gI', builtin.lsp_implementations, keymap_opts("[G]oto [I]mplementation"))
  vim.keymap.set('n', 'go', builtin.lsp_type_definitions, keymap_opts("[G]oto Type Definition"))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts("Hover"))
  vim.keymap.set('n', 'gK', vim.lsp.buf.signature_help, keymap_opts("Signature Help"))

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })

  vim.keymap.set('n', '<leader>cf', vim.cmd.Format, keymap_opts("[C]ode [F]ormat Document"))
  vim.keymap.set('v', '<leader>cf', vim.cmd.Format, keymap_opts("[C]ode [F]ormat Range"))
end

return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      'williamboman/mason.nvim',
      "jayp0521/mason-null-ls.nvim"
    },
    opts = function()
      local null_ls = require("null-ls")

      return {
        on_attach = on_attach,
        sources = {
          null_ls.builtins.formatting.prettierd.with({
            filetypes = {
              "css", "scss", "less",
              "html",
              "yaml",
              "markdown", "markdown.mdx",
              "graphql",
              "handlebars"
            }
          }),
          null_ls.builtins.diagnostics.haml_lint.with({
            env = {
              RUBYOPT = "-W0",
            }
          }),
          null_ls.builtins.code_actions.gitsigns,
        },
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      window = {
        blend = 100,
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    cmd = "LspInfo",
    event = "BufReadPre",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      'hrsh7th/cmp-nvim-lsp',
    },
    config = function(_, _)
      vim.diagnostic.config({
        signs = {
          active = true,
          values = {
            { name = "DiagnosticSignError", text = "" },
            { name = "DiagnosticSignWarn", text = "" },
            { name = "DiagnosticSignHint", text = "" },
            { name = "DiagnosticSignInfo", text = "" },
          },
        },
        virtual_text = {
          format = format
        },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "single",
          source = "always",
          header = "",
          prefix = "",
          format = format,
        }
      })

      local float_config = {
        focusable = true,
        style = "minimal",
        border = "single",
      }
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      local lspconfig = require('lspconfig')
      local servers_with_defaults = {
        "dockerls", "rust_analyzer", "terraformls", "yamlls"
      }

      for _, server in pairs(servers_with_defaults) do
        lspconfig[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end

      lspconfig.eslint.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        -- yarn pnp compatible way of running js language server, see package.json:scripts
        cmd = { "yarn", "pnp-vscode-eslint-language-server", "--stdio" },
      }

      lspconfig.jsonls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        -- yarn pnp compatible way of running js language server, see package.json:scripts
        cmd = { "yarn", "pnp-vscode-json-language-server", "--stdio" },
      }

      lspconfig.sorbet.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
      }

      -- lspconfig.steep.setup {
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      --   filetypes = { "ruby", "eruby", "rbs" },
      -- }

      lspconfig.ruby_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "bundle", "exec", "ruby-lsp" },
        initOptions = {
          enabledFeatures = {
            "codeActions",
            -- "diagnostics", -- handled by solargraph
            -- "documentHighlights", -- handled by sorbet
            -- "documentSymbols", -- handled by sorbet
            "formatting", -- handled by sorbet
            -- "inlayHint",
          }
        }
      }

      lspconfig.solargraph.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "bundle", "exec", "solargraph", "stdio" },
        settings = {
          solargraph = {
            autoformat = false,
            completion = false,
            definitions = false,
            diagnostics = true,
            folding = false,
            formatting = false,
            hover = false,
            references = false,
            rename = false,
            symbols = false,
          }
        },
      }

      lspconfig.stylelint_lsp.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        -- yarn pnp compatible way of running js language server, see package.json:scripts
        cmd = { "yarn", "pnp-stylelint-lsp", "--stdio" },
        filetypes = {
          'css',
          'less',
          'postcss',
          'scss',
        },
        settings = {
          stylelintplus = {
            enable = true,
            autoFixOnFormat = true,
            cssInJs = false,
            validateOnType = true,
          },
        },
      }

      -- Make runtime files discoverable to the server
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      lspconfig.sumneko_lua.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT)
              version = 'LuaJIT',
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      }

      lspconfig.tsserver.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        -- yarn pnp compatible way of running js language server, see package.json:scripts
        cmd = { "yarn", "pnp-typescript-language-server", "--stdio" },
      }

    end
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      ensure_installed = {
        "prettierd",
        "haml-lint",
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
        ensure_installed = {
          "dockerls",
          "eslint",
          "jsonls",
          "ruby_ls",
          "rust_analyzer",
          "solargraph",
          "sorbet",
          "stylelint_lsp",
          "sumneko_lua",
          "terraformls",
          "tsserver",
          "yamlls",
        }
      })

      require("mason-null-ls").setup({
        ensure_installed = nil,
        automatic_installation = true,
        automatic_setup = false,
      })
    end,
  },
}
