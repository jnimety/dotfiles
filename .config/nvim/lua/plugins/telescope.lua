-- useful default mappings
-- <C-x> go to file selection as a split
-- <C-v> go to file selection as a vsplit
-- <C-t> go to a file in a new tab

-- local current_buffer_fuzzy_find = function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
--     winblend = 10,
--     previewer = false,
--   }))
-- end
--
-- local search_lsp_document_symbols = function()
--   require("telescope.builtin").lsp_document_symbols({
--     symbols = {
--       "Class",
--       "Function",
--       "Method",
--       "Constructor",
--       "Interface",
--       "Module",
--       "Struct",
--       "Trait",
--       "Field",
--       "Property",
--     },
--   })
-- end
--
-- return {
--   -- Fuzzy Finder (files, lsp, etc)
--   {
--     "nvim-telescope/telescope.nvim",
--     cmd = "Telescope",
--     version = false,
--     dependencies = {
--       "nvim-lua/plenary.nvim",
--       {
--         -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
--         "nvim-telescope/telescope-fzf-native.nvim",
--         build = "make",
--         cond = vim.fn.executable("make") == 1,
--       },
--     },
--     opts = {
--       defaults = {
--         mappings = {
--           i = {
--             ["<C-u>"] = false,
--             ["<C-d>"] = false,
--           },
--         },
--         prompt_prefix = require("defaults").icons.telescope.prompt_prefix,
--         selection_caret = require("defaults").icons.telescope.selection_caret,
--       },
--     },
--     keys = {
--       { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
--       { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
--       { "<leader>/", current_buffer_fuzzy_find, desc = "Fuzzy search in current buffer" },
--       { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]ind [F]iles" },
--       { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
--       { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
--       { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
--       { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" },
--       { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
--       { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
--       { "<leader>ss", search_lsp_document_symbols, desc = "Goto Symbol" },
--
--       -- More examples
--       -- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" ),
--       -- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" ),
--       -- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" ),
--       -- { "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" ),
--       -- { "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" ),
--       -- { "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" ),
--       -- { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" ),
--       -- { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" ),
--       -- { "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" ),
--       -- { "<leader>hs", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" ),
--       -- { "<leader>ht", "<cmd>Telescope builtin<cr>", desc = "Telescope" ),
--       -- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" ),
--     },
--     config = function(_, opts)
--       require("telescope").setup(opts)
--
--       -- Enable telescope fzf native, if installed
--       pcall(require("telescope").load_extension, "fzf")
--       pcall(require("telescope").load_extension, "notify")
--     end,
--   },
-- }

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
  -- optional for icon support
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
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
