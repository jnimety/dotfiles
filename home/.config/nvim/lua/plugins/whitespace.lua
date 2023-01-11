vim.api.nvim_create_autocmd(
  { "BufRead", "BufNewFile" },
  { pattern = "db/structure.sql", command = "lua vim.g.DeleteTrailingWhitespace = 0" }
)
vim.g.DeleteTrailingWhitespace = 1
vim.g.DeleteTrailingWhitespace_Action = 'delete'
vim.g.ShowTrailingWhitespace = 1

return {
  'vim-scripts/DeleteTrailingWhitespace',
  'vim-scripts/ShowTrailingWhitespace',
}
