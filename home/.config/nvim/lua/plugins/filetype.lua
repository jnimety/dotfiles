-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    --  "man",
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "ruby",
  },
  callback = function(_)
    -- Temporary, not quite perfect, workaround for:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
    -- https://github.com/tree-sitter/tree-sitter-ruby/issues/230
    vim.cmd [[ setlocal indentkeys-=. ]]
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "gitcommit",
    "markdown",
    "txt"
  },
  callback = function(_)
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

return {
  "nathom/filetype.nvim",
  opts = {
    overrides = {
      complex = {
        ["%.gitignore"] = "gitignore",
        ["%.gitattributes"] = "gitattributes",
      },
      extensions = {
        tf = "terraform",
        tfvars = "terraform",
        tfstate = "json",
        rbi = "ruby",
        inky = "eruby",
      },
    },
  },
}
