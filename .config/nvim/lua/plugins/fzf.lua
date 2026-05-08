local function pick(command, opts)
  return function()
    Snacks.picker.pick(command, opts)
  end
end

local kind_filter = {
  default = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Package",
    "Property",
    "Struct",
    "Trait",
  },
  markdown = false,
  help = false,
  -- you can specify a different filter for each filetype
  lua = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    -- "Package", -- remove package since luals uses it for control flow structures
    "Property",
    "Struct",
    "Trait",
  },
}

local function get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if kind_filter == false then
    return
  end
  if kind_filter[ft] == false then
    return
  end
  if type(kind_filter[ft]) == "table" then
    return kind_filter[ft]
  end
  return type(kind_filter) == "table" and type(kind_filter.default) == "table" and kind_filter.default or nil
end

local function symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then
    return true
  end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return {
  "ibhagwan/fzf-lua",
  dependencies = { "folke/snacks.nvim" },
  keys = {
    {
      "<leader>,",
      "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
    { "<leader>/", "<cmd>FzfLua grep_curbuf<cr>", desc = "[S]earch in [B]uffer" },
    { "<leader><space>", pick("files"), desc = "Find files" },
    { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "[F]ind [B]uffer" },
    { "<leader>ff", pick("files"), desc = "[F]ind [F]iles" },
    { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "[S]earch in [B]uffer" },
    { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "[S]earch [D]iagnostics" },
    { "<leader>sg", pick("live_grep"), desc = "[S]earch by [G]rep (root dir)" },
    { "<leader>sG", pick("live_grep", { root = false }), desc = "[S]earch [G]rep (cwd)" },
    { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "[S]earch [H]elp" },
    { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "[S]earch [R]esume" },
    { "<leader>sw", pick("grep_cword"), desc = "[S]earch current [W]ord (root dir)" },
    { "<leader>sW", pick("grep_cword", { root = false }), desc = "[S]earch current [W]ord (cwd)" },
    {
      "<leader>ss",
      function()
        require("fzf-lua").lsp_document_symbols({ regex_filter = symbols_filter })
      end,
      desc = "Goto Symbol",
    },
    {
      "<leader>sS",
      function()
        require("fzf-lua").lsp_live_workspace_symbols({ regex_filter = symbols_filter })
      end,
      desc = "Goto Symbol (Workspace)",
    },
  },
}
