vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.filetype.add({
  extension = {
    http = 'http',
  },
})

-- global settings

-- vscode and nvim only settings
if vim.g.vscode then
  require('vsc')
else
  require('nvim')
end
