---@type vim.lsp.Config
return {
  filetypes = { "ruby" },
  cmd = { "bundle", "exec", "srb", "typecheck", "--lsp", "--enable-experimental-lsp-signature-help" },
}
