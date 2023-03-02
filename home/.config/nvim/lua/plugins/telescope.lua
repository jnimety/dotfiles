-- useful default mappings
-- <C-x> go to file selection as a split
-- <C-v> go to file selection as a vsplit
-- <C-t> go to a file in a new tab

local current_buffer_fuzzy_find = function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(
    require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    }
  )
end

local search_lsp_document_symbols = function()
  require('telescope.builtin').lsp_document_symbols {
    symbols = {
      "Class",
      "Function",
      "Method",
      "Constructor",
      "Interface",
      "Module",
      "Struct",
      "Trait",
      "Field",
      "Property",
    },
  }
end

return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    cmd = "Telescope",
    version = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = vim.fn.executable 'make' == 1
      },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
        prompt_prefix = require("defaults").icons.telescope.prompt_prefix,
        selection_caret = require("defaults").icons.telescope.selection_caret,
      },
    },
    keys = {
      { '<leader><space>', "<cmd>Telescope buffers<cr>", desc = 'Find buffer' },
      { '<leader>fb', "<cmd>Telescope buffers<cr>", desc = 'Find buffer' },
      { '<leader>/', current_buffer_fuzzy_find, desc = 'Fuzzy search in current buffer' },
      { '<leader>ff', "<cmd>Telescope find_files<cr>", desc = '[F]ind [F]iles' },
      { '<leader>sh', "<cmd>Telescope help_tags<cr>", desc = '[S]earch [H]elp' },
      { '<leader>sw', "<cmd>Telescope grep_string<cr>", desc = '[S]earch current [W]ord' },
      { '<leader>sg', "<cmd>Telescope live_grep<cr>", desc = '[S]earch by [G]rep' },
      { '<leader>sd', "<cmd>Telescope diagnostics<cr>", desc = '[S]earch [D]iagnostics' },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>ss", search_lsp_document_symbols, desc = "Goto Symbol" },

      -- More examples
      -- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" ),
      -- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" ),
      -- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" ),
      -- { "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" ),
      -- { "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" ),
      -- { "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" ),
      -- { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" ),
      -- { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" ),
      -- { "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" ),
      -- { "<leader>hs", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" ),
      -- { "<leader>ht", "<cmd>Telescope builtin<cr>", desc = "Telescope" ),
      -- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" ),
    },
    config = function(_, opts)
      require('telescope').setup(opts)

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require("telescope").load_extension, 'notify')
    end

  },
}
