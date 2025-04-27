require('options')
require('keymaps')
require('wezterm-nav')
require('autocmd')
require('lazy-bootstrap')
require('lazy-plugins')

vim.lsp.enable({
  'eslint',
  'lua_ls',
  'prisma_ls',
  'typescript_ls'
})
