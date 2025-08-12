vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.filetype.add({
  extension = {
    http = 'http',
  },
})

require('options')
require('keymaps')
require('wezterm-nav')
require('autocmd')
require('lazy-bootstrap')
require('lazy-plugins')

-- INFO: Will take all the lua files in the lsp dir and enable them, otherwise you'll have
-- to specify them manually.
local lsp_files = vim.fn.glob(vim.fn.stdpath('config') .. '/lsp/*.lua', false, true)
local lsps_table = {}
for _, filepath in ipairs(lsp_files) do
  local filename = vim.fn.fnamemodify(filepath, ':t')
  local name_without_ext = string.gsub(filename, '%.lua$', '')
  table.insert(lsps_table, name_without_ext)
end

vim.lsp.enable(lsps_table)
