local styled_components_path = '/usr/local/bin/node_modules/@styled/typescript-styled-plugin'

-- The Docs suggest that this is needed, from my expermentation, it's not making any
-- difference.
require('lspconfig').volar.setup({})

return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { "vue", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = '/usr/local/lib/node_modules/@vue/language-server',
        languages = { "vue" },
      },
      {
        name = '@styled/typescript-styled-plugin',
        location = styled_components_path,
        languages = { 'tsx', 'jsx' },
      },
    },
  },
  root_markers = { 'package.json' },
  single_file_support = false,
}
