vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

require('options')
require('keymaps')
require('wezterm-nav')
require('autocmd')
require('lazy-bootstrap')
require('lazy-plugins')

-- The line beneath this is called modeline. See :help modeline
