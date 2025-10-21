return { -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  version = false,
  build = ":TSUpdate",
  lazy = false,
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
  keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<c-backspace>", desc = "Decrement selection", mode = "x" },
  },
  dependencies = {
    -- Additional text objects via treesitter
    { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    "RRethy/nvim-treesitter-endwise",
  },
  opts = {
    ensure_installed = {
      "bash",
      "css",
      "diff",
      "dockerfile",
      "embedded_template",
      "fish",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "hcl",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "markdown_inline",
      "ocaml",
      "query",
      "regex",
      "ruby",
      "rust",
      "sql",
      "tera",
      "terraform",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").install(opts.ensure_installed, { summary = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter.setup", {}),
      callback = function(args)
        local buf = args.buf
        local filetype = args.match

        -- avoid running on buffers that do not correspond to a supported tree-sitter language
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
          return
        end

        -- enable highlighting
        vim.treesitter.start(buf, language)

        -- enable indents
        local noIndent = {}
        if not vim.list_contains(noIndent, args.match) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        -- enable folds
        local noFold = {}
        if not vim.list_contains(noFold, args.match) then
          vim.opt.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          vim.opt.foldenable = false
        end
      end,
    })
  end,
}
