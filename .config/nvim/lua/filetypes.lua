-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    --  "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "ruby",
  },
  callback = function(_)
    -- Temporary, not quite perfect, workaround for:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
    -- https://github.com/tree-sitter/tree-sitter-ruby/issues/230
    vim.cmd([[ setlocal indentkeys-=. ]])
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "gitcommit",
    "markdown",
    "txt",
  },
  callback = function(_)
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function(_)
    -- Single-line commit messages: don't hard-wrap as I type.
    vim.opt_local.textwidth = 0
    vim.opt_local.formatoptions:remove("t")
  end,
})

-- Always land on the first line, first column. Something (still unidentified
-- despite extensive tracing: not the shada '"' mark, not a Lua-traceable
-- callback, not mouse/keyboard input) reliably relocates the cursor a beat
-- after the UI attaches -- observed ~80ms after UIEnter, before any
-- TermResponse. A one-shot reset on BufEnter/BufWinEnter isn't late enough to
-- beat it, so instead run a short self-correcting guard: for ~500ms after the
-- buffer becomes current, snap any stray CursorMoved back to the top. It
-- disengages the instant real editing starts (InsertEnter/TextChanged), so it
-- never fights an intentional cursor move once you're actually writing.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].filetype ~= "gitcommit" then
      return
    end
    local buf = args.buf
    local function to_top()
      pcall(vim.api.nvim_win_set_cursor, 0, { 1, 0 })
    end
    to_top()
    vim.schedule(to_top)

    local group = vim.api.nvim_create_augroup("gitcommit_cursor_guard_" .. buf, { clear = true })
    local timer = vim.uv.new_timer()
    local function disengage()
      pcall(vim.api.nvim_del_augroup_by_id, group)
      if not timer:is_closing() then
        timer:stop()
        timer:close()
      end
    end
    vim.api.nvim_create_autocmd({ "InsertEnter", "TextChanged", "TextChangedI" }, {
      group = group,
      buffer = buf,
      once = true,
      callback = disengage,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = buf,
      callback = function()
        local cur = vim.api.nvim_win_get_cursor(0)
        if cur[1] ~= 1 or cur[2] ~= 0 then
          pcall(vim.api.nvim_win_set_cursor, 0, { 1, 0 })
        end
      end,
    })
    timer:start(500, 0, function()
      vim.schedule(disengage)
    end)
  end,
})

vim.filetype.add({
  pattern = {
    ["%.gitignore"] = "gitignore",
    ["%.gitattributes"] = "gitattributes",
  },
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    tfstate = "json",
    rbi = "ruby",
    inky = "eruby",
  },
})
