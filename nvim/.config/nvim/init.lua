vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require('options')
require('keymaps')
require('autocmd')
require('lazy-bootstrap')

if vim.g.started_by_firenvim == true then
  require('firenvim')
else
  require('lazy-plugins')
end

-- The line beneath this is called modeline. See :help modeline
-- vim: ts=2 sts=2 sw=2 et
