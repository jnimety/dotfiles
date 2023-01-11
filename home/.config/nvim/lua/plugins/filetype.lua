-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

return {
  "nathom/filetype.nvim",
  opts = {
    overrides = {
      extensions = {
        tf = "terraform",
        tfvars = "terraform",
        tfstate = "json",
        rbi = "ruby",
      },

      function_literal = {
        gitcommit = function()
          vim.opt_local.wrap = false
          vim.opt_local.spell = true
        end,

        markdown = function()
          vim.opt_local.wrap = true
          vim.opt_local.spell = true
        end,

        -- Temporary, not quite perfect, workaround for:
        -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
        -- https://github.com/tree-sitter/tree-sitter-ruby/issues/230
        ruby = function()
          vim.cmd [[ setlocal indentkeys-=. ]]
        end,
      },
    },
  },
}
