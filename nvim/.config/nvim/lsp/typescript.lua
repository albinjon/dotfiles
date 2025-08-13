-- REQUIRED: install globally (or point to your local paths)
-- npm i -g @vtsls/language-server @vue/language-server @styled/typescript-styled-plugin

local node_path = '/opt/homebrew/lib/node_modules/'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = node_path .. '@vue/language-server',
  languages = { 'vue' },
}

local styled_plugin = {
  name = '@styled/typescript-styled-plugin',
  location = node_path .. '@styled/typescript-styled-plugin',
  languages = { 'typescriptreact', 'javascriptreact', 'tsx', 'jsx' },
}

return {
  cmd = { 'vtsls', '--stdio' },
  filetypes = {
    'vue',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  init_options = {
    -- typescript = { tsdk = '/usr/local/lib/node_modules/typescript/lib' }, -- optional
  },
  settings = {
    vtsls = {
      tsserver = { globalPlugins = { vue_plugin, styled_plugin } },
    },
  },
}
