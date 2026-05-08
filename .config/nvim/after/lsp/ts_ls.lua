---@type vim.lsp.Config
return {
  init_options = {
    preferences = {
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      quotePreference = "double",
    },
  },
  settings = {
    typescript = {
      format = {
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        semicolons = "ignore",
      },
    },
    javascript = {
      format = {
        insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = false,
        insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
        semicolons = "ignore",
      },
    },
  },
}
