-- Point basedpyright at the project's venv: an in-project .venv (uv, poetry)
-- wins, otherwise fall back to an activated $VIRTUAL_ENV.
local function venv_python(root_dir)
  local candidates = {}
  if root_dir then
    table.insert(candidates, root_dir .. "/.venv/bin/python")
  end
  if vim.env.VIRTUAL_ENV then
    table.insert(candidates, vim.env.VIRTUAL_ENV .. "/bin/python")
  end

  for _, python in ipairs(candidates) do
    if vim.uv.fs_stat(python) then
      return python
    end
  end
end

---@type vim.lsp.Config
return {
  before_init = function(_, config)
    local python = venv_python(config.root_dir)
    if python then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        python = { pythonPath = python },
      })
    end
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- ruff handles imports
      analysis = {
        typeCheckingMode = "standard",
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
