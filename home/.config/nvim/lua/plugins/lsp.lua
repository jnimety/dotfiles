vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(args)
    local buffer = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client then
      local builtin = require("telescope.builtin")

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
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, keymap_opts("Prev Diagnostic"))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, keymap_opts("Next Diagnostic"))
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, keymap_opts("Line Diagnostics"))
      vim.keymap.set("n", "gd", builtin.lsp_definitions, keymap_opts("[G]oto [D]efinition"))
      vim.keymap.set("n", "gr", builtin.lsp_references, keymap_opts("[G]oto [R]eferences"))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, keymap_opts("[G]oto [D]eclaration"))
      vim.keymap.set("n", "gI", builtin.lsp_implementations, keymap_opts("[G]oto [I]mplementation"))
      vim.keymap.set("n", "go", builtin.lsp_type_definitions, keymap_opts("[G]oto Type Definition"))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts("Hover"))
      vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, keymap_opts("Signature Help"))
      vim.keymap.set("n", "<leader>th", function()
        vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
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
            vim.lsp.codelens.refresh({ bufnr = 0 })
          end,
        })
      end

      -- if client.server_capabilities.inlayHintProvider then
      --   -- vim.notify("enabling inlay_hint")
      --   vim.lsp.inlay_hint.enable(buffer, true)
      -- end
    end
  end,
})

return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
      "jayp0521/mason-null-ls.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")

      return {
        sources = {
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.diagnostics.hadolint,
          null_ls.builtins.diagnostics.haml_lint.with({
            command = { "bundle", "exec", "haml-lint" },
            env = {
              RUBYOPT = "-W0",
            },
          }),
          null_ls.builtins.diagnostics.terraform_validate,
        },
      }
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.0.0",
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",

      -- Useful status updates for LSP
      "j-hui/fidget.nvim",

      "hrsh7th/cmp-nvim-lsp",
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
          border = "rounded",
          source = true,
          -- header = "",
          -- prefix = "",
          -- format = format,
        },
      })

      local float_config = {
        focusable = true,
        focus = true,
        -- style = "minimal",
        border = "rounded",
        source = "if_many",
      }
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, float_config)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, float_config)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local lspconfig = require("lspconfig")
      local servers_with_defaults = {
        "bashls",
        -- "cssls",
        "dockerls",
        -- "ocamllsp",
        "openscad_lsp",
        "tailwindcss",
        "terraformls",
        "yamlls",
      }

      for _, server in pairs(servers_with_defaults) do
        lspconfig[server].setup({
          capabilities = capabilities,
        })
      end

      lspconfig.helm_ls.setup({
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "/Users/jnimety/.local/share/nvim/mason/bin/yaml-language-server",
            },
          },
        },
      })

      lspconfig.eslint.setup({
        capabilities = capabilities,
        cmd = { "pnpm", "pnp-vscode-eslint-language-server", "--stdio" },
      })

      lspconfig.jsonls.setup({
        capabilities = capabilities,
        cmd = { "pnpm", "pnp-vscode-json-language-server", "--stdio" },
      })

      lspconfig.sorbet.setup({
        capabilities = capabilities,
        filetypes = { "ruby" },
        cmd = { "bundle", "exec", "srb", "typecheck", "--lsp", "--enable-experimental-lsp-signature-help" },
      })

      -- lspconfig.steep.setup {
      --   capabilities = capabilities,
      --   filetypes = { "ruby", "eruby", "rbs" },
      --   cmd = { "bundle", "exec", "steep", "langserver" },
      -- }

      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        cmd = { "bundle", "exec", "ruby-lsp" },
        init_options = {
          enabledFeatures = {
            "codeActions",
            -- "codeLens",
            -- "completion",
            -- "definition",
            "diagnostics",
            "documentHighlights",
            -- "documentLink",
            "documentSymbols",
            -- "foldingRanges",
            "formatting",
            -- "hover",
            "inlayHint",
            -- "onTypeFormatting",
            -- "references",
            -- "selectionRanges",
            -- "semanticHighlighting"
            -- "workspaceSymbol",
          },
        },
      })

      lspconfig.stylelint_lsp.setup({
        capabilities = capabilities,
        cmd = { "pnpm", "pnp-stylelint-lsp", "--stdio" },
        filetypes = {
          "css",
          "less",
          "postcss",
          "scss",
        },
        settings = {
          stylelintplus = {
            enable = true,
            autoFixOnFormat = true,
            cssInJs = false,
            validateOnType = true,
          },
        },
      })

      -- Make runtime files discoverable to the server
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            format = {
              -- format settings go in ~/.editorconfig or a project specific .editorconfig
              -- options specific to this formatter: https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/lua.template.editorconfig
              enable = false,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT)
              version = "LuaJIT",
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              globals = { "vim" },
              neededFileStatus = {
                ["codestyle-check"] = "Any",
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        cmd = { "pnpm", "pnp-typescript-language-server", "--stdio" },
        init_options = {
          preferences = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
            quotePreference = "auto",
          },
        },
        settings = {
          typescript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              semicolons = "insert",
            },
          },
        },
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "codespell",
        "eslint-lsp",
        "json-lsp",
        -- "haml-lint", -- add to project Gemfile instead
        "hadolint",
        "helm-ls",
        "openscad-lsp",
        "prettierd",
        "stylua",
        "stylelint-lsp",
        "sql-formatter",
        "typescript-language-server",
      },
      ui = {
        check_outdated_packages_on_open = false,
        border = "rounded",
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
        automatic_installation = false,
        ensure_installed = {
          "bashls",
          -- "cssls",
          "dockerls",
          "eslint",
          "hadolint",
          "jsonls",
          -- "ruby_ls", -- add to project Gemfile instead
          "rust_analyzer",
          -- "sorbet", -- add to project Gemfile instead
          "stylelint_lsp",
          "lua_ls",
          "tailwindcss",
          "terraformls",
          "tsserver",
          "yamlls",
        },
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
  },

  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- rust-tools options
      tools = {
        autoSetHints = true,
        inlay_hints = {
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
        },
      },

      -- all the opts to send to nvim-lspconfig
      -- these override the defaults set by rust-tools.nvim
      --
      -- REFERENCE:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      -- https://rust-analyzer.github.io/manual.html#configuration
      -- https://rust-analyzer.github.io/manual.html#features
      --
      -- NOTE: The configuration format is `rust-analyzer.<section>.<property>`.
      --       <section> should be an object.
      --       <property> should be a primitive.
      server = {
        on_attach = function(_, bufnr)
          local bufopts = { noremap = true, silent = true, buffer = bufnr }

          vim.keymap.set("n", "<leader><leader>rr", "<cmd>RustRunnables<cr>", bufopts)
          vim.keymap.set("n", "K", "<cmd>RustHoverActions<cr>", bufopts)
        end,

        ["rust-analyzer"] = {
          -- to enable rust-analyzer settings visit:
          -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
          assist = {
            importEnforceGranularity = true,
            importPrefix = "create",
          },
          cargo = {
            allFeatures = true,
          },
          checkOnSave = {
            -- default: `cargo check`
            command = "clippy",
            allFeatures = true,
          },
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true,
          },
        },
      },
    },
  },
}
