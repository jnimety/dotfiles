local M = {}

local defaults = {
  icons = {
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    lualine = {
      modified = " ",
      readonly = " ",
      unnamed = "",
      time = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
      add = "+",
      change = "~",
      delete = "_",
      topdelete = "‾",
      changedelete = "~",
    },
    telescope = {
      prompt_prefix = " ",
      selection_caret = " ",
    },
    kinds = {
      Array = " ",
      Boolean = " ",
      Class = "ﴯ ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = "",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = "ﰠ ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = "ﳠ ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = "ﰠ ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = "פּ ",
      Text = " ",
      TypeParameter = " ",
      Unit = "塞",
      Value = " ",
      Variable = " ",
    },
  },
}

setmetatable(M, {
  __index = function(_, key)
    return vim.deepcopy(defaults)[key]
  end,
})

return M
