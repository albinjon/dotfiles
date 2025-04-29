return {
  cmd = { 'lua-language-server' },
  settings = {
    Lua = {
      completion = { callSnippet = 'Replace' },
      diagnostics = { disable = { 'missing-fields' }, globals = { 'vim' } },
      workspace = { checkThirdParty = false },
    },
  },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc' },
}
