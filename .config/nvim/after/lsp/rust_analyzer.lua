---@type vim.lsp.Config
return {
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
}
