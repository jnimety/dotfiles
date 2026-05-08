return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mason-org/mason.nvim",
      "jay-babu/mason-null-ls.nvim",
    },
    opts = function()
      local null_ls = require("null-ls")

      return {
        sources = {
          null_ls.builtins.diagnostics.fish,
          null_ls.builtins.diagnostics.terraform_validate,
        },
      }
    end,
  },
}
