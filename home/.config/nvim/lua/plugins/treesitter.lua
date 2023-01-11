return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ":TSUpdate",
  event = "BufReadPost",
  dependencies = {
    -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    'RRethy/nvim-treesitter-endwise',
    'nvim-treesitter/playground',
  },
  opts = {
    -- A list of parser names, or "all"
    ensure_installed = {
      "bash",
      -- NOTE: css might have a trojan: https://github.com/tree-sitter/tree-sitter-css/issues/35
      -- "css",
      "diff",
      "dockerfile",
      "git_rebase",
      "gitcommit",
      "help",
      "html",
      "javascript",
      "json",
      "lua",
      "ruby",
      "rust",
      "scss",
      "typescript",
      "vim",
      "yaml",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,
    auto_install = true,
    -- NOTE: see note above about potential css trojan
    ignore_install = { "css" },
    endwise = {
      enable = true,
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<c-backspace>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      playground = {
        enable = true,
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  },
  config = function(_, opts)
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false

    require('nvim-treesitter').setup()
    require("nvim-treesitter.configs").setup(opts)
  end
}
