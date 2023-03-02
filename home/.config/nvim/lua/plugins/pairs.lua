return {
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\][^%a]' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\][^%a]' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\][^%a]' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\][^%a]' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\][^%a]' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\][^%a]' },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\][^%a]', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\][^%a]', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\][^%a]', register = { cr = false } },
      }
    },
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}
