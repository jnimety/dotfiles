return {
  "ckolkey/ts-node-action",
  dependencies = {
    "nvim-treesitter",
    "tpope/vim-repeat",
  },
  opts = {},
  config = function()
    vim.keymap.set({ "n" }, "<leader>na", require("ts-node-action").node_action, { desc = "Trigger [N]ode [A]ction" })
  end,
}
