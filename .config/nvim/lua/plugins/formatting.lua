return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true })
      end,
      mode = "",
      desc = "[C]ode [F]ormat Buffer",
    },
  },
  -- Everything in opts will be passed to setup()
  opts = {
    notify_on_error = true,
    -- log_level = vim.log.levels.DEBUG,
    -- Define your formatters
    formatters_by_ft = {
      -- ["css"] = { lsp_format = "first" },
      ["eruby"] = { "rustywind", lsp_format = "last" },
      ["gitcommit"] = { "codespell" },
      -- ["graphql"] = { "prettierd" },
      -- ["handlebars"] = { "prettierd" },
      -- ["helm"] = { "yamlfmt" }, -- can't get the regexp_exclude option to work
      -- ["html"] = { "prettierd" },
      ["less"] = { "prettierd" },
      ["lua"] = { "stylua" },
      ["markdown"] = { "codespell", "prettierd" },
      ["markdown.mdx"] = { "prettierd" },
      ["ocaml"] = { "ocamlformat" },
      -- ["scss"] = { "prettierd" },
      ["sql"] = { "sql_formatter" },
      ["terraform"] = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      ["text"] = { "codespell" },
      ["tf"] = { "terraform_fmt" },
      ["yaml"] = { "yamlfmt" },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- Set up format-on-save
    format_on_save = { timeout_ms = 500 },
    -- Customize formatters
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
      -- erb_format = { prepend_args = { "--print-width", "999" } },
      sql_formatter = {
        prepend_args = function(_, ctx)
          local config_file = vim.fs.find({ ".sql-formatter.json" }, { upward = true, path = ctx.dirname })[1]

          if config_file then
            return { "--config", config_file }
          else
            return {}
          end
        end,
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
