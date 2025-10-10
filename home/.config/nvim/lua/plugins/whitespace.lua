return {
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.trailspace").setup(opts)

      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*",
        callback = function()
          require("mini.trailspace").trim()
          require("mini.trailspace").trim_last_lines()
        end,
      })

      vim.api.nvim_create_autocmd(
        { "BufRead", "BufNewFile" },
        { pattern = "db/structure.sql", command = "lua vim.b.minitrailspace_disable=true" }
      )
    end,
  },
}
