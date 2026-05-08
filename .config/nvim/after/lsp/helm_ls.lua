---@type vim.lsp.Config
return {
  settings = {
    ["helm-ls"] = {
      yamlls = {
        path = vim.fn.stdpath("data") .. "/mason/bin/yaml-language-server",
      },
    },
  },
}
