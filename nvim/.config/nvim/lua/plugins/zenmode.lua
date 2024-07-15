return {
  'folke/zen-mode.nvim',
  config = function()
    require('zen-mode').setup()
    vim.keymap.set('n', '<leader>z', ':ZenMode<CR>', { noremap = true, silent = true, desc = 'Zen Mode' })
  end,
}
