local node_path = '/usr/local/lib/node_modules/'

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
        location = node_path .. '@vue/language-server',
        languages = { "vue" },
      },
      {
        name = '@styled/typescript-styled-plugin',
        location = node_path .. '@styled/typescript-styled-plugin',
        languages = { 'tsx', 'jsx' },
      },
    },
  },
  root_markers = { '.git', 'package-lock.json' },
}
