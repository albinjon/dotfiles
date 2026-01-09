-- npm i -g @vtsls/language-server @vue/language-server @styled/typescript-styled-plugin

local function path_exists(p)
  return vim.uv.fs_stat(p) ~= nil
end

local node_path = vim.fn.system({ 'which', 'node' }):gsub('%s+', '')
local modules_path = vim.fn.fnamemodify(node_path, ':h:h') .. '/lib/node_modules/'

-- local is_next = path_exists('next.config.js')
-- local next_path = vim.fn.getcwd() .. '/node_modules/typescript/lib/tsserver.js'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = modules_path .. '@vue/language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}

local styled_plugin = {
  name = '@styled/typescript-styled-plugin',
  location = modules_path .. '@styled/typescript-styled-plugin',
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

  settings = {
    vtsls = {
      tsserver = { globalPlugins = { vue_plugin, styled_plugin }, plugin_paths = { '.' } },
      autoUseWorkspaceTsdk = true,
    },
  },
}
