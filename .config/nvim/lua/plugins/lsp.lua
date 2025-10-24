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
      "mason-org/mason.nvim",
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
    "neovim/nvim-lspconfig",
    cmd = "LspInfo",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      "mason-org/mason.nvim",
      "saghen/blink.cmp",
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

      local float_config = {
        focusable = true,
        focus = true,
        -- style = "minimal",
        -- border = "rounded",
        source = "if_many",
      }
      vim.lsp.buf.hover(float_config)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.signature_help(float_config)

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

      local servers_with_defaults = {
        "bashls",
        "cssls",
        "dockerls",
        "herb_ls",
        -- "ocamllsp",
        "openscad_lsp",
        "tailwindcss",
        "terraformls",
        "yamlls",
      }

      for _, server in pairs(servers_with_defaults) do
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
      end

      vim.lsp.config("helm_ls", {
        settings = {
          ["helm-ls"] = {
            yamlls = {
              path = "/Users/jnimety/.local/share/nvim/mason/bin/yaml-language-server",
            },
          },
        },
      })

      vim.lsp.config("biome", {
        capabilities = capabilities,
        cmd = { "pnpm", "biome", "lsp-proxy" },
      })

      -- vim.lsp.config("eslint", {
      --   capabilities = capabilities,
      --   cmd = { "pnpm", "pnp-vscode-eslint-language-server", "--stdio" },
      -- })

      -- vim.lsp.config("jsonls", {
      --   capabilities = capabilities,
      --   cmd = { "pnpm", "pnp-vscode-json-language-server", "--stdio" },
      -- })

      vim.lsp.config("sorbet", {
        capabilities = capabilities,
        filetypes = { "ruby" },
        cmd = { "bundle", "exec", "srb", "typecheck", "--lsp", "--enable-experimental-lsp-signature-help" },
      })

      -- vim.lsp.config("steep", {
      --   capabilities = capabilities,
      --   filetypes = { "ruby", "eruby", "rbs" },
      --   cmd = { "bundle", "exec", "steep", "langserver" },
      -- })

      local function add_ruby_deps_command(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
          local params = vim.lsp.util.make_text_document_params()
          local showAll = opts.args == "all"

          client.request("rubyLsp/workspace/dependencies", params, function(error, result)
            if error then
              print("Error showing deps: " .. error)
              return
            end

            local qf_list = {}
            for _, item in ipairs(result) do
              if showAll or item.dependency then
                table.insert(qf_list, {
                  text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
                  filename = item.path,
                })
              end
            end

            vim.fn.setqflist(qf_list)
            vim.cmd("copen")
          end, bufnr)
        end, {
          nargs = "?",
          complete = function()
            return { "all" }
          end,
        })
      end

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = {
              command = "clippy",
              -- Optional: Add extra arguments for Clippy, e.g., to treat warnings as errors
              -- extraArgs = { "-- -D warnings" },
            },
            -- Optional: Enable diagnostics on save
            checkOnSave = true,
          },
        },
      })

      vim.lsp.config("ruby_lsp", {
        capabilities = capabilities,
        cmd = { "bundle", "exec", "ruby-lsp" },
        on_attach = function(client, buffer)
          add_ruby_deps_command(client, buffer)
        end,
        -- init_options = {
        --   enabledFeatures = {
        --     "codeActions",
        --     -- "codeLens",
        --     -- "completion",
        --     -- "definition",
        --     "diagnostics",
        --     "documentHighlights",
        --     -- "documentLink",
        --     "documentSymbols",
        --     -- "foldingRanges",
        --     "formatting",
        --     -- "hover",
        --     "inlayHint",
        --     -- "onTypeFormatting",
        --     -- "references",
        --     -- "selectionRanges",
        --     -- "semanticHighlighting"
        --     -- "workspaceSymbol",
        --   },
        -- },
      })

      -- vim.lsp.config("stylelint_lsp", {
      --   capabilities = capabilities,
      --   cmd = { "pnpm", "pnp-stylelint-lsp", "--stdio" },
      --   filetypes = {
      --     "css",
      --     "less",
      --     "postcss",
      --     "scss",
      --   },
      --   settings = {
      --     stylelintplus = {
      --       enable = true,
      --       autoFixOnFormat = true,
      --       cssInJs = false,
      --       validateOnType = true,
      --     },
      --   },
      -- })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
        end,
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
            diagnostics = {
              neededFileStatus = {
                ["codestyle-check"] = "Any",
              },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("ts_ls", {
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
            quotePreference = "double",
          },
        },
        settings = {
          typescript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              semicolons = "ignore",
            },
          },
          javascript = {
            format = {
              insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
              insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
              semicolons = "ignore",
            },
          },
        },
      })
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "codespell",
        -- "eslint-lsp",
        -- "json-lsp",
        "hadolint",
        "helm-ls",
        "herb-language-server",
        "openscad-lsp",
        "prettierd",
        "shfmt",
        "shellcheck",
        "stylua",
        "sql-formatter",
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
          "bashls",
          "dockerls",
          -- "eslint",
          -- "hadolint",
          -- "jsonls",
          -- "ruby_lsp", -- add to project Gemfile instead
          "rust_analyzer",
          -- "sorbet", -- add to project Gemfile instead
          -- "stylelint_lsp",
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
