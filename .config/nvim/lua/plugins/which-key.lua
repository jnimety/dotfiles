return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = { spelling = true },
    -- key_labels = { ["<leader>"] = "SPC" },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  -- config = function(_, opts)
  --   local wk = require "which-key"
  --   wk.setup { opts }
  --   wk.register({
  --     mode = { "n", "v" },
  --     ["g"] = { name = "+goto" },
  --     ["]"] = { name = "+next" },
  --     ["["] = { name = "+prev" },
  --     ["<leader>b"] = { name = "+buffer" },
  --     ["<leader>c"] = { name = "+code" },
  --     ["<leader>d"] = { name = "+debug" },
  --     ["<leader>f"] = { name = "+file" },
  --     ["<leader>g"] = { name = "+git" },
  --     ["<leader>h"] = { name = "+help" },
  --     ["<leader>n"] = { name = "+noice" },
  --     ["<leader>o"] = { name = "+open" },
  --     ["<leader>q"] = { name = "+quit/session" },
  --     ["<leader>s"] = { name = "+search" },
  --     ["<leader>t"] = { name = "+toggle" },
  --     ["<leader>x"] = { name = "+diagnostics/quickfix" },
  --     ["<leader>w"] = { name = "+windows" },
  --     ["<leader><tab>"] = { name = "+tabs" },
  --   })
  -- end
}
